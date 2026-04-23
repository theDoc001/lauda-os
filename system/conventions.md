---
tags: [status/active, type/conventions]
---

# Conventions

House rules for this vault. The wizard writes the parts that depend on your answers. Everything else is the default you can edit as you like.

## Naming

- Folders: `kebab-case`.
- Files: `kebab-case.md`. Exception: `CLAUDE.md` is uppercase (convention followed by Claude Code).
- Project slugs: short, memorable, permanent. Rename is expensive because CLAUDE.md references update by hand.

## Tagging

See `MANUAL.md` → "Tagging" for the full schema. Short version: every `.md` file gets a `tags:` block. Minimum `status/active`.

## Frontmatter fields

Standard fields across the vault. Use them when they apply, omit when they don't.

```yaml
---
tags: [status/active, type/note]
owner: {name}              # optional, defaults to vault owner
author: {name}             # team mode only
created: 2026-04-20
last-reviewed: 2026-04-20
status: active             # mirrors tag, read by scripts
archived: 2026-04-20       # only if tag is status/archived
---
```

## Writing style

- Short sentences.
- Active voice.
- Use code blocks for commands, file paths with backticks.
- No em dashes mid-sentence. Use a period or a comma.
- No "LLM-median" openings like "let's dive in", "I hope this helps", "it's worth noting".
- Numbered lists only when order matters. Otherwise bullets.

## Voice (public writing)

See `personal/voice.md`. That file is the source of truth for voice when you publish anything from this vault.

## CLAUDE.md hygiene

- Root CLAUDE.md: under 2000 tokens.
- Category CLAUDE.md (if used): under 500 tokens.
- Project CLAUDE.md: under 1000 tokens.
- Total pushed context across the chain: under 4000 tokens.

If you exceed: move detail out to linked files and keep CLAUDE.md to pointers.

## Agent hygiene

- Each agent has one file in `system/agents/{name}.md`.
- Each agent's prompt block opens with its contract ("proposes, never commits").
- Each agent writes reports to `system/agents/{name}-report.md`. It does not overwrite other files.
- Agents that want to change root principles, firewall, or voice must write to `system/agents/pending-decisions.md` and wait for the owner to commit.

## Archive rules

See `MANUAL.md` → "Archive, never delete". This file repeats the rule in a spot where automation can find it: **delete is never the right answer**. Move to `archive/` with the same subpath.

## Session archive

- Raw JSONL + redactions, stored as `.md` files under `system/chat-archive/YYYY-MM/`.
- Filename: `{YYYY-MM-DD-HHMMSS}-{pid}-session.md`.
- PreCompact hook writes the file. Nothing else writes here.
- Do not edit archived sessions. If redaction missed something, open the file, fix, note the edit in frontmatter.

## Redactions

See `system/redactions.txt`. Each line is a literal string that gets replaced with `[REDACTED-{label}]` by the PreCompact hook before archiving. Common entries: employer name, client names, any key that slipped into a prompt. Keep the list small and obvious.

## Git

- Default: the vault is a git repo.
- `.gitignore` covers `.DS_Store`, `.obsidian/workspace*.json`, `system/chat-archive/**`, and any firewall folder from the wizard.
- Commit cadence: up to you. Recommended at least weekly after Scrutineer's pass.
- Never commit sessions, secrets, or firewall folders.

## Sync notes

<!-- wizard fills this block if the vault is cloud-synced -->

## Team mode notes

<!-- wizard fills this block if team mode is on -->

## When conventions conflict

If two rules here collide, the rule in `CLAUDE.md` (root) wins. If CLAUDE.md does not speak to it, Scrutineer flags it as an open question and you decide.
