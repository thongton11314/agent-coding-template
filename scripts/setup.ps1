# ──────────────────────────────────────────────────────────────
# AI Development Framework — Setup Script (Windows PowerShell)
#
# Pulls the framework into an existing project.
#
# Usage:
#   irm https://raw.githubusercontent.com/thongton11314/agent-coding-template/main/scripts/setup.ps1 | iex
#   — or —
#   git clone https://github.com/thongton11314/agent-coding-template.git $env:TEMP\adf; & $env:TEMP\adf\scripts\setup.ps1
#
# Optional parameters:
#   -RepoUrl  Override the template repository URL (useful for forks)
#   -Force    Overwrite files that already exist
# ──────────────────────────────────────────────────────────────
param(
    [string]$RepoUrl = "https://github.com/thongton11314/agent-coding-template.git",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$Repo = $RepoUrl
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
    "src"
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
    ".github\agents"
    ".github\workflows"
    ".claude"
    ".claude\agents"
)

# Files to install
$Files = @(
    "AGENTS.md"
    "CLAUDE.md"
    "SECURITY.md"
    ".github\copilot-instructions.md"
    ".github\agents\agent-developer.md"
    ".github\agents\explore.md"
    ".github\workflows\ci.yml"
    ".claude\agents\agent-developer.md"
    ".claude\agents\explore.md"
    "wiki\index.md"
    "wiki\log.md"
    "wiki\overview.md"
    "wiki\deviations.md"
    "wiki\conventions\coding-conventions.md"
    "wiki\conventions\testing-conventions.md"
    "wiki\decisions\registry.md"
    "raw\README.md"
    "scripts\validate-wiki.ps1"
    "scripts\validate-wiki.sh"
    "scripts\setup-hooks.ps1"
)

# Create directories
Write-Host "[2/4] Creating directories..."
foreach ($dir in $Dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

# Copy files (skip if already exists, or overwrite if -Force)
Write-Host "[3/4] Installing files..."
$Skipped = 0
$Installed = 0
foreach ($file in $Files) {
    $src = Join-Path $TmpDir $file
    if ((Test-Path $file) -and -not $Force) {
        Write-Host "  SKIP  $file (already exists — use -Force to overwrite)" -ForegroundColor Yellow
        $Skipped++
    }
    elseif (Test-Path $src) {
        # Ensure parent directory exists
        $parent = Split-Path $file -Parent
        if ($parent -and -not (Test-Path $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
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
Write-Host "  1. Open the project in your AI tool — it will pick up the framework automatically"
Write-Host "  2. Run 'pwsh scripts/setup-hooks.ps1' to install the pre-commit wiki-check hook"
Write-Host "  3. Try: 'Ingest raw/rest-api-design-best-practices.md' to see the wiki in action"
Write-Host "  4. For existing codebases: ask the AI to run Workflow 11 (Brownfield Onboarding)"
Write-Host ""
