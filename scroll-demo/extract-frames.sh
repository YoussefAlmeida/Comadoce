#!/usr/bin/env bash
# Transforma um vídeo em sequência de frames para o site.
# Uso:   ./extract-frames.sh <video> <cena> [fps]
# Ex.:   ./extract-frames.sh brigadeiro.mp4 cacau
#        ./extract-frames.sh bolo.mp4 calda 24
# Cenas: cacau | calda | ouro
# Gera frames/<cena>/ (desktop, 1920px) e frames/<cena>-mobile/ (900px), cada um com manifest.json.
set -euo pipefail
IN="${1:?informe o vídeo}"; NAME="${2:?informe a cena (cacau, calda, ouro)}"; FPS="${3:-30}"
ROOT="$(cd "$(dirname "$0")" && pwd)/frames"

make_set () { # pasta largura qualidade
  local DIR="$ROOT/$1"; rm -rf "$DIR"; mkdir -p "$DIR"
  ffmpeg -loglevel error -i "$IN" -an \
    -vf "fps=$FPS,scale='min($2,iw)':-2:flags=lanczos" \
    -c:v libwebp -quality "$3" -compression_level 6 "$DIR/%04d.webp"
  local COUNT; COUNT=$(find "$DIR" -name '*.webp' | wc -l | tr -d ' ')
  printf '{"count": %s, "ext": "webp"}\n' "$COUNT" > "$DIR/manifest.json"
  echo "  $1: $COUNT frames, $(du -sh "$DIR" | cut -f1)"
}

echo "Extraindo $IN -> $NAME ($FPS fps)"
make_set "$NAME" 1920 78
make_set "$NAME-mobile" 900 70
echo "Pronto. Recarregue o site: a cena '$NAME' passa a usar o vídeo."
