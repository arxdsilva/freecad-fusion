#!/usr/bin/env bash
# Install freecad-fusion for FreeCAD on macOS or Linux.
#
#   curl -fsSL https://raw.githubusercontent.com/arxdsilva/freecad-fusion/main/install.sh | bash
#   ./install.sh              # from a clone: links this checkout into FreeCAD
#   ./install.sh --uninstall  # removes the link(s)
#
# The add-on is linked into every FreeCAD user Mod folder found (FreeCAD 1.x
# keeps one per version, e.g. .../FreeCAD/v1-1/Mod). Restart FreeCAD afterwards.
set -euo pipefail

REPO_URL="https://github.com/arxdsilva/freecad-fusion.git"
NAME="freecad-fusion"

case "$(uname -s)" in
  Darwin) BASE="$HOME/Library/Application Support/FreeCAD" ;;
  *)      BASE="${XDG_DATA_HOME:-$HOME/.local/share}/FreeCAD" ;;
esac

mod_dirs() {
  local found=0
  if [ -d "$BASE" ]; then
    for d in "$BASE"/v*/; do
      [ -d "$d" ] || continue
      echo "${d%/}/Mod"; found=1
    done
  fi
  # FreeCAD < 1.0 (or no versioned folder yet): plain Mod folder.
  if [ "$found" = 0 ]; then echo "$BASE/Mod"; fi
}

if [ "${1:-}" = "--uninstall" ]; then
  while IFS= read -r m; do
    if [ -L "$m/$NAME" ] || [ -d "$m/$NAME" ]; then
      rm -rf "$m/$NAME" && echo "removed $m/$NAME"
    fi
  done < <(mod_dirs)
  echo "Uninstalled. Tip: run Tools > 'Restore my previous FreeCAD settings' first if you want your old shortcuts back."
  exit 0
fi

# Source: this checkout if run from one, otherwise clone/update a copy.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/InitGui.py" ] && [ -d "$SCRIPT_DIR/freecad_fusion" ]; then
  SRC="$SCRIPT_DIR"
else
  SRC="${FREECAD_FUSION_HOME:-$HOME/.local/share/$NAME}"
  if [ -d "$SRC/.git" ]; then
    git -C "$SRC" pull --ff-only
  else
    mkdir -p "$(dirname "$SRC")"
    git clone --depth 1 "$REPO_URL" "$SRC"
  fi
fi

while IFS= read -r m; do
  mkdir -p "$m"
  rm -rf "$m/$NAME"
  ln -s "$SRC" "$m/$NAME"
  echo "linked $m/$NAME -> $SRC"
done < <(mod_dirs)

echo "Done. Restart FreeCAD: Fusion navigation and shortcuts are applied on first start."
