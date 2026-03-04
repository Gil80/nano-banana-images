#!/usr/bin/env python3
"""
Free Stable Diffusion XL via Puter.js - no API key needed!
Usage: python scripts/generate_sdxl.py <prompt> <output.jpg>
"""

import sys
import json
import requests
from pathlib import Path


def generate(prompt: str, output_path: str):
    url = "https://api.puter.ai/v2/image/generate"
    
    payload = {
        "model": "stabilityai/stable-diffusion-xl-base-1.0",
        "prompt": prompt,
        "width": 1024,
        "height": 1024,
        "num_inference_steps": 30,
        "guidance_scale": 7.5,
    }

    print(f"Generating with SDXL (free, no API key)...")
    print(f"Prompt: {prompt}")

    try:
        response = requests.post(url, json=payload, timeout=120)
        
        if response.status_code != 200:
            print(f"Error: {response.status_code}")
            print(response.text)
            sys.exit(1)

        data = response.json()
        
        if "image_url" in data:
            img_url = data["image_url"]
        elif "images" in data and data["images"]:
            img_url = data["images"][0]
        else:
            print(f"Response: {json.dumps(data, indent=2)}")
            print("Could not find image URL in response")
            sys.exit(1)

        # Download the image
        img_response = requests.get(img_url)
        img_response.raise_for_status()

        Path(output_path).parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, "wb") as f:
            f.write(img_response.content)
        
        print(f"Image saved to: {output_path}")
        
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python generate_sdxl.py <prompt> <output.jpg>")
        sys.exit(1)

    prompt = sys.argv[1]
    output = sys.argv[2]

    generate(prompt, output)
