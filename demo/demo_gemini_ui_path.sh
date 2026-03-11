#!/usr/bin/env bash
# Demo: Gemini web UI path — user prompt → structured plain text
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
echo "║  nano-banana-images — Gemini Web UI Path Demo                  ║"
echo "║  User prompt → Structured plain text → Paste into Gemini       ║"
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
_print_slow "5" 0.03
echo ""
sleep 1.0

# Step 3: Tool constructs structured plain text
echo "━━━ Step 3: Constructing structured plain-text prompt ━━━"
echo ""
sleep 0.5
_print_slow "Here is your structured prompt — copy and paste it into gemini.google.com:" 0.02
echo ""
sleep 0.5
echo "┌──────────────────────────────────────────────────────────────┐"

cat << 'EOF'
│ Candid documentary-style photograph of a woman in her late     │
│ 20s mid-jump in the air, captured at peak height with both     │
│ feet completely off the ground, arms flung wide open above     │
│ her head, mouth open in a wide genuine laugh, eyes crinkled    │
│ with real joy. Shot with a 35mm lens at f/2.8, ISO 400,       │
│ 1/1000s shutter speed to freeze motion. Natural afternoon      │
│ daylight from camera-left creates warm directional light       │
│ across her face, casting a soft shadow on her opposite cheek.  │
│ She wears a light floral sundress that billows and catches     │
│ air mid-jump, hair flying upward from the momentum. Slight     │
│ motion blur on the dress hem and hair tips shows real kinetic  │
│ energy. Skin shows natural texture — subtle pores on her       │
│ nose, a faint freckle near her left eye, no visible makeup     │
│ beyond natural skin tone. Background is a blurred sunlit       │
│ urban park with green trees and bokeh of distant people.       │
│ Photo captured slightly below eye level looking up. Authentic  │
│ human moment, unposed, raw energy. Do not beautify or smooth   │
│ skin. Do not add makeup. No AI beauty filters. No studio       │
│ lighting. No plastic look.                                     │
│                                                                │
│ Avoid the following: plastic skin, skin smoothing, airbrushed  │
│ texture, beauty filter, studio lighting, harsh artificial      │
│ light, CGI, 3D render, anatomy normalization, over-saturated   │
│ colors, HDR glow, lens flare, stylized realism, editorial     │
│ fashion proportions, watermark, text overlay                   │
EOF

echo "└──────────────────────────────────────────────────────────────┘"
echo ""
sleep 1.5

echo "━━━ Next steps ━━━"
echo ""
echo "  1. Go to gemini.google.com"
echo "  2. Paste the prompt above into the chat"
echo "  3. Upload any reference images alongside it"
echo "  4. Download the generated image"
echo ""
sleep 4
