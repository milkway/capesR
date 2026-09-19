#!/bin/bash
# Runs the whole data refresh on a server, independent of the local session:
#   1. downloads the CAPES CSVs listed below (sequential, resumable),
#   2. converts them with data-raw/build_parquet.R,
#   3. writes dados_parquet/checksums.csv (year, bytes, md5),
#   4. optionally uploads the parquets to Hugging Face (only if HF_TOKEN is set;
#      otherwise rsync dados_parquet/ back and run data-raw/upload_data.sh locally).
# Usage on the server:  nohup ./etl_remote.sh > logs/etl.log 2>&1 &
# Progress markers: "STEP ...", "ok <file>", "FAIL <file>", "ETL_DONE" / "ETL_FAILED".
set -u
cd "$(dirname "$0")"
export R_LIBS_USER="$HOME/R/x86_64-pc-linux-gnu-library/4.5"
B=https://dadosabertos.capes.gov.br/dataset
declare -A CSV=(
  [2019]="$B/36d1c92c-f9e0-4da1-a4f0-633e6ebefe03/resource/8f4f2bce-2744-460a-8f14-f1648c7a16df/download/br-capes-btd-2019-2025-04-29.csv"
  [2021]="$B/dbb9b83e-7779-4b99-89d2-1ff8099f36f6/resource/068003e4-196c-41f4-8c35-1f7c94b4e55c/download/br-capes-btd-2021-2025-03-31.csv"
  [2022]="$B/dbb9b83e-7779-4b99-89d2-1ff8099f36f6/resource/78f73608-6f5e-463c-ba79-0bff4f8a578d/download/br-capes-btd-2022-2025-03-31.csv"
  [2023]="$B/dbb9b83e-7779-4b99-89d2-1ff8099f36f6/resource/b69baf26-8d02-4c10-ba39-7e9ab799e6ed/download/br-capes-btd-2023-2025-03-31.csv"
  [2024]="$B/dbb9b83e-7779-4b99-89d2-1ff8099f36f6/resource/87133ba7-ac99-4d87-966e-8f580bc96231/download/br-capes-btd-2024-2025-12-01.csv"
)
YEARS="${YEARS:-2023 2024 2021 2019 2022}"

echo "STEP download $(date -u +%FT%TZ)"
for y in $YEARS; do
  f="dados_raw/capes_$y.csv"
  [ -s "$f" ] && { echo "skip $f"; continue; }
  # the CAPES server does not support byte ranges, so every attempt restarts from zero
  for try in 1 2 3 4 5 6; do
    rm -f "$f.part"
    curl -sSL --retry 3 --max-time 7200 "${CSV[$y]}" -o "$f.part" && [ -s "$f.part" ] && { mv "$f.part" "$f"; echo "ok $f $(stat -c %s "$f")"; break; }
    echo "retry $try $f"; sleep 60
  done
  [ -s "$f" ] || { echo "FAIL $f"; echo ETL_FAILED; exit 1; }
done

echo "STEP parquet $(date -u +%FT%TZ)"
Rscript build_parquet.R $YEARS || { echo ETL_FAILED; exit 1; }
for y in $YEARS; do echo "ok dados_parquet/capes_$y.parquet $(stat -c %s dados_parquet/capes_$y.parquet)"; done

echo "STEP checksums $(date -u +%FT%TZ)"
( echo "year,bytes,md5"; for y in $YEARS; do p="dados_parquet/capes_$y.parquet"; echo "$y,$(stat -c %s "$p"),$(md5sum "$p" | cut -d' ' -f1)"; done ) > dados_parquet/checksums.csv
cat dados_parquet/checksums.csv

if [ -z "${HF_TOKEN:-}" ]; then echo "skip upload (no HF_TOKEN)"; echo ETL_DONE; exit 0; fi
echo "STEP upload $(date -u +%FT%TZ)"
HF=${HF:-$HOME/capesR-etl/venv/bin/hf}
files=(); for y in $YEARS; do files+=("dados_parquet/capes_$y.parquet"); done
for try in 1 2 3; do
  "$HF" upload mlkwy/capesR dados_parquet . --repo-type dataset --include "*.parquet" \
     --commit-message "Refresh $(echo $YEARS | tr ' ' ',') from CAPES portal ($(date -u +%F))" && { echo "ok upload"; echo ETL_DONE; exit 0; }
  echo "retry $try upload"; sleep 60
done
echo "FAIL upload"; echo ETL_FAILED; exit 1
