#!/usr/bin/env bash
# sync_from_repo.sh — REPO (Windows, git) -> WSL working copy, so you can BUILD and RUN.
#
# Copies setup/, my_robot/ and every phase's codes/ folder from $ROBOTICS_REPO into
# $ROBOTICS_HOME (default ~/Robotics), keeping the same relative paths:
#
#   $ROBOTICS_REPO/02_ROS2_Core/codes/Week_1/Day_3/  ->  ~/Robotics/02_ROS2_Core/codes/Week_1/Day_3/
#
# Theory, journal and READMEs stay on Windows: you read them in Cursor, nothing builds them.
#
# It also strips Windows CRLF line endings and restores the executable bit, because NTFS keeps
# neither. CRLF is not cosmetic here: a Python node whose shebang ends in \r dies with
# "/usr/bin/env: 'python3\r': No such file or directory", and bash scripts fail the same way.
#
# Newer file wins (rsync --update): a file you edited in WSL is never overwritten by an older
# copy from the repo. If you edited the same file on both sides, the more recent edit wins.
#
# One-time setup, in ~/.bashrc (never committed; the OneDrive path has spaces, keep the quotes):
#   export ROBOTICS_REPO="/mnt/c/Users/<you>/<path-to>/SKILL/Robotics"
#
# Usage:  bash ~/Robotics/setup/sync_from_repo.sh        (alias from SETUP.md: rpull)
set -euo pipefail

: "${ROBOTICS_REPO:?Set ROBOTICS_REPO to your Robotics folder on Windows. See the header of this script.}"
ROBOTICS_HOME="${ROBOTICS_HOME:-$HOME/Robotics}"

case "$ROBOTICS_HOME" in
  /mnt/*)
    echo "ROBOTICS_HOME must be on WSL's own filesystem, not the Windows drive: $ROBOTICS_HOME" >&2
    exit 1
    ;;
esac
[ -d "$ROBOTICS_REPO" ] || { echo "Repo not found: $ROBOTICS_REPO" >&2; exit 1; }

# Every runnable tree in the repo, as paths relative to its root.
shopt -s nullglob
TREES=(setup my_robot)
for d in "$ROBOTICS_REPO"/[0-9][0-9]_*/codes; do
  TREES+=("${d#"$ROBOTICS_REPO"/}")
done
shopt -u nullglob

EXCLUDES=(
  --exclude '.git' --exclude 'build/' --exclude 'install/' --exclude 'log/'
  --exclude '__pycache__/' --exclude '.pio/' --exclude 'node_modules/'
  --exclude '.venv/' --exclude 'target/'
)

# Strip CRLF only from files that actually contain it; `sed -i` on every file would rewrite
# them all, bump their timestamps, and make the next sync_to_repo.sh copy everything back.
normalize_line_endings() {
  find "$1" \( -name build -o -name install -o -name log -o -name .pio -o -name node_modules \) -prune -o \
    -type f \( -name '*.sh' -o -name '*.bash' -o -name '*.py' -o -name '*.c' -o -name '*.cc' \
      -o -name '*.cpp' -o -name '*.cxx' -o -name '*.h' -o -name '*.hh' -o -name '*.hpp' \
      -o -name '*.ino' -o -name 'CMakeLists.txt' -o -name '*.cmake' -o -name '*.xml' \
      -o -name '*.launch' -o -name '*.urdf' -o -name '*.xacro' -o -name '*.srdf' -o -name '*.sdf' \
      -o -name '*.world' -o -name '*.yaml' -o -name '*.yml' -o -name '*.toml' -o -name '*.cfg' \
      -o -name '*.ini' -o -name '*.repos' -o -name '*.msg' -o -name '*.srv' -o -name '*.action' \
      -o -name 'Dockerfile' -o -name '*.dockerfile' -o -name 'Makefile' \
      -o -name '*.js' -o -name '*.ts' -o -name '*.html' -o -name '*.css' \) -print0 \
    | xargs -0 -r grep -lZ $'\r' 2>/dev/null \
    | xargs -0 -r sed -i 's/\r$//' || true
}

# Shell scripts, and Python files that start with a shebang, are meant to be executed.
restore_exec_bits() {
  find "$1" \( -name build -o -name install -o -name log \) -prune -o \
    -type f -name '*.sh' -exec chmod +x {} +
  while IFS= read -r -d '' f; do
    if [ "$(head -c 2 "$f")" = '#!' ]; then
      chmod +x "$f"
    fi
  done < <(find "$1" \( -name build -o -name install -o -name log \) -prune -o \
             -type f -name '*.py' -print0)
}

if ! command -v rsync > /dev/null 2>&1; then
  echo "WARNING: rsync not found (sudo apt install rsync). Falling back to cp, which cannot" >&2
  echo "         protect newer WSL edits from being overwritten." >&2
fi

echo "REPO -> WSL   ($ROBOTICS_REPO  ->  $ROBOTICS_HOME)"
for rel in "${TREES[@]}"; do
  src="$ROBOTICS_REPO/$rel"
  dst="$ROBOTICS_HOME/$rel"
  [ -d "$src" ] || continue
  mkdir -p "$dst"
  echo "  $rel/"
  if command -v rsync > /dev/null 2>&1; then
    # -p with --chmod normalises the 0777 permissions that files on /mnt/c report.
    rsync -rltp --update --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r "${EXCLUDES[@]}" "$src"/ "$dst"/
  else
    cp -r "$src"/. "$dst"/
  fi
  normalize_line_endings "$dst"
  restore_exec_bits "$dst"
done

echo
echo "Done. Runnable trees now in WSL:"
for rel in "${TREES[@]}"; do
  if [ -d "$ROBOTICS_HOME/$rel" ]; then
    count=$(find "$ROBOTICS_HOME/$rel" \( -name build -o -name install -o -name log \) -prune -o -type f -print | wc -l)
    echo "  $rel/  ($count files)"
  fi
done
echo
echo "Build one day's packages with:  rb <path under ~/Robotics>   (helper from SETUP.md Step 6)"
