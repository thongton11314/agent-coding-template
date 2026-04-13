#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# AI Development Framework — Setup Script (Linux / macOS)
#
# Pulls the framework into an existing project.
#
# Usage:
#   curl -sL https://raw.githubusercontent.com/YOUR_USERNAME/agent-coding-template/main/scripts/setup.sh | bash
#   — or —
#   git clone https://github.com/YOUR_USERNAME/agent-coding-template.git /tmp/adf && bash /tmp/adf/scripts/setup.sh
# ──────────────────────────────────────────────────────────────
set -euo pipefail

REPO="https://github.com/YOUR_USERNAME/agent-coding-template.git"
BRANCH="main"
TMPDIR=$(mktemp -d)

echo "==> AI Development Framework — Setup"
echo ""

# Clone to temp
echo "[1/4] Fetching framework..."
git clone --depth 1 --branch "$BRANCH" "$REPO" "$TMPDIR" 2>/dev/null

# Files and directories to install
DIRS=(
    "raw/assets"
    "wiki/sources"
    "wiki/entities"
    "wiki/concepts"
    "wiki/analyses"
    "wiki/architecture"
    "wiki/decisions"
    "wiki/conventions"
    "wiki/modules"
    "scripts"
    ".github"
)

FILES=(
    "AGENTS.md"
    "CLAUDE.md"
    ".cursorrules"
    ".windsurfrules"
    ".clinerules"
    ".github/copilot-instructions.md"
    "wiki/index.md"
    "wiki/log.md"
    "wiki/overview.md"
    "raw/README.md"
    "scripts/validate-wiki.ps1"
)

# Create directories
echo "[2/4] Creating directories..."
for dir in "${DIRS[@]}"; do
    mkdir -p "$dir"
done

# Copy files (skip if already exists)
echo "[3/4] Installing files..."
SKIPPED=0
INSTALLED=0
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  SKIP  $file (already exists)"
        SKIPPED=$((SKIPPED + 1))
    elif [ -f "$TMPDIR/$file" ]; then
        cp "$TMPDIR/$file" "$file"
        echo "  ADD   $file"
        INSTALLED=$((INSTALLED + 1))
    fi
done

# Cleanup
rm -rf "$TMPDIR"

echo "[4/4] Done."
echo ""
echo "  Installed: $INSTALLED files"
echo "  Skipped:   $SKIPPED files (already existed)"
echo ""
echo "Next steps:"
echo "  1. Replace YOUR_USERNAME in setup scripts with your GitHub username"
echo "  2. Open the project in your AI tool — it will pick up the framework automatically"
echo "  3. Try: \"Ingest raw/rest-api-design-best-practices.md\" to see it in action"
echo ""
