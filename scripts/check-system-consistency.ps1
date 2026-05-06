# ──────────────────────────────────────────────────────────────
# System Consistency Check — verifies cross-file parity that
# wiki validation alone can't catch. Run after validate-wiki.ps1.
#
# What it checks:
#   1. Agent file pair byte-identity (.github/agents/* ≡ .claude/agents/*)
#   2. Routing path-list parity in AGENTS.md / CLAUDE.md / .github/copilot-instructions.md
#   3. Routing trigger-list count parity in the same three entry-point files
#   4. Every directory named in the routing path list appears in AGENTS.md Directory Structure
#   5. Skill-row count parity between AGENTS.md and README "Developer Agent Skills" tables
#
# Why: prior consistency audits found these classes of drift after the fact.
# This script catches them at commit / CI time so they never ship.
#
# Usage:
#   pwsh scripts/check-system-consistency.ps1
# ──────────────────────────────────────────────────────────────
$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

function Read-File {
    param([string]$Rel)
    $path = Join-Path $RepoRoot $Rel
    if (-not (Test-Path $path)) { throw "Required file missing: $Rel" }
    return Get-Content -LiteralPath $path -Raw -Encoding UTF8
}

$Issues = @()
$Checks = @()

function Add-Issue { param([string]$Msg) $script:Issues += "  $Msg" }
function Record-Check {
    param([string]$Name, [int]$Before)
    $after = $script:Issues.Count
    $script:Checks += [pscustomobject]@{ Name = $Name; Failed = ($after - $Before) }
}

# ── Check 1: Agent file pair byte-identity ─────────────────────
$before = $Issues.Count
$pairs = @(
    @('.github/agents/agent-developer.md', '.claude/agents/agent-developer.md'),
    @('.github/agents/agent-explorer.md',  '.claude/agents/agent-explorer.md')
)
foreach ($pair in $pairs) {
    $a = Join-Path $RepoRoot $pair[0]
    $b = Join-Path $RepoRoot $pair[1]
    if (-not (Test-Path $a)) { Add-Issue "MISSING: $($pair[0])"; continue }
    if (-not (Test-Path $b)) { Add-Issue "MISSING: $($pair[1])"; continue }
    $hashA = (Get-FileHash -LiteralPath $a -Algorithm SHA256).Hash
    $hashB = (Get-FileHash -LiteralPath $b -Algorithm SHA256).Hash
    if ($hashA -ne $hashB) {
        Add-Issue "PAIR MISMATCH: $($pair[0]) and $($pair[1]) must be byte-identical (per ADR-001)."
        Add-Issue "    $($pair[0])  $hashA"
        Add-Issue "    $($pair[1])  $hashB"
    }
}
Record-Check "Agent Pair Parity" $before

# ── Check 2: Routing path-list parity ──────────────────────────
# Extract `src/`, `tests/`, ... from each entry-point's routing rule.
$before = $Issues.Count
$entryPoints = @(
    'AGENTS.md',
    'CLAUDE.md',
    '.github/copilot-instructions.md'
)
$pathLists = @{}
foreach ($ep in $entryPoints) {
    $content = Read-File $ep
    if ($content -match 'changing any file in\s+(`[^`]+`(?:[,\s]+(?:or\s+)?`[^`]+`)+)') {
        $list = $Matches[1]
        $dirs = ([regex]'`([^`]+)`').Matches($list) | ForEach-Object { $_.Groups[1].Value }
        $pathLists[$ep] = ($dirs -join ',')
    } else {
        Add-Issue "ROUTING-PATH NOT FOUND in ${ep}: expected 'changing any file in `src/`, ...'"
    }
}
$uniqueLists = $pathLists.Values | Sort-Object -Unique
if ($uniqueLists.Count -gt 1) {
    Add-Issue "ROUTING-PATH MISMATCH across entry-point files:"
    foreach ($kv in $pathLists.GetEnumerator()) {
        Add-Issue "    $($kv.Key): $($kv.Value)"
    }
}
Record-Check "Routing Path-List Parity" $before

# ── Check 3: Trigger-list count parity ─────────────────────────
$before = $Issues.Count
$triggerCounts = @{}
foreach ($ep in $entryPoints) {
    $content = Read-File $ep
    # Find the "Triggers" block and count `- "...` lines until blank line / next heading.
    if ($content -match '(?ms)Triggers \(non-exhaustive\):\s*\r?\n((?:- ".+\r?\n)+)') {
        $block = $Matches[1]
        $count = ([regex]'(?m)^- "').Matches($block).Count
        $triggerCounts[$ep] = $count
    } else {
        Add-Issue "TRIGGERS BLOCK NOT FOUND in ${ep}"
    }
}
$uniqueCounts = $triggerCounts.Values | Sort-Object -Unique
if ($uniqueCounts.Count -gt 1) {
    Add-Issue "TRIGGER-COUNT MISMATCH across entry-point files:"
    foreach ($kv in $triggerCounts.GetEnumerator()) {
        Add-Issue "    $($kv.Key): $($kv.Value) triggers"
    }
}
Record-Check "Trigger-List Parity" $before

# ── Check 4: Directory Structure covers routing path list ──────
$before = $Issues.Count
if ($pathLists.ContainsKey('AGENTS.md')) {
    $agents = Read-File 'AGENTS.md'
    if ($agents -match '(?s)## Directory Structure\s*\r?\n+```(.+?)```') {
        $structureBlock = $Matches[1]
        $routingDirs = $pathLists['AGENTS.md'] -split ','
        foreach ($dir in $routingDirs) {
            $dir = $dir.Trim()
            # Look for the directory at line start (with optional indent for src/ subdirs)
            $pattern = "(?m)^\s*$([regex]::Escape($dir))(\s|$)"
            if ($structureBlock -notmatch $pattern) {
                Add-Issue "DIRECTORY '$dir' is named in routing rules but NOT in AGENTS.md Directory Structure block."
            }
        }
    } else {
        Add-Issue "DIRECTORY STRUCTURE BLOCK NOT FOUND in AGENTS.md (expected '## Directory Structure' followed by fenced block)."
    }
}
Record-Check "Directory Structure Coverage" $before

# ── Check 5: Skill-row count parity (AGENTS.md vs README) ──────
$before = $Issues.Count
function Count-SkillRows {
    param([string]$Content, [string]$HeadingMatch)
    if ($Content -match "(?ms)$HeadingMatch.*?(\r?\n\| Skill .+?)(\r?\n\r?\n|\r?\n##)") {
        $table = $Matches[1]
        # Count data rows: lines starting with "| **" (skill name in bold)
        return ([regex]'(?m)^\|\s*\*\*').Matches($table).Count
    }
    return -1
}
$agentsContent = Read-File 'AGENTS.md'
$readmeContent = Read-File 'README.md'
$agentsSkills = Count-SkillRows -Content $agentsContent -HeadingMatch '### Developer Agent\s'
$readmeSkills = Count-SkillRows -Content $readmeContent -HeadingMatch '### Developer Agent Skills\s'
if ($agentsSkills -lt 0) { Add-Issue "SKILL TABLE NOT FOUND under '### Developer Agent' in AGENTS.md" }
if ($readmeSkills -lt 0) { Add-Issue "SKILL TABLE NOT FOUND under '### Developer Agent Skills' in README.md" }
if ($agentsSkills -ge 0 -and $readmeSkills -ge 0 -and $agentsSkills -ne $readmeSkills) {
    Add-Issue "SKILL-COUNT MISMATCH: AGENTS.md has $agentsSkills skills, README.md has $readmeSkills."
}
Record-Check "Skill-Table Parity" $before

# ── Output ─────────────────────────────────────────────────────
Write-Host ""
foreach ($c in $Checks) {
    if ($c.Failed -eq 0) {
        Write-Host "[PASS] $($c.Name)" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] $($c.Name)" -ForegroundColor Red
    }
}
if ($Issues.Count -gt 0) {
    Write-Host ""
    foreach ($i in $Issues) { Write-Host $i -ForegroundColor Yellow }
}

Write-Host ""
Write-Host ('=' * 40)
if ($Issues.Count -eq 0) {
    Write-Host "All system consistency checks passed." -ForegroundColor Green
    exit 0
} else {
    Write-Host "$($Issues.Count) issue(s) found." -ForegroundColor Red
    exit 1
}
