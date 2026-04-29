# ──────────────────────────────────────────────────────────────
# AI Development Framework — Pre-commit Hook Installer
#
# Installs a pre-commit hook that validates the wiki before every
# commit. Prevents commits that leave the wiki in a broken state.
#
# Usage:
#   pwsh scripts/setup-hooks.ps1
# ──────────────────────────────────────────────────────────────

$ErrorActionPreference = "Stop"

$GitDir = git rev-parse --git-dir 2>$null
if (-not $GitDir) {
    Write-Host "ERROR: Not inside a git repository." -ForegroundColor Red
    exit 1
}

$HooksDir = Join-Path $GitDir "hooks"
if (-not (Test-Path $HooksDir)) {
    New-Item -ItemType Directory -Path $HooksDir -Force | Out-Null
}

# ── pre-commit hook ──────────────────────────────────────────
$PreCommitPath = Join-Path $HooksDir "pre-commit"

$PreCommitContent = @'
#!/bin/sh
# AI Development Framework — pre-commit validation
#
# 1. Enforces commit author identity.
# 2. Runs validate-wiki.ps1 wiki validation.
# To bypass in an emergency: git commit --no-verify (use sparingly)

# ── Identity check ───────────────────────────────────────────
EXPECTED_NAME="thongton11314"
EXPECTED_EMAIL="thong11314@gmail.com"
ACTUAL_NAME=$(git config user.name)
ACTUAL_EMAIL=$(git config user.email)

if [ "$ACTUAL_NAME" != "$EXPECTED_NAME" ] || [ "$ACTUAL_EMAIL" != "$EXPECTED_EMAIL" ]; then
    echo "[identity-check] ERROR: Commit author not allowed."
    echo "  Expected: $EXPECTED_NAME <$EXPECTED_EMAIL>"
    echo "  Got:      $ACTUAL_NAME <$ACTUAL_EMAIL>"
    echo ""
    echo "  Fix with:"
    echo "    git config user.name \"$EXPECTED_NAME\""
    echo "    git config user.email \"$EXPECTED_EMAIL\""
    exit 1
fi

# ── Wiki validation ──────────────────────────────────────────
SCRIPT="scripts/validate-wiki.ps1"

if [ ! -f "$SCRIPT" ]; then
    echo "[wiki-check] $SCRIPT not found — skipping."
    exit 0
fi

if command -v pwsh >/dev/null 2>&1; then
    pwsh "$SCRIPT"
    STATUS=$?
elif command -v powershell >/dev/null 2>&1; then
    powershell -File "$SCRIPT"
    STATUS=$?
else
    echo "[wiki-check] PowerShell not found — skipping wiki validation."
    exit 0
fi

if [ $STATUS -ne 0 ]; then
    echo ""
    echo "[wiki-check] Wiki validation failed. Fix issues above before committing."
    echo "             To bypass (use sparingly): git commit --no-verify"
    exit 1
fi

exit 0
'@

Set-Content -Path $PreCommitPath -Value $PreCommitContent -Encoding UTF8 -NoNewline

# Make executable on Unix (ignored on Windows, but correct for cross-platform repos)
if ($IsLinux -or $IsMacOS) {
    chmod +x $PreCommitPath
}

Write-Host "[OK] pre-commit hook installed: $PreCommitPath" -ForegroundColor Green
Write-Host ""
Write-Host "The hook runs 'scripts/validate-wiki.ps1' before every commit."
Write-Host "To bypass in an emergency: git commit --no-verify"
Write-Host ""
