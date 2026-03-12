# nano-banana-images

AI image generation toolkit using structured JSON prompts with multiple backends.

## Project Structure
- `scripts/` — Generation scripts (one per backend)
- `prompts/` — Structured JSON prompt files
- `images/` — Reference images and generated output
- `docs/` — Architecture diagrams
- `demo/` — Demo recordings

## Setup & Run
- Python 3.12, venv in `.venv/`
- API keys in `.env` (never commit)
- Primary backend: `python scripts/generate_kie.py prompts/<file>.json images/output.jpg`
- Free alternative: `python scripts/generate_sdxl.py "<prompt>" images/output.jpg`
- Gemini direct: `python scripts/generate_gemini.py prompts/<file>.json images/output.jpg`

## Prompt Construction
- **Always consult `prompts/master_prompt_reference.md`** before constructing any prompt. It defines the JSON schema, best practices, and quality standards for producing hyper-realistic outputs.
- The reference guide covers: camera mathematics (lens, aperture, ISO), explicit imperfections, lighting behavior, material physics, negative prompt stacks, and the Dense Narrative vs Deep Grid paradigms.
- Every generated prompt must follow the patterns and quality bar set by the master reference.

## Conventions
- Use `pathlib` for file paths
- Use `python-dotenv` for env vars
- Scripts follow CLI pattern: `python scripts/<script>.py <prompt_source> <output_path>`
- Prompt files use structured JSON with photography parameters (lens, aperture, lighting, DOF)
- Version prompt iterations with suffixes: `_v1`, `_v1b`, `_v1c`, `_v2`

## Environment Variables
- `KIE_API_KEY` — Kie.ai nano-banana-2 (primary)
- `HF_TOKEN` — Hugging Face Spaces (optional)
- `GEMINI_API_KEY` — Google AI Studio (Gemini direct)

## Important
- Never commit `.env` or API keys
- Reference images for identity preservation only work with `generate_kie.py`
