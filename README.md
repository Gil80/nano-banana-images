# nano-banana-images

An AI image generation toolkit for creating photorealistic images from structured prompts, with support for reference image input to preserve identity and style. Built around the Kie.ai nano-banana-2 model, with fallback support for local and free cloud alternatives.

![Demo](demo/demo.gif)

## Architecture

![Architecture](docs/architecture.svg)

## What It Does

Submit a JSON prompt file with a detailed text description, optional reference images, and generation parameters — and get back a high-resolution photorealistic image. The toolkit handles image upload, API calls, polling for completion, and downloading the result.

Prompts are structured like a photography brief: lens, aperture, lighting, depth of field, negative constraints. This level of detail produces consistent, high-quality outputs and enables iterative refinement across versions.

## Backends

| Script | Provider | API Key | Quality | Speed |
|--------|----------|---------|---------|-------|
| `generate_kie.py` | Kie.ai (nano-banana-2) | Required | Highest | Fast |
| `generate_sdxl.py` | Puter.ai (SDXL) | None | Good | Fast |
| `generate_local.py` | Local SDXL (diffusers) | None | Good | Slow |
| `generate_hf.py` | Hugging Face | Required | Good | Varies |

## Project Structure

```
nano-banana-images/
├── scripts/
│   ├── generate_kie.py       # Primary: Kie.ai nano-banana-2
│   ├── generate_sdxl.py      # Free cloud: Puter.ai SDXL
│   ├── generate_local.py     # Free local: SDXL via diffusers
│   └── generate_hf.py        # Hugging Face Spaces
├── prompts/
│   └── *.json                # Structured prompt definitions
├── images/
│   └── *.jpg / *.png         # Reference inputs + generated outputs
├── .env                      # API keys (not committed)
└── requirements.txt
```

## Quick Start

```bash
git clone https://github.com/Gil80/nano-banana-images.git
cd nano-banana-images
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
```

Copy `.env.example` to `.env` and add your API key:

```
KIE_API_KEY=your_key_here
```

Run with a prompt file:

```bash
python scripts/generate_kie.py prompts/pilot_f15e.json images/output.jpg
```

Or use a free backend with no API key:

```bash
python scripts/generate_sdxl.py "candid portrait, natural light, 85mm lens" images/output.jpg
```

## Prompt Format

Prompts are JSON files that act as a photography brief:

```json
{
  "prompt": "Detailed photorealistic description, lens, lighting, style...",
  "negative_prompt": "blurry, watermark, oversaturated, studio lighting...",
  "image_input": ["images/reference.jpg"],
  "api_parameters": {
    "resolution": "2K",
    "output_format": "jpg",
    "aspect_ratio": "3:4"
  }
}
```

`image_input` is optional — when provided, the model uses it to preserve identity or style in the output.

## How It Works (Kie.ai flow)

```
1. Load prompt JSON
2. Upload reference images → get hosted URLs
3. Submit generation task → receive task ID
4. Poll for completion (every 5s, up to 5 min)
5. Download result image
```

## Key Concepts

- **Reference image input** — provide a portrait or photo and the model preserves facial features, style, or composition in the generated output
- **Structured prompts** — JSON format with explicit photography settings (focal length, aperture, lighting direction) for reproducible, controllable results
- **Iterative refinement** — version your prompt files (`v1`, `v1b`, `v1c`) to track what changes improve output quality
- **Multi-backend** — swap providers without changing your prompt files

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `KIE_API_KEY` | For Kie.ai | Kie.ai API key |
| `HF_TOKEN` | For HF mode | Hugging Face token |

## License

MIT
