---
tags: [status/active, type/manual]
---

# MANUAL — how to operate this vault

This is the user-facing guide. If you just finished the wizard, start here. Everything else in `system/` is machinery the manual refers to.

## The gist of Lauda OS

Four things. Learn these and you have the system.

1. **Pushed context.** Every folder with work in it has a `CLAUDE.md` that tells Claude what matters there. The root CLAUDE.md links down into project-level CLAUDE.md files. You do not "ask Claude to read"; the context is already there when Claude starts.
2. **Three agents, three cadences.** Engineer supports you daily. Scrutineer audits the system weekly. Principal reviews monthly and checks for updates or keeps track in online topics you find intresting. They propose, you commit.
3. **Archive, never delete.** Anything retired moves to `archive/`. Nothing is ever gone.
4. **Obsidian sees the vault as a graph.** You can use Obsidian for navigation, backlinks, and search. Claude does not need Obsidian to work.

That is the whole system.

## Daily loop

1. Open your IDE (Claude Code/Cowork) in this folder.
2. Type whatever you are working on. Claude already has context because of the pushed CLAUDE.md chain.
3. At the end of the session, Claude's PreCompact hook archives the transcript to `system/chat-archive/YYYY-MM/` automatically. You do not trigger it.
4. If Claude made proposals, they land in `system/agents/pending-decisions.md`. Review when you want.

## Weekly loop (Scrutineer)

On Sunday, or whenever you want a pit stop, activate the Scrutineer agent (see `system/agents/scrutineer.md`). It scans:

- Files missing `tags:` frontmatter.
- `priorities.md` if it has not been touched in seven days.
- CLAUDE.md files that reference other files that no longer exist.
- Folders that have accumulated drafts.

Scrutineer writes a report to `system/agents/scrutineer-report.md`. You read, decide, commit.

## Monthly loop (Principal)

Principal is a scaffolded opt-in. Activate when you want a step-back review of direction. It reads your last month of priorities, the scrutineer reports, and any pending decisions, and proposes strategic adjustments. Same contract: propose, never commit.

Default template ships Principal as a prompt file at `system/agents/principal.md` but does not schedule it. You run it on demand.

## Voice

If you plan to publish anything from this vault (articles, essays, posts), edit `personal/voice.md`. That file is the spec Claude uses when drafting public content for you. The trusted-lieutenant voice in Lauda OS is a suggestion, not a rule.

Key tone defaults in the template:

- No em dashes mid-sentence.
- No "LLM-median" phrases like "let's dive in", "I hope this helps".
- Assume the reader is smart and busy.
- Short sentences. Active voice.

## Tagging

Every `.md` file you want Scrutineer to respect needs a `tags:` frontmatter block. Minimum:

```yaml
---
tags: [status/active]
---
```

Recognized tag prefixes:

- `status/`: `active`, `draft`, `archived`, `blocked`, `done`
- `type/`: `project-root`, `manual`, `priorities`, `note`, `spec`, `agent`, `handover`, `session-transcript`, `voice`
- `project/`: `{slug}` of the project this file belongs to

Scrutineer flags files missing `tags:` weekly. You fix in batch.

## Archive, never delete

If a file has outlived its purpose:

- Move it to `archive/<same-subpath>/<filename>`.
- Add `archived: {date}` to its frontmatter.
- Update any CLAUDE.md that linked to it so dead links do not accumulate.

That is the only move. `rm` is not in this system's vocabulary.

## Firewall

If the wizard set a firewall, one project folder is marked "never commits to git, never quoted externally". That project's `CLAUDE.md` has a firewall header at the top. The folder is in `.gitignore`.

Three rules:

- Do not paste that project's file contents into any public output.
- Do not let Claude write from that project's context into a public file.
- Do not commit that folder. Ever.

If you hit a case where the line is unclear, ask Claude to propose the safe framing and confirm before shipping.

## Team mode

If the wizard set team mode, other people will also write into this vault. The template does not enforce permissions. Convention only:

- Every non-system file gets an `author:` frontmatter line.
- Every project folder has one owner named in its `CLAUDE.md`.
- Scrutineer respects `author:` when flagging stale drafts.
- Conflicts are resolved by conversation, not by the system.

If you outgrow convention-only team mode, the backlog in the public repo has notes on where per-author permissioning would start.

## Sync notes

If your vault is in iCloud, Dropbox, OneDrive, or Google Drive, the wizard wrote a sync note to `system/conventions.md`. Read it. Common problems:

- iCloud can stall on deeply nested folders. Keep session archives under `system/chat-archive/YYYY-MM/` so they rotate.
- Dropbox does not like `.obsidian/workspace.json` churn. The wizard added it to `.gitignore` if present.
- OneDrive occasionally eats `.DS_Store` files. Harmless.

## Agents — what they see and do not see

Agents run inside the same Claude session, with access to the same files. They differ in **prompt**, not in **permissions**.

- Engineer: reads the full vault. Writes freely under `projects/` and `personal/` when you ask.
- Scrutineer: reads the full vault. Writes only to `system/agents/scrutineer-report.md`. Proposes changes in that file.
- Principal: reads the full vault. Writes only to `system/agents/principal-report.md`. Proposes bigger moves.

If an agent wants to touch `CLAUDE.md`, root principles, or the firewall, it must write a proposal to `pending-decisions.md` first and wait for you to commit.

## Session archive

Every session gets archived automatically by the PreCompact hook. Files land in `system/chat-archive/YYYY-MM/{timestamp}-session.md` with redactions applied per `system/redactions.txt`.

If you want to find a past session:

```bash
rg "keyword" system/chat-archive/
```

For heavy usage (hundreds of sessions), see `BACKLOG` in the public repo. An INDEX.md generator is planned.

## Recovery

If setup went sideways:

- Wizard file still at root, vault partially scaffolded: run `Hello wizard` again. The wizard is idempotent on folder creation but will ask before overwriting files.
- Operating root CLAUDE.md missing: copy the template block from `archive/system/wizard-CLAUDE.md` (bottom of that file) into a new `CLAUDE.md` at root and edit the answers.
- PreCompact hook not firing: check `system/chat-archive/pre-compact.log`. If empty, the hook is not wired. See `system/hooks/pre-compact.sh` comments and verify `.claude/settings.json` points at it.
- Agent refuses to propose: your agent file in `system/agents/` was edited in a way that removed the "propose-never-commit" block. Revert or restore from `.git` history.

## Extending the system

This template is the 80%. The repo BACKLOG lists the other 20%. Common extensions:

- Claude skill for new-project scaffolding (when you create projects often).
- INDEX.md generator for session archive (when the archive gets big).
- CRM pattern for `personal/network/` (when you start tracking contacts).
- Voice-spec importer (when you want to borrow another writer's voice).

Propose your own and the repo will decide case by case.

## Principles the system runs on

- **Pushed context beats triggered tools.** Every folder tells Claude what matters there.
- **Propose, never commit.** Agents write drafts. You commit.
- **Archive, never delete.** Reversible by default.
- **Racing lines stay clean.** One owner per file, clear firewalls, honest tags.
- **The system should get out of your way.** If a weekly ritual feels like friction, kill it.
