#!/usr/bin/env bash
# sync_to_repo.sh — WSL working copy -> REPO (Windows, git), so you can COMMIT what you wrote.
#
# Copies setup/, my_robot/ and every phase's codes/ folder from $ROBOTICS_HOME back into
# $ROBOTICS_REPO, same relative paths. Build output, caches, firmware builds, bags, datasets,
# model weights and videos are excluded: they do not belong in git, and OneDrive would try to
# upload gigabytes of them.
#
# Safe by design:
#   - it ADDS and UPDATES, it never deletes. Remove files from the repo yourself (git rm).
#   - newer file wins (rsync --update): a file you edited on Windows is never overwritten by
#     an older copy from WSL.
#   - files over 20 MB are skipped and listed, so a stray bag or checkpoint cannot sneak in.
#   - symlinks are skipped (rsync prints "skipping non-regular file"); commit real files only.
#
# Usage:  bash ~/Robotics/setup/sync_to_repo.sh          (alias from SETUP.md: rpush)
set -euo pipefail

: "${ROBOTICS_REPO:?Set ROBOTICS_REPO to your Robotics folder on Windows. See sync_from_repo.sh.}"
ROBOTICS_HOME="${ROBOTICS_HOME:-$HOME/Robotics}"
MAX_SIZE=20m

[ -d "$ROBOTICS_HOME" ] || { echo "No working copy at $ROBOTICS_HOME. Run sync_from_repo.sh first." >&2; exit 1; }
[ -d "$ROBOTICS_REPO" ] || { echo "Repo not found: $ROBOTICS_REPO" >&2; exit 1; }
command -v rsync > /dev/null 2>&1 || { echo "rsync is required: sudo apt install rsync" >&2; exit 1; }

shopt -s nullglob
TREES=(setup my_robot)
for d in "$ROBOTICS_HOME"/[0-9][0-9]_*/codes; do
  TREES+=("${d#"$ROBOTICS_HOME"/}")
done
shopt -u nullglob

EXCLUDES=(
  # build output and caches
  --exclude '.git' --exclude 'build/' --exclude 'install/' --exclude 'log/'
  --exclude '__pycache__/' --exclude '*.pyc' --exclude '.venv/' --exclude 'node_modules/'
  --exclude 'dist/' --exclude '.pio/' --exclude 'target/' --exclude '.cache/'
  --exclude '*.o' --exclude '*.so' --exclude '*.a' --exclude '*.elf' --exclude '*.hex'
  --exclude '*.uf2' --exclude '*.bin' --exclude '*.gcode' --exclude '*.bgcode'
  # recordings
  --exclude 'rosbag2_*/' --exclude '*.mcap' --exclude '*.db3' --exclude '*.db3-*' --exclude '*.bag'
  # machine learning
  --exclude '*.pt' --exclude '*.pth' --exclude '*.ckpt' --exclude '*.safetensors'
  --exclude '*.onnx' --exclude '*.engine' --exclude '*.plan' --exclude '*.trt'
  --exclude 'wandb/' --exclude 'runs/' --exclude 'outputs/' --exclude 'checkpoints/' --exclude 'datasets/'
  # video
  --exclude '*.mp4' --exclude '*.mov' --exclude '*.mkv' --exclude '*.webm' --exclude '*.avi'
)

echo "WSL -> REPO   ($ROBOTICS_HOME  ->  $ROBOTICS_REPO)"
for rel in "${TREES[@]}"; do
  src="$ROBOTICS_HOME/$rel"
  dst="$ROBOTICS_REPO/$rel"
  [ -d "$src" ] || continue
  mkdir -p "$dst"
  echo "  $rel/"
  rsync -rt --update --max-size="$MAX_SIZE" "${EXCLUDES[@]}" "$src"/ "$dst"/
done

big=""
for rel in "${TREES[@]}"; do
  [ -d "$ROBOTICS_HOME/$rel" ] || continue
  found=$(find "$ROBOTICS_HOME/$rel" \
            \( -name build -o -name install -o -name log -o -name .pio -o -name node_modules \) -prune -o \
            -type f -size +20M -print 2>/dev/null || true)
  if [ -n "$found" ]; then
    big+="$found"$'\n'
  fi
done
if [ -n "$big" ]; then
  echo
  echo "Skipped (over $MAX_SIZE). Keep these out of git, or add them to Git LFS deliberately:"
  printf '%s' "$big" | sed '/^$/d; s/^/    /'
fi

echo
echo "Done. Review before committing; .gitignore catches strays, but look anyway:"
echo "  cd \"$ROBOTICS_REPO\" && git status --short"
