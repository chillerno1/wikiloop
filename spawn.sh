#!/usr/bin/env bash
# spawn.sh — create a new operational knowledge base from this skeleton.
#
# Usage:
#   ./spawn.sh <target-path> "<topic>" "<focus-area-1>" ["<focus-area-2>" ...]
#
# The spawner copies prompts into the vault rather than symlinking, so each
# vault is fully self-contained and portable.

set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "usage: $0 <target-path> \"<topic>\" \"<focus-area-1>\" [\"<focus-area-2>\" ...]" >&2
  exit 1
fi

SKELETON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1/#\~/$HOME}"
TOPIC="$2"
shift 2

FOCUS_AREAS=""
for area in "$@"; do
  FOCUS_AREAS+="- ${area}"$'\n'
done

if [[ -e "$TARGET" ]]; then
  echo "error: $TARGET already exists" >&2
  exit 1
fi

echo "→ creating vault at $TARGET"
mkdir -p "$TARGET/raw/assets" "$TARGET/wiki" "$TARGET/outputs" "$TARGET/tasks"

echo "→ writing CLAUDE.md"
python3 -c "
import pathlib
tpl = pathlib.Path('$SKELETON_DIR/CLAUDE.md.template').read_text()
out = tpl.replace('{{TOPIC}}', '''$TOPIC''').replace('{{FOCUS_AREAS}}', '''${FOCUS_AREAS%$'\n'}''')
pathlib.Path('$TARGET/CLAUDE.md').write_text(out)
"

echo "→ copying prompts/"
cp -R "$SKELETON_DIR/prompts" "$TARGET/prompts"

echo "→ copying tasks/_template"
cp -R "$SKELETON_DIR/tasks/_template" "$TARGET/tasks/_template"

TODAY="$(date +%Y-%m-%d)"

echo "→ writing wiki/log.md"
cat > "$TARGET/wiki/log.md" <<EOF
# Log

## [$TODAY] update | Operational knowledge base created from operational-kb-skeleton. Topic: $TOPIC.
EOF

echo "→ writing wiki/index.md"
cat > "$TARGET/wiki/index.md" <<'EOF'
# Index

_No pages yet. Ingest your first source in `raw/` or run your first task in `tasks/` to begin._
EOF

echo "→ git init"
(cd "$TARGET" && git init -q && git add -A && git -c commit.gpgsign=false commit -q -m "Initial vault from operational-kb-skeleton")

echo
echo "✓ vault ready at $TARGET"
echo "  next:"
echo "    1. drop sources into $TARGET/raw/ and use prompts/ingest.md"
echo "    2. for task work, cp -R tasks/_template tasks/\$(date +%Y-%m-%d)-<slug>"
