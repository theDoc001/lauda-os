#!/bin/bash
# pre-compact.sh — archive session transcript before Claude compact
# Runs as PreCompact hook defined in .claude/settings.json.
#
# Contract: Claude Code pipes hook JSON on stdin with at least:
#   { "session_id": "...", "transcript_path": "/path/to/session.jsonl", "hook_event_name": "PreCompact", ... }
# The transcript_path points to the raw session JSONL. We copy it, redact, and archive.
#
# Dependency: python3 (ships with macOS and most Linux distros). No jq required.
#
# Install:
#   1. chmod +x system/hooks/pre-compact.sh
#   2. In .claude/settings.json add:
#      { "hooks": { "PreCompact": [{ "type": "shell", "command": "./system/hooks/pre-compact.sh" }] } }
#   3. First compact will create the log and the first archive file.

set -e

# VAULT = the folder this script's parent-parent points to.
# Works no matter where the user places the vault.
VAULT="$(cd "$(dirname "$0")/../.." && pwd)"

ARCHIVE_DIR="${VAULT}/system/chat-archive/$(date +%Y-%m)"
ARCHIVE_FILE="${ARCHIVE_DIR}/$(date +%Y-%m-%d-%H%M%S)-$$-session.md"
LOG_FILE="${VAULT}/system/chat-archive/pre-compact.log"
REDACTIONS_FILE="${VAULT}/system/redactions.txt"

mkdir -p "$ARCHIVE_DIR"

# Capture hook JSON from stdin
HOOK_INPUT=$(cat)

# Parse fields via python3 (always present on macOS and most Linux)
parse_field() {
    local field="$1"
    echo "$HOOK_INPUT" | python3 -c "import json,sys
try:
    d = json.load(sys.stdin)
    print(d.get('$field', '') or '')
except Exception:
    print('')
" 2>/dev/null
}

TRANSCRIPT_PATH=$(parse_field "transcript_path")
SESSION_ID=$(parse_field "session_id")
EVENT_NAME=$(parse_field "hook_event_name")

# Log every invocation so the user can audit whether the hook is firing
echo "$(date -Iseconds) event=${EVENT_NAME:-unknown} session=${SESSION_ID:-unknown} transcript=${TRANSCRIPT_PATH:-none}" >> "$LOG_FILE"

# If no transcript, write a stub so we know the hook fired but input was empty
if [ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
    {
        echo "---"
        echo "date: $(date +%Y-%m-%d)"
        echo "archived: $(date -Iseconds)"
        echo "session_id: ${SESSION_ID:-unknown}"
        echo "event: ${EVENT_NAME:-unknown}"
        echo "status: hook-fired-no-transcript"
        echo "tags: [status/archived, type/session-transcript]"
        echo "---"
        echo "# PreCompact fired without usable transcript"
        echo ""
        echo "Hook input received:"
        echo '```json'
        echo "$HOOK_INPUT"
        echo '```'
    } > "$ARCHIVE_FILE"
    echo "pre-compact: hook fired but no transcript path found; stub written to ${ARCHIVE_FILE}"
    exit 0
fi

# Read transcript
SESSION_CONTENT=$(cat "$TRANSCRIPT_PATH")

# Apply redactions from redactions.txt (one literal string per line)
REDACTED="$SESSION_CONTENT"
REDACTION_COUNT=0
if [ -f "$REDACTIONS_FILE" ]; then
    while IFS= read -r pattern || [ -n "$pattern" ]; do
        # skip empty lines and comments
        case "$pattern" in
            ''|\#*) continue ;;
        esac
        # escape for sed
        escaped=$(printf '%s\n' "$pattern" | sed 's/[][\/.*^$]/\\&/g')
        before=$(echo "$REDACTED" | grep -c "$pattern" || true)
        REDACTED=$(echo "$REDACTED" | sed "s/${escaped}/[REDACTED]/g")
        REDACTION_COUNT=$((REDACTION_COUNT + before))
    done < "$REDACTIONS_FILE"
fi

# Write archive with frontmatter + raw (redacted) JSONL fenced below
{
    echo "---"
    echo "date: $(date +%Y-%m-%d)"
    echo "archived: $(date -Iseconds)"
    echo "session_id: ${SESSION_ID:-unknown}"
    echo "event: ${EVENT_NAME:-unknown}"
    echo "transcript_source: ${TRANSCRIPT_PATH}"
    echo "redactions: ${REDACTION_COUNT}"
    echo "status: archived"
    echo "tags: [status/archived, type/session-transcript]"
    echo "---"
    echo "# Session Archive: $(date '+%Y-%m-%d %H:%M')"
    echo ""
    if [ "$REDACTION_COUNT" -gt 0 ]; then
        echo "> Redaction log: ${REDACTION_COUNT} match(es) replaced per system/redactions.txt."
        echo ""
    fi
    echo "## Raw transcript (JSONL)"
    echo ""
    echo '```jsonl'
    echo "$REDACTED"
    echo '```'
} > "$ARCHIVE_FILE"

echo "pre-compact: archived session to ${ARCHIVE_FILE} (${REDACTION_COUNT} redactions)"
