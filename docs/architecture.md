# Architecture

The design principles behind Lauda OS. Short version: pushed context,
cadenced agents, propose-never-commit, archive-not-delete.

## Pushed context beats triggered tools

Claude models do well with context they receive as part of the system
prompt. They are less reliable at deciding to call a tool that might have
context they need. The Vercel AI team's published evals found
MCP-trigger-based retrieval failing around 56% of the time on tasks that
clearly needed the retrieved context.

Lauda OS pushes the context. Every folder that matters has a `CLAUDE.md`
file. When Claude Code starts a session in a folder, it reads the CLAUDE.md
chain automatically: root → optional category → project. The model never has
to ask; the context is already in its window.

Tradeoff: the context window is finite. Lauda OS caps the chain at ~4000
tokens total and relies on link-out files for detail. Short CLAUDE.md files,
fat linked reference files.

## Three-tier agent cadence

Three agents, three time horizons:

- **Engineer** (daily): working partner. Reads the vault, drafts, handovers
  between sessions.
- **Scrutineer** (weekly): hygiene audit. Flags untagged files, stale
  priorities, broken links, draft rot.
- **Principal** (monthly): step-back review. Asks whether the work still
  matches the stated priorities and proposes system-level changes.

Each agent has a distinct voice and a distinct output file. They do not
share a working file. They do not overwrite each other.

Why three and not one? Because a single always-on agent averages its
attention across time horizons and does all three jobs poorly. Splitting by
cadence keeps each agent focused: Scrutineer does not care about strategy,
Principal does not count missing tags.

## Propose, never commit

Agents write proposals. The owner commits them by hand. Every agent file
repeats this contract. Changes that touch:

- Root `CLAUDE.md`
- `personal/principles.md`
- `personal/voice.md`
- `personal/priorities.md`
- Firewall folders

...must go through `system/agents/pending-decisions.md` and wait for the
owner.

Why not let agents commit small, low-risk changes? Because the boundary
between low-risk and high-risk drifts. Once the system tolerates autonomous
writes anywhere, it slowly tolerates them everywhere. The cheap discipline
is: agents never commit. Period.

## Archive, never delete

Delete is not in the system's vocabulary. Anything retired moves to
`archive/` with the same subpath and an `archived:` frontmatter date.

Why: Claude sometimes proposes to delete files that turn out to be
load-bearing a month later. Archive-not-delete makes every retirement
reversible.

## Session archive

Every session is archived by the PreCompact hook. Redactions are applied
from a user-managed `system/redactions.txt`. Archives live at
`system/chat-archive/YYYY-MM/{timestamp}-{pid}-session.md`.

Two-tier retrieval:

- Raw files on disk (always the source of truth).
- A future `INDEX.md` for cheap grep-able metadata (on the BACKLOG; ship
  when the archive crosses ~30 sessions).

Not in scope: full-text search daemons, vector indexes, embedding stores.
Grep and Obsidian search cover the common cases.

## Firewall

When a user has confidential work (employer IP, client work, anything under
NDA), the wizard offers a firewall. The firewall is three overlapping
protections:

1. Folder convention: `projects/<firewall-slug>/` holds the confidential
   project.
2. Root `CLAUDE.md` block: a firewall section names the folder and the
   rule ("never commits to git, never quoted externally").
3. `.gitignore`: the folder is ignored by git.

The redundancy is deliberate. Any one of the three alone has a failure
mode. All three together make accidental leakage hard.

## Voice as artifact

`personal/voice.md` is the file Claude reads when drafting public writing.
It is not a theme or a style preset. It is a locked spec. The wizard ships
a draft; the user refines it.

Why a file and not a prompt template: the file lives with the work. It
survives model upgrades, tool changes, and IDE switches. A prompt template
dies when the tooling changes.

## Folder schema

```
CLAUDE.md
projects/
  <optional category>/
    CLAUDE.md          # optional category-level pushed context
    <project-slug>/
      CLAUDE.md        # project-level pushed context (required if project exists)
personal/
  priorities.md
  voice.md
  principles.md
  backlog.md
  (network/ crm-style if adopted)
  (watchlist.md if relevant)
system/
  MANUAL.md
  conventions.md
  redactions.txt
  check.sh
  agents/
    scrutineer.md
    engineer.md
    principal.md
    pending-decisions.md
  hooks/
    pre-compact.sh
  chat-archive/
    YYYY-MM/
      {timestamp}-{pid}-session.md
    pre-compact.log
archive/
  <mirror-of-any-subpath>
```

Optional category layer: when `projects/` has more than about five top-level
folders and some of them cluster (e.g., `work/`, `public/`), insert a
category layer with its own `CLAUDE.md`. Claude will read root → category
→ project.

## Why not a database

A database gives better querying and worse portability. Markdown in a
folder gives worse querying and near-perfect portability. The tradeoff
favors portability for personal knowledge work: Claude models improve every
few months, tools churn, but Markdown files still open in twenty years.

## Extension points

- **Claude skills** (backlog): the template ships no skills by default,
  but `system/skills/` is a valid path. Ship a skill when a pattern
  stabilizes into a repeated action.
- **Custom agents**: any `system/agents/{name}.md` file following the same
  contract (proposes, writes to `{name}-report.md`, respects
  `pending-decisions.md` boundaries) is a valid extension.
- **Category CLAUDE.md**: add one when `projects/` clusters.

## Non-goals

- Multi-user real-time collaboration (Obsidian Sync handles single-user
  multi-device; team mode is convention-only).
- A hosted version. Lauda OS is a local-first template.
- A GUI on top of the folder. Obsidian and Claude Code are the UI.
- Autonomous writes anywhere, ever.
