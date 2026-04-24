# ──────────────────────────────────────────────────────────────
# Wiki Validation Script — checks wiki health and reports issues.
#
# Usage:
#   pwsh scripts/validate-wiki.ps1
#   .\scripts\validate-wiki.ps1
# ──────────────────────────────────────────────────────────────

$ErrorActionPreference = "Stop"

$WikiDir = Join-Path $PSScriptRoot ".." "wiki" | Resolve-Path -ErrorAction SilentlyContinue
if (-not $WikiDir -or -not (Test-Path $WikiDir)) {
    Write-Host "ERROR: wiki/ directory not found." -ForegroundColor Red
    exit 1
}

# --- Config ---
$RequiredFields = @("title", "type", "created", "updated", "tags", "status")
$ValidTypes = @("source", "entity", "concept", "analysis", "architecture", "decision", "convention", "module", "overview")
$ValidStatuses = @("active", "draft", "deprecated", "superseded", "spec", "verified")
$ExemptPages = @("index", "log", "overview")

# --- Helpers ---

function Get-WikiPages {
    $pages = @{}
    Get-ChildItem -Path $WikiDir -Filter "*.md" -Recurse | ForEach-Object {
        $pages[$_.BaseName] = $_
    }
    return $pages
}

function Parse-Frontmatter {
    param([System.IO.FileInfo]$File)
    $content = Get-Content $File.FullName -Raw -Encoding UTF8
    if ($content -match '(?s)^---\s*\r?\n(.*?)\r?\n---') {
        $yamlBlock = $Matches[1]
        $fm = @{}
        foreach ($line in ($yamlBlock -split '\r?\n')) {
            if ($line -match '^\s*(\w[\w\-]*)\s*:\s*(.*)$') {
                $key = $Matches[1].Trim()
                $value = $Matches[2].Trim()
                $fm[$key] = $value
            }
        }
        return @{ Frontmatter = $fm; Content = $content }
    }
    return @{ Frontmatter = $null; Content = $content }
}

function Get-Wikilinks {
    param([string]$Text)
    $links = [System.Collections.Generic.HashSet[string]]::new()
    $regex = [regex]'\[\[([^\]]+)\]\]'
    $regex.Matches($Text) | ForEach-Object { [void]$links.Add($_.Groups[1].Value) }
    return $links
}

function Get-RelativePath {
    param([System.IO.FileInfo]$File)
    $File.FullName.Substring($WikiDir.Path.Length + 1).Replace('\', '/')
}

# --- Checks ---

function Check-Frontmatter {
    param($Pages)
    $issues = @()
    foreach ($entry in $Pages.GetEnumerator()) {
        $parsed = Parse-Frontmatter $entry.Value
        $rel = Get-RelativePath $entry.Value
        if ($null -eq $parsed.Frontmatter) {
            $issues += "  MISSING frontmatter: $rel"
            continue
        }
        $fm = $parsed.Frontmatter
        $missing = $RequiredFields | Where-Object { -not $fm.ContainsKey($_) }
        if ($missing) {
            $issues += "  INCOMPLETE frontmatter in ${rel}: missing {$($missing -join ', ')}"
        }
        if ($fm.ContainsKey("type") -and $fm["type"] -notin $ValidTypes) {
            $issues += "  INVALID type '$($fm["type"])' in $rel"
        }
        if ($fm.ContainsKey("status") -and $fm["status"] -notin $ValidStatuses) {
            $issues += "  INVALID status '$($fm["status"])' in $rel"
        }
    }
    return $issues
}

function Check-Filenames {
    param($Pages)
    $issues = @()
    $pattern = '^[a-z0-9]+(-[a-z0-9]+)*\.md$'
    foreach ($entry in $Pages.GetEnumerator()) {
        $filename = $entry.Value.Name
        if ($filename -cnotmatch $pattern) {
            $rel = Get-RelativePath $entry.Value
            $issues += "  BAD filename: $rel (expected lowercase-hyphenated)"
        }
    }
    return $issues
}

function Check-Wikilinks {
    param($Pages)
    $issues = @()
    $allStems = [System.Collections.Generic.HashSet[string]]::new()
    $Pages.Keys | ForEach-Object { [void]$allStems.Add($_) }

    foreach ($entry in $Pages.GetEnumerator()) {
        $parsed = Parse-Frontmatter $entry.Value
        $links = Get-Wikilinks $parsed.Content
        foreach ($link in $links) {
            if (-not $allStems.Contains($link)) {
                $rel = Get-RelativePath $entry.Value
                $issues += "  BROKEN link [[$link]] in $rel"
            }
        }
    }
    return $issues
}

function Check-Orphans {
    param($Pages)
    $inbound = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($entry in $Pages.GetEnumerator()) {
        $parsed = Parse-Frontmatter $entry.Value
        $links = Get-Wikilinks $parsed.Content
        foreach ($link in $links) { [void]$inbound.Add($link) }
    }

    $issues = @()
    foreach ($stem in $Pages.Keys) {
        if ($stem -notin $ExemptPages -and -not $inbound.Contains($stem)) {
            $rel = Get-RelativePath $Pages[$stem]
            $issues += "  ORPHAN page: $rel (no inbound links)"
        }
    }
    return $issues
}

function Check-IndexCoverage {
    param($Pages)
    $indexPath = Join-Path $WikiDir "index.md"
    if (-not (Test-Path $indexPath)) {
        return @("  MISSING index.md")
    }
    $indexContent = Get-Content $indexPath -Raw -Encoding UTF8
    $indexLinks = Get-Wikilinks $indexContent

    $issues = @()
    foreach ($stem in $Pages.Keys) {
        if ($stem -notin $ExemptPages -and -not $indexLinks.Contains($stem)) {
            $rel = Get-RelativePath $Pages[$stem]
            $issues += "  NOT IN INDEX: $rel"
        }
    }
    return $issues
}

function Check-RelatedField {
    param($Pages)
    $issues = @()
    $allStems = [System.Collections.Generic.HashSet[string]]::new()
    $Pages.Keys | ForEach-Object { [void]$allStems.Add($_) }

    foreach ($entry in $Pages.GetEnumerator()) {
        $parsed = Parse-Frontmatter $entry.Value
        if ($null -eq $parsed.Frontmatter -or -not $parsed.Frontmatter.ContainsKey("related")) { continue }
        $relatedRaw = $parsed.Frontmatter["related"]
        # Parse YAML array: [item1, item2]
        if ($relatedRaw -match '^\[(.+)\]$') {
            $items = $Matches[1] -split ',\s*'
            foreach ($item in $items) {
                $item = $item.Trim()
                if ($item -and -not $allStems.Contains($item)) {
                    $rel = Get-RelativePath $entry.Value
                    $issues += "  BROKEN related '$item' in $rel (page not found)"
                }
            }
        }
    }
    return $issues
}

function Check-ModulePathsExist {
    param($Pages)
    $issues = @()
    $repoRoot = (Resolve-Path (Join-Path $WikiDir "..")).Path
    foreach ($entry in $Pages.GetEnumerator()) {
        $parsed = Parse-Frontmatter $entry.Value
        if ($null -eq $parsed.Frontmatter -or -not $parsed.Frontmatter.ContainsKey("source_paths")) { continue }
        $raw = $parsed.Frontmatter["source_paths"]
        if ($raw -match '^\[(.+)\]$') {
            $items = $Matches[1] -split ',\s*'
            foreach ($p in $items) {
                $p = $p.Trim().Trim('"', "'")
                if ($p -and -not (Test-Path (Join-Path $repoRoot $p))) {
                    $rel = Get-RelativePath $entry.Value
                    $issues += "  STALE source_path '$p' in $rel (code removed or moved)"
                }
            }
        }
    }
    return $issues
}

# --- Main ---

$pages = Get-WikiPages
Write-Host "Found $($pages.Count) wiki pages.`n"

$checks = @(
    @{ Name = "Frontmatter";     Fn = { Check-Frontmatter $pages };      Warn = $false }
    @{ Name = "Filenames";       Fn = { Check-Filenames $pages };        Warn = $false }
    @{ Name = "Wikilinks";       Fn = { Check-Wikilinks $pages };        Warn = $false }
    @{ Name = "Related Fields";  Fn = { Check-RelatedField $pages };     Warn = $false }
    @{ Name = "Source Paths";    Fn = { Check-ModulePathsExist $pages }; Warn = $true }
    @{ Name = "Orphans";         Fn = { Check-Orphans $pages };          Warn = $false }
    @{ Name = "Index Coverage";  Fn = { Check-IndexCoverage $pages };    Warn = $false }
)

$totalIssues = 0
$totalWarnings = 0
foreach ($check in $checks) {
    $issues = & $check.Fn
    if ($issues.Count -eq 0) {
        $status = "PASS"; $color = "Green"
    } elseif ($check.Warn) {
        $status = "WARN"; $color = "Yellow"
    } else {
        $status = "FAIL"; $color = "Red"
    }
    Write-Host "[$status] $($check.Name)" -ForegroundColor $color
    foreach ($issue in $issues) {
        Write-Host $issue -ForegroundColor Yellow
    }
    if ($check.Warn) {
        $totalWarnings += $issues.Count
    } else {
        $totalIssues += $issues.Count
    }
    if ($issues.Count -gt 0) { Write-Host "" }
}

Write-Host "`n$('=' * 40)"
if ($totalIssues -eq 0) {
    Write-Host "All checks passed." -ForegroundColor Green
} else {
    Write-Host "$totalIssues issue(s) found." -ForegroundColor Red
}
exit ([int]($totalIssues -gt 0))
