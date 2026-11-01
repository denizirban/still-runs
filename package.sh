#!/bin/sh
set -eu
cd "$(dirname "$0")"
test -s index.html || { echo "Missing index.html"; exit 1; }
mkdir -p dist
rm -f dist/still-runs-crazygames.zip
python3 - <<'PY'
from zipfile import ZipFile, ZIP_DEFLATED
from pathlib import Path
html=Path("index.html").read_bytes()
assert html.startswith(b"<!doctype html>"),"Invalid entrypoint"
assert b"aynen.fun" not in html and b"fonts.googleapis.com" not in html, "External dependency"
with ZipFile("dist/still-runs-crazygames.zip","w",compression=ZIP_DEFLATED,compresslevel=9) as z:
    z.writestr("index.html",html)
print("Ready: dist/still-runs-crazygames.zip")
PY
