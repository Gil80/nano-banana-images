#!/usr/bin/env python3
"""
Hugging Face image generator via free HF Space.
Usage: python scripts/generate_hf.py <prompt> <output.jpg> [model]
"""

import sys
import os
import requests
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

HF_TOKEN = os.getenv("HF_TOKEN") or os.getenv("HUGGING_FACE_TOKEN")

MODELS = {
    "sdxl": "https://fake-sdxl.hf.space",
    "sd15": "https://runwayml/stable-diffusion-v1-5",
    "flux": "https://black-forest-labs-flux-1-schnell.hf.space",
}

FALLBACK_SPACES = [
    "https://multimodalart-stable-diffusion-v1-5.hf.space",
    "https://stabilityai-stable-diffusion-xl-base-1-0.hf.space",
]


def generate(prompt: str, output_path: str, model: str = None):
    if not HF_TOKEN:
        print("Error: HF_TOKEN not set.")
        sys.exit(1)

    headers = {"Authorization": f"Bearer {HF_TOKEN}"}
    
    for space_url in FALLBACK_SPACES:
        try:
            print(f"Trying {space_url}...")
            api_url = f"{space_url}/infer"
            
            payload = {
                "inputs": prompt,
                "parameters": {
                    "negative_prompt": "blurry, low quality, distorted, deformed, ugly, bad anatomy",
                    "num_inference_steps": 25,
                    "guidance_scale": 7.5,
                }
            }

            response = requests.post(api_url, headers=headers, json=payload, timeout=60)
            
            if response.status_code == 200:
                Path(output_path).parent.mkdir(parents=True, exist_ok=True)
                with open(output_path, "wb") as f:
                    f.write(response.content)
                print(f"Image saved to: {output_path}")
                return
        except Exception as e:
            print(f"Failed: {e}")
            continue
    
    print("All spaces failed. Hugging Face free inference now requires billing setup.")
    print("Consider using Leonardo.ai or Replicate instead.")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python generate_hf.py <prompt> <output.jpg>")
        sys.exit(1)

    prompt = sys.argv[1]
    output = sys.argv[2]

    generate(prompt, output, None)
