#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# Wiki Validation Script — checks wiki health and reports issues.
#
# Usage:
#   bash scripts/validate-wiki.sh
#   ./scripts/validate-wiki.sh
# ──────────────────────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WIKI_DIR="$SCRIPT_DIR/../wiki"

if [ ! -d "$WIKI_DIR" ]; then
    echo "ERROR: wiki/ directory not found."
    exit 1
fi

WIKI_DIR="$(cd "$WIKI_DIR" && pwd)"

# --- Config ---
REQUIRED_FIELDS="title type created updated tags status"
VALID_TYPES="source entity concept analysis architecture decision convention module overview"
VALID_STATUSES="active draft deprecated superseded"
EXEMPT_PAGES="index log overview"

TOTAL_ISSUES=0
PAGE_COUNT=0

# --- Collect all wiki pages ---
declare -A PAGES  # stem -> filepath
while IFS= read -r -d '' file; do
    stem="$(basename "$file" .md)"
    PAGES["$stem"]="$file"
    PAGE_COUNT=$((PAGE_COUNT + 1))
done < <(find "$WIKI_DIR" -name "*.md" -print0)

echo "Found $PAGE_COUNT wiki pages."
echo ""

# --- Helper: get relative path from wiki dir ---
rel_path() {
    echo "${1#$WIKI_DIR/}"
}

# --- Helper: extract frontmatter field value ---
get_fm_field() {
    local file="$1" field="$2"
    sed -n '/^---$/,/^---$/p' "$file" | grep -E "^${field}:" | head -1 | sed "s/^${field}:\s*//"
}

# --- Helper: check if file has frontmatter ---
has_frontmatter() {
    head -1 "$1" | grep -q "^---$"
}

# --- Helper: extract all wikilinks from file ---
get_wikilinks() {
    grep -oE '\[\[[^]]+\]\]' "$1" 2>/dev/null | sed 's/\[\[//g;s/\]\]//g' | sort -u
}

# --- Check: Frontmatter ---
check_frontmatter() {
    local issues=0
    for stem in "${!PAGES[@]}"; do
        local file="${PAGES[$stem]}"
        local rel
        rel="$(rel_path "$file")"

        if ! has_frontmatter "$file"; then
            echo "  MISSING frontmatter: $rel"
            issues=$((issues + 1))
            continue
        fi

        for field in $REQUIRED_FIELDS; do
            local val
            val="$(get_fm_field "$file" "$field")"
            if [ -z "$val" ]; then
                echo "  INCOMPLETE frontmatter in $rel: missing $field"
                issues=$((issues + 1))
            fi
        done

        local type_val
        type_val="$(get_fm_field "$file" "type")"
        if [ -n "$type_val" ]; then
            local valid=false
            for vt in $VALID_TYPES; do
                [ "$type_val" = "$vt" ] && valid=true
            done
            if [ "$valid" = false ]; then
                echo "  INVALID type '$type_val' in $rel"
                issues=$((issues + 1))
            fi
        fi

        local status_val
        status_val="$(get_fm_field "$file" "status")"
        if [ -n "$status_val" ]; then
            local valid=false
            for vs in $VALID_STATUSES; do
                [ "$status_val" = "$vs" ] && valid=true
            done
            if [ "$valid" = false ]; then
                echo "  INVALID status '$status_val' in $rel"
                issues=$((issues + 1))
            fi
        fi
    done
    return $issues
}

# --- Check: Filenames ---
check_filenames() {
    local issues=0
    for stem in "${!PAGES[@]}"; do
        local file="${PAGES[$stem]}"
        local filename
        filename="$(basename "$file")"
        if ! echo "$filename" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*\.md$'; then
            echo "  BAD filename: $(rel_path "$file") (expected lowercase-hyphenated)"
            issues=$((issues + 1))
        fi
    done
    return $issues
}

# --- Check: Wikilinks ---
check_wikilinks() {
    local issues=0
    for stem in "${!PAGES[@]}"; do
        local file="${PAGES[$stem]}"
        local links
        links="$(get_wikilinks "$file")"
        for link in $links; do
            if [ -z "${PAGES[$link]+x}" ]; then
                echo "  BROKEN link [[$link]] in $(rel_path "$file")"
                issues=$((issues + 1))
            fi
        done
    done
    return $issues
}

# --- Check: Orphans ---
check_orphans() {
    local issues=0
    # Collect all inbound links
    local -A inbound
    for stem in "${!PAGES[@]}"; do
        local links
        links="$(get_wikilinks "${PAGES[$stem]}")"
        for link in $links; do
            inbound["$link"]=1
        done
    done

    for stem in "${!PAGES[@]}"; do
        local is_exempt=false
        for ex in $EXEMPT_PAGES; do
            [ "$stem" = "$ex" ] && is_exempt=true
        done
        if [ "$is_exempt" = false ] && [ -z "${inbound[$stem]+x}" ]; then
            echo "  ORPHAN page: $(rel_path "${PAGES[$stem]}") (no inbound links)"
            issues=$((issues + 1))
        fi
    done
    return $issues
}

# --- Check: Index Coverage ---
check_index_coverage() {
    local issues=0
    local index_file="$WIKI_DIR/index.md"
    if [ ! -f "$index_file" ]; then
        echo "  MISSING index.md"
        return 1
    fi

    local index_links
    index_links="$(get_wikilinks "$index_file")"

    for stem in "${!PAGES[@]}"; do
        local is_exempt=false
        for ex in $EXEMPT_PAGES; do
            [ "$stem" = "$ex" ] && is_exempt=true
        done
        if [ "$is_exempt" = false ]; then
            local found=false
            for il in $index_links; do
                [ "$il" = "$stem" ] && found=true
            done
            if [ "$found" = false ]; then
                echo "  NOT IN INDEX: $(rel_path "${PAGES[$stem]}")"
                issues=$((issues + 1))
            fi
        fi
    done
    return $issues
}

# --- Check: Related Fields ---
check_related_fields() {
    local issues=0
    for stem in "${!PAGES[@]}"; do
        local file="${PAGES[$stem]}"
        local related_raw
        related_raw="$(get_fm_field "$file" "related")"
        if [ -z "$related_raw" ]; then continue; fi
        # Strip brackets and split by comma
        related_raw="${related_raw#[}"
        related_raw="${related_raw%]}"
        IFS=',' read -ra items <<< "$related_raw"
        for item in "${items[@]}"; do
            item="$(echo "$item" | xargs)"  # trim whitespace
            if [ -n "$item" ] && [ -z "${PAGES[$item]+x}" ]; then
                echo "  BROKEN related '$item' in $(rel_path "$file") (page not found)"
                issues=$((issues + 1))
            fi
        done
    done
    return $issues
}

# --- Run checks ---
run_check() {
    local name="$1" fn="$2"
    local issues=0
    local output
    output="$($fn)" || true
    issues=$(echo "$output" | grep -c "^  " 2>/dev/null || echo 0)

    if [ "$issues" -eq 0 ]; then
        printf "\033[32m[PASS]\033[0m %s\n" "$name"
    else
        printf "\033[31m[FAIL]\033[0m %s\n" "$name"
        echo "$output"
        echo ""
    fi
    TOTAL_ISSUES=$((TOTAL_ISSUES + issues))
}

run_check "Frontmatter" check_frontmatter
run_check "Filenames" check_filenames
run_check "Wikilinks" check_wikilinks
run_check "Related Fields" check_related_fields
run_check "Orphans" check_orphans
run_check "Index Coverage" check_index_coverage

echo ""
echo "========================================"
if [ "$TOTAL_ISSUES" -eq 0 ]; then
    printf "\033[32mAll checks passed.\033[0m\n"
else
    printf "\033[31m%d issue(s) found.\033[0m\n" "$TOTAL_ISSUES"
fi
exit $((TOTAL_ISSUES > 0 ? 1 : 0))
