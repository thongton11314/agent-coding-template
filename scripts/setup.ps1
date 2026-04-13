# ──────────────────────────────────────────────────────────────
# AI Development Framework — Setup Script (Windows PowerShell)
#
# Pulls the framework into an existing project.
#
# Usage:
#   irm https://raw.githubusercontent.com/YOUR_USERNAME/agent-coding-template/main/scripts/setup.ps1 | iex
#   — or —
#   git clone https://github.com/YOUR_USERNAME/agent-coding-template.git $env:TEMP\adf; & $env:TEMP\adf\scripts\setup.ps1
# ──────────────────────────────────────────────────────────────

$ErrorActionPreference = "Stop"

$Repo = "https://github.com/YOUR_USERNAME/agent-coding-template.git"
$Branch = "main"
$TmpDir = Join-Path $env:TEMP "adf-setup-$(Get-Random)"

Write-Host "==> AI Development Framework — Setup" -ForegroundColor Cyan
Write-Host ""

# Clone to temp
Write-Host "[1/4] Fetching framework..."
git clone --depth 1 --branch $Branch $Repo $TmpDir 2>$null
if (-not $?) { throw "Failed to clone repository. Check the URL and try again." }

# Directories to create
$Dirs = @(
    "raw\assets"
    "wiki\sources"
    "wiki\entities"
    "wiki\concepts"
    "wiki\analyses"
    "wiki\architecture"
    "wiki\decisions"
    "wiki\conventions"
    "wiki\modules"
    "scripts"
    ".github"
)

# Files to install
$Files = @(
    "AGENTS.md"
    "CLAUDE.md"
    ".cursorrules"
    ".windsurfrules"
    ".clinerules"
    ".github\copilot-instructions.md"
    "wiki\index.md"
    "wiki\log.md"
    "wiki\overview.md"
    "raw\README.md"
    "scripts\validate-wiki.ps1"
)

# Create directories
Write-Host "[2/4] Creating directories..."
foreach ($dir in $Dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

# Copy files (skip if already exists)
Write-Host "[3/4] Installing files..."
$Skipped = 0
$Installed = 0
foreach ($file in $Files) {
    $src = Join-Path $TmpDir $file
    if (Test-Path $file) {
        Write-Host "  SKIP  $file (already exists)" -ForegroundColor Yellow
        $Skipped++
    }
    elseif (Test-Path $src) {
        Copy-Item $src -Destination $file -Force
        Write-Host "  ADD   $file" -ForegroundColor Green
        $Installed++
    }
}

# Cleanup
Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue

Write-Host "[4/4] Done." -ForegroundColor Cyan
Write-Host ""
Write-Host "  Installed: $Installed files"
Write-Host "  Skipped:   $Skipped files (already existed)"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Replace YOUR_USERNAME in setup scripts with your GitHub username"
Write-Host "  2. Open the project in your AI tool — it will pick up the framework automatically"
Write-Host "  3. Try: 'Ingest raw/rest-api-design-best-practices.md' to see it in action"
Write-Host ""
