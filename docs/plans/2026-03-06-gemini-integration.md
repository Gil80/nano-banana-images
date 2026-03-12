# Gemini Integration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a `generate_gemini.py` script that calls Google's Gemini API directly using existing JSON prompt files.

**Architecture:** Single script using `google-genai` SDK. Reads JSON prompt, builds content list (text + optional PIL images), calls `generate_content()`, saves output image. No polling — synchronous API.

**Tech Stack:** Python 3.12, `google-genai` SDK, `Pillow`, `python-dotenv`

---

### Task 1: Install dependency

**Step 1: Install google-genai in the venv**

Run:
```bash
source .venv/bin/activate && pip install google-genai
```

Expected: Successfully installed google-genai and dependencies.

---

### Task 2: Add GEMINI_API_KEY to .env

**Step 1: Add the key**

- Modify: `.env`

Add this line (user provides actual key):
```
GEMINI_API_KEY=<user-provides-key>
```

---

### Task 3: Create generate_gemini.py

**Files:**
- Create: `scripts/generate_gemini.py`

**Step 1: Write the script**

```python
#!/usr/bin/env python3
"""
Image generator via Google Gemini API (Nano Banana / gemini-2.5-flash-image).
Usage: python scripts/generate_gemini.py <prompt.json> <output.jpg> [aspect_ratio]
"""

import sys
import json
import os
from pathlib import Path
from dotenv import load_dotenv
from google import genai
from google.genai import types
from PIL import Image

load_dotenv()


def load_prompt(prompt_file: str) -> dict:
    with open(prompt_file) as f:
        return json.load(f)


def build_full_prompt(prompt_data: dict) -> str:
    """Combine prompt and negative_prompt into a single text."""
    text = prompt_data["prompt"]
    negative = prompt_data.get("negative_prompt", "")
    if negative:
        text += f"\n\nAvoid the following: {negative}"
    return text


def build_contents(prompt_data: dict) -> list:
    """Build content list: text + optional reference images."""
    contents = []

    # Add reference images first if present
    image_inputs = prompt_data.get("image_input", [])
    for img_path in image_inputs:
        p = Path(img_path)
        if p.exists() and p.is_file():
            print(f"Loading reference image: {p}")
            contents.append(Image.open(p))
        else:
            print(f"Warning: reference image not found: {img_path}")

    # Add text prompt
    contents.append(build_full_prompt(prompt_data))

    return contents


def generate_image(contents: list, aspect_ratio: str, resolution: str) -> Image.Image:
    """Call Gemini API and return the generated image."""
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        print("Error: GEMINI_API_KEY not set. Add it to your .env file.")
        sys.exit(1)

    client = genai.Client(api_key=api_key)

    config = types.GenerateContentConfig(
        response_modalities=["IMAGE"],
        image_config=types.ImageConfig(
            aspect_ratio=aspect_ratio,
        ),
    )

    print(f"Generating image with aspect ratio: {aspect_ratio}, resolution: {resolution}")
    print("Calling Gemini API (this may take a moment)...")

    response = client.models.generate_content(
        model="gemini-2.5-flash-image",
        contents=contents,
        config=config,
    )

    # Extract image from response
    for part in response.parts:
        if part.inline_data is not None:
            return part.as_image()

    # If no image found, print any text response for debugging
    for part in response.parts:
        if part.text:
            print(f"Model response (text): {part.text}")

    raise RuntimeError("No image returned in API response")


def main():
    if len(sys.argv) < 3:
        print("Usage: python scripts/generate_gemini.py <prompt.json> <output.jpg> [aspect_ratio]")
        sys.exit(1)

    prompt_file = sys.argv[1]
    output_file = sys.argv[2]
    aspect_ratio_override = sys.argv[3] if len(sys.argv) > 3 else None

    prompt_data = load_prompt(prompt_file)
    api_params = prompt_data.get("api_parameters", {})

    aspect_ratio = aspect_ratio_override or api_params.get("aspect_ratio", "1:1")
    resolution = api_params.get("resolution", "1K")

    contents = build_contents(prompt_data)
    image = generate_image(contents, aspect_ratio, resolution)

    Path(output_file).parent.mkdir(parents=True, exist_ok=True)
    image.save(output_file)
    print(f"Image saved to: {output_file}")


if __name__ == "__main__":
    main()
```

**Step 2: Commit**

```bash
git add scripts/generate_gemini.py
git commit -m "feat: add Gemini direct API image generation script"
```

---

### Task 4: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

**Step 1: Add Gemini script to Setup & Run section**

Add after the existing "Free alternative" line:
```
- Gemini direct: `python scripts/generate_gemini.py prompts/<file>.json images/output.jpg`
```

Add to Environment Variables section:
```
- `GEMINI_API_KEY` — Google AI Studio (Gemini direct)
```

**Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: add Gemini script to CLAUDE.md"
```

---

### Task 5: End-to-end test

**Step 1: Run with the woman_jumping_joy prompt (text-only, no reference image)**

```bash
source .venv/bin/activate
python scripts/generate_gemini.py prompts/woman_jumping_joy.json images/gemini_test.jpg
```

Expected: Image saved to `images/gemini_test.jpg`, open and verify quality.

**Step 2: If successful, test with a reference image prompt**

```bash
python scripts/generate_gemini.py prompts/pilot_f15e.json images/gemini_pilot_test.jpg
```

Note: This requires `images/my_portrait.png` to exist. Skip if not available.

**Step 3: Clean up test images**

Remove test outputs or keep for comparison — user's choice.
