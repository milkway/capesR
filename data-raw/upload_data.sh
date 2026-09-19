#!/bin/zsh
# Uploads dados_parquet/*.parquet to the data host used by capesR.
# Pick ONE of the sections below; afterwards run data-raw/capes_years.R.
set -euo pipefail
cd "$(dirname "$0")/.."
ls dados_parquet/capes_*.parquet | wc -l | grep -q '^ *36$' || { echo "expected 36 files in dados_parquet/"; exit 1; }

### Option A — Hugging Face Datasets (recommended) --------------------------
# One-time: pip install -U huggingface_hub  (or: brew install huggingface-cli)
#           hf auth login
REPO="mlkwy/capesR"
hf repo create "$REPO" --repo-type dataset --exist-ok
hf upload "$REPO" dados_parquet . --repo-type dataset --include "*.parquet" \
  --commit-message "CAPES catalog 1987-2024 (parquet)"
hf upload "$REPO" data-raw/README_dataset.md README.md --repo-type dataset
# Files are then served at:
#   https://huggingface.co/datasets/$REPO/resolve/main/capes_1987.parquet

### Option B — GitHub Release on mlkwy/capesR ------------------------------
# TAG="data-v1"
# gh release create "$TAG" --repo mlkwy/capesR --title "CAPES data $TAG" \
#   --notes "Yearly parquet files of the CAPES catalog (1987-2024)." dados_parquet/capes_*.parquet
# base_url would be: https://github.com/mlkwy/capesR/releases/download/$TAG
