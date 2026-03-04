#!/usr/bin/env bash
# Simulates the nano-banana-images demo for terminal recording

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

sleep 0.5

_type "cat prompts/pilot_f15e.json"
sleep 0.3
cat << 'EOF'
{
  "prompt": "Documentary-style portrait of a bald man with dark beard in an F-15E
  cockpit. JHMCS helmet, olive drab flight suit. 85mm f/2.2, shallow depth of
  field, natural cockpit lighting. Photorealistic, unretouched.",
  "negative_prompt": "blurry, watermark, CGI, studio lighting, filters",
  "image_input": ["images/my_portrait.png"],
  "api_parameters": {
    "resolution": "2K",
    "output_format": "jpg",
    "aspect_ratio": "3:4"
  }
}
EOF

sleep 1.2

_type "python3 scripts/generate_kie.py prompts/pilot_f15e.json images/output.jpg"
sleep 0.4

echo "[INFO] Loading prompt from prompts/pilot_f15e.json"
sleep 0.5
echo "[INFO] Uploading reference image: images/my_portrait.png"
sleep 1.2
echo "[INFO] Reference image uploaded → https://cdn.kie.ai/files/abc123.jpg"
sleep 0.4
echo "[INFO] Submitting generation task to nano-banana-2..."
sleep 0.8
echo "[INFO] Task created → ID: task_7f3a9d2e"
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
echo "✓ Image saved to images/output.jpg  (1792 x 2400, 2K)"
sleep 3
