# Gemini Direct Integration Design

**Date:** 2026-03-06
**Status:** Approved

## Goal

Replace Kie.ai dependency with direct Google Gemini API calls using the `google-genai` SDK. Same JSON prompt format, no Kie.ai credits needed.

## Model

`gemini-2.5-flash-image` — this is the same Nano Banana model that Kie.ai wraps.

## JSON Field Mapping

| JSON field | Gemini mapping |
|---|---|
| `prompt` | Text content |
| `negative_prompt` | Appended as "Avoid: ..." (no native negative prompt support) |
| `image_input` | Loaded via PIL, sent as inline content |
| `api_parameters.aspect_ratio` | `ImageConfig(aspect_ratio=...)` |
| `api_parameters.resolution` | `ImageConfig(image_size=...)` |
| `settings` | Ignored (tracking metadata only) |

## Script: `scripts/generate_gemini.py`

- CLI: `python scripts/generate_gemini.py <prompt.json> <output.jpg>`
- Uses `google-genai` SDK (synchronous, no polling)
- Reads `GEMINI_API_KEY` from `.env`
- Supports both text-only and reference image prompts
- Follows same CLI pattern as other scripts

## Flow

1. Load JSON prompt
2. Build content list (text + optional PIL images)
3. Call `client.models.generate_content()` with `ImageConfig`
4. Extract image from response parts
5. Save to output path

## Changes

- New: `scripts/generate_gemini.py`
- Update: `.env` (add `GEMINI_API_KEY`)
- Update: `CLAUDE.md` (document new script)

## Approach

Google GenAI SDK (Approach A) — chosen for simplicity, native image handling, no polling needed.
