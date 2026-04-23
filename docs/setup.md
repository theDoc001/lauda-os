# Setup

The wizard does the work. This doc is for people who want to see what it
does before running it, or who want to set up a vault by hand.

## Before you start

- Claude Code installed and working (`claude --version`).
- `python3` available (the PreCompact hook uses it). macOS and most Linux
  distros ship with it.
- A folder you want to become your vault. It can be in iCloud, Dropbox,
  OneDrive, or plain local; the wizard asks.

## Running the wizard

```bash
# clone the template into a new folder
gh repo create my-vault --template theDoc001/lauda-os --private --clone
cd my-vault
claude
```

Inside the Claude Code session:

```
Hello wizard
```

The wizard asks five questions, one at a time:

1. Who is this vault for? (name / handle)
2. What is your top priority right now? (one line)
3. Will anyone else write into this folder? (solo / team)
4. Is the folder inside a cloud-synced location? (provider / no)
5. Are any projects confidential? (firewall slug / no)

It shows a confirmation block. You type `yes`. It scaffolds, writes the
operating root `CLAUDE.md`, and archives itself.

## What the wizard writes

- `CLAUDE.md`: operating root, under 2000 tokens, with owner, top priority,
  north stars, firewall (if any), principles, agent cadence, folder map.
- `projects/<slug>/CLAUDE.md`: project-level pushed context stub.
- `personal/priorities.md`: top priority as the only item, dated.
- `personal/voice.md`: stub with the trusted-lieutenant block, marked as
  draft.
- `system/conventions.md`: sync notes and team notes if those flags are on.
- `.gitignore`: appended with firewall folder if any.
- `archive/system/wizard-CLAUDE.md`: the wizard file, archived.

## PreCompact hook

The hook at `system/hooks/pre-compact.sh` archives each session's
transcript to `system/chat-archive/YYYY-MM/` before Claude compacts the
context window. Wire it up by adding to `.claude/settings.json`:

```json
{
  "hooks": {
    "PreCompact": [
      {
        "type": "shell",
        "command": "./system/hooks/pre-compact.sh"
      }
    ]
  }
}
```

The hook reads its JSON payload from stdin, copies the transcript from
`transcript_path`, applies redactions from `system/redactions.txt`, and
writes a Markdown file with frontmatter. It logs every invocation to
`system/chat-archive/pre-compact.log` so you can audit whether it ran.

## Health check

```bash
./system/check.sh
```

Exits 0 if the vault looks clean. Exits 1 with warnings if:

- `CLAUDE.md` is missing or still the wizard.
- Core folders are missing.
- The hook is not executable.
- Markdown files are missing `tags:` frontmatter.
- `priorities.md` is older than seven days.

Run it whenever you want a quick status check.

## Setting up by hand

If you prefer not to run the wizard, the template already has the folder
skeleton. Copy the operating CLAUDE.md template block out of `CLAUDE.md`
(the section under "Post-wizard root CLAUDE.md template"), save it as
`CLAUDE.md`, fill in the placeholders, and move the wizard file to
`archive/system/wizard-CLAUDE.md`.

Then create `personal/priorities.md` with one priority, and you are done.
