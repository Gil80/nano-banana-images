#!/usr/bin/env python3
"""
Local Stable Diffusion XL using diffusers - completely free!
Downloads model on first run.
Usage: python scripts/generate_local.py <prompt> <output.jpg>
"""

import sys
import os
from pathlib import Path
from PIL import Image

os.environ["HF_HUB_OFFLINE"] = "0"


def generate(prompt: str, output_path: str):
    try:
        from diffusers import StableDiffusionXLPipeline
        import torch
    except ImportError as e:
        print(f"Missing dependency: {e}")
        print("Run: pip install diffusers transformers torch")
        sys.exit(1)

    print("Loading SDXL model (first run downloads ~5GB)...")
    
    # Use GPU if available
    device = "cuda" if torch.cuda.is_available() else "cpu"
    print(f"Using device: {device}")
    
    pipe = StableDiffusionXLPipeline.from_pretrained(
        "stabilityai/stable-diffusion-xl-base-1.0",
        torch_dtype=torch.float16 if device == "cuda" else torch.float32,
    )
    pipe = pipe.to(device)

    print(f"Generating image...")
    print(f"Prompt: {prompt}")

    # Generate
    result = pipe(
        prompt=prompt,
        negative_prompt="blurry, low quality, distorted, deformed, ugly, bad anatomy",
        num_inference_steps=25,
        guidance_scale=7.5,
        height=1024,
        width=1024,
    )

    image = result.images[0]

    Path(output_path).parent.mkdir(parents=True, exist_ok=True)
    image.save(output_path)
    
    print(f"Image saved to: {output_path}")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python generate_local.py <prompt> <output.jpg>")
        sys.exit(1)

    prompt = sys.argv[1]
    output = sys.argv[2]

    generate(prompt, output)
