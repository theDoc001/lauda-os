#!/bin/bash
# check.sh — quick health check for the vault
# Run from the vault root: `./system/check.sh`
# Exits 0 if healthy, 1 if warnings found.

set -u

VAULT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$VAULT_ROOT"

WARNINGS=0

echo "Lauda OS health check — $(date -Iseconds)"
echo "Vault: $VAULT_ROOT"
echo ""

# 1. Root CLAUDE.md exists and is not the wizard
if [ ! -f "CLAUDE.md" ]; then
    echo "FAIL: no CLAUDE.md at root. Run 'Hello wizard' to set up."
    WARNINGS=$((WARNINGS + 1))
elif grep -q "version: wizard-" CLAUDE.md; then
    echo "WARN: root CLAUDE.md is still the wizard. Finish setup."
    WARNINGS=$((WARNINGS + 1))
else
    echo "OK:   root CLAUDE.md operational"
fi

# 2. Core folders present
for d in projects personal system system/agents system/hooks system/chat-archive archive; do
    if [ ! -d "$d" ]; then
        echo "WARN: folder missing: $d"
        WARNINGS=$((WARNINGS + 1))
    fi
done

# 3. PreCompact hook executable
HOOK="system/hooks/pre-compact.sh"
if [ -f "$HOOK" ]; then
    if [ ! -x "$HOOK" ]; then
        echo "WARN: $HOOK is not executable. Run: chmod +x $HOOK"
        WARNINGS=$((WARNINGS + 1))
    else
        echo "OK:   pre-compact.sh is executable"
    fi
else
    echo "WARN: $HOOK missing"
    WARNINGS=$((WARNINGS + 1))
fi

# 4. PreCompact log exists (fires at least once since setup)
LOG="system/chat-archive/pre-compact.log"
if [ ! -f "$LOG" ]; then
    echo "INFO: pre-compact.log not found yet. Will appear after first compact."
fi

# 5. Count untagged markdown files (rough heuristic)
if command -v rg >/dev/null 2>&1; then
    UNTAGGED=$(rg --files -g '*.md' -g '!archive/**' -g '!system/chat-archive/**' \
        | while read f; do
            head -5 "$f" 2>/dev/null | grep -q "^tags:" || echo "$f"
          done | wc -l | tr -d ' ')
    if [ "${UNTAGGED:-0}" -gt 0 ]; then
        echo "WARN: $UNTAGGED markdown file(s) without tags: frontmatter"
        WARNINGS=$((WARNINGS + 1))
    else
        echo "OK:   all markdown files have tags"
    fi
else
    echo "INFO: ripgrep not installed, skipping tag audit"
fi

# 6. priorities.md freshness (7-day stale)
PRI="personal/priorities.md"
if [ -f "$PRI" ]; then
    AGE_DAYS=$(( ( $(date +%s) - $(stat -f %m "$PRI" 2>/dev/null || stat -c %Y "$PRI" 2>/dev/null || echo 0) ) / 86400 ))
    if [ "$AGE_DAYS" -gt 7 ]; then
        echo "WARN: priorities.md is ${AGE_DAYS} days old (stale after 7)"
        WARNINGS=$((WARNINGS + 1))
    else
        echo "OK:   priorities.md is ${AGE_DAYS}d old"
    fi
fi

echo ""
if [ "$WARNINGS" -eq 0 ]; then
    echo "Clean lap. No warnings."
    exit 0
else
    echo "$WARNINGS warning(s). See above."
    exit 1
fi
