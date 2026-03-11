#!/usr/bin/env bash
# Demo: API path — user prompt → structured JSON → API generation
# Simulates the full workflow for terminal recording

PS1="$ "
clear

_type() {
  echo -n "$ "
  local text="$1"
  for ((i=0; i<${#text}; i++)); do
    echo -n "${text:$i:1}"
    sleep 0.04
  done
  echo
}

_print_slow() {
  local text="$1"
  local delay="${2:-0.01}"
  for ((i=0; i<${#text}; i++)); do
    echo -n "${text:$i:1}"
    sleep "$delay"
  done
  echo
}

sleep 0.5

# Step 1: User enters natural language prompt
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║  nano-banana-images — API Path Demo                            ║"
echo "║  User prompt → Structured JSON → API call → Generated image    ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""
sleep 1.5

echo "━━━ Step 1: User describes what they want ━━━"
echo ""
sleep 0.5
echo -n "User: "
_print_slow "Create a candid photo of a woman jumping with joy in a park" 0.03
echo ""
sleep 1.2

# Step 2: Tool asks which path
echo "━━━ Step 2: Choose output path ━━━"
echo ""
sleep 0.5
echo "  Which generation method do you want?"
echo ""
echo "  1. Kie.ai API        (highest quality, requires KIE_API_KEY)"
echo "  2. Google Gemini API  (requires GEMINI_API_KEY)"
echo "  3. Free cloud SDXL    (no API key, Puter.ai)"
echo "  4. Local SDXL         (no API key, slow)"
echo "  5. Gemini web UI      (free, manual copy/paste)"
echo ""
sleep 1.5
echo -n "User: "
_print_slow "1" 0.03
echo ""
sleep 1.0

# Step 3: Tool constructs structured JSON
echo "━━━ Step 3: Constructing structured JSON prompt ━━━"
echo ""
sleep 0.5
_print_slow "Saving to prompts/woman_jumping_joy.json..." 0.02
echo ""
sleep 0.3

cat << 'EOF'
{
  "prompt": "Candid documentary-style photograph of a woman in her
    late 20s mid-jump in the air, captured at peak height with both
    feet off the ground, arms flung wide open, mouth open in a wide
    genuine laugh. Shot with a 35mm lens at f/2.8, ISO 400, 1/1000s
    shutter speed to freeze motion. Natural afternoon daylight from
    camera-left creates warm directional light. She wears a light
    floral sundress that billows mid-jump, hair flying upward. Skin
    shows natural texture — visible pores, faint freckle near left
    eye, no makeup. Blurred sunlit urban park background with bokeh.
    Do not beautify or smooth skin. No AI beauty filters.",
  "negative_prompt": "plastic skin, skin smoothing, airbrushed
    texture, beauty filter, studio lighting, CGI, 3D render,
    anatomy normalization, HDR glow, watermark",
  "image_input": [],
  "api_parameters": {
    "resolution": "2K",
    "output_format": "jpg",
    "aspect_ratio": "4:5"
  },
  "settings": {
    "resolution": "2K",
    "style": "documentary realism, candid photography",
    "lighting": "natural afternoon daylight, warm directional",
    "camera_angle": "slightly below eye level",
    "depth_of_field": "shallow, subject sharp, background bokeh",
    "quality": "high detail, unretouched, authentic motion"
  }
}
EOF

echo ""
sleep 1.5

# Step 4: Run the generation script
echo "━━━ Step 4: Running API generation ━━━"
echo ""
sleep 0.5
_type "python scripts/generate_kie.py prompts/woman_jumping_joy.json images/output.jpg"
sleep 0.4

echo "[INFO] Loading prompt from prompts/woman_jumping_joy.json"
sleep 0.5
echo "[INFO] Submitting generation task to nano-banana-2..."
sleep 0.8
echo "[INFO] Task created → ID: task_a4c82f1b"
sleep 0.5
echo "[INFO] Polling for completion..."
sleep 1.5
echo "[INFO] Status: processing..."
sleep 2.0
echo "[INFO] Status: processing..."
sleep 2.0
echo "[INFO] Status: success"
sleep 0.4
echo "[INFO] Downloading result..."
sleep 0.8
echo ""
echo "✓ Image saved to images/output.jpg  (1600 x 2000, 2K)"
echo ""
sleep 3
