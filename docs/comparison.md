# Comparison with adjacent systems

Honest look at where Lauda OS sits next to things it overlaps with. Short
version: Lauda OS is opinionated about a narrow slice (Claude-assisted
personal knowledge work with long-running projects), and generic on the
rest. If you want a hosted app, a full PKM theory, or autonomous agents,
there are better tools.

## Feature matrix

| System | Graph | Agents | Pushed context | Local-first | Propose-never-commit | Template | Focus |
|---|---|---|---|---|---|---|---|
| **Lauda OS** | yes (via Obsidian) | yes (3, cadenced) | yes (multi-level chain) | yes | yes | yes | Claude + Obsidian personal KB |
| Notion AI | no | no | no | no | no | no | Hosted docs + DBs + AI |
| Obsidian + plugins | yes | partial | no | yes | varies | yes | Local Markdown PKM |
| Claude Projects | no | no | yes (one layer) | no | n/a | no | Single-project chat context |
| Mem.ai | yes | yes | partial | no | no | no | AI-native hosted notes |
| Roam / Logseq | yes | no | no | yes | n/a | partial | Outliner-based graph notes |
| Tana | yes | partial | no | no | n/a | no | Structured outliner |
| Raw Custom Instructions | no | no | yes | n/a | n/a | no | Single-system-prompt context |

## Pairwise notes

### Obsidian + community plugins

Closest neighbor in spirit. Lauda OS runs *inside* Obsidian. The vault is
an Obsidian vault, the graph view works, backlinks work, Dataview queries
work if you install the plugin. What Lauda OS adds on top:

- A CLAUDE.md chain Obsidian does not know about, consumed by Claude Code.
- A three-agent cadence with distinct output files.
- A session archive pipeline via PreCompact hook.
- Convention files (MANUAL, conventions, redactions) that make the vault
  coherent to Claude.

If you use Obsidian alone and it works, you don't need Lauda OS. If you want
Claude to have durable context across sessions without you re-explaining,
Lauda OS is Obsidian with the Claude side added.

### Notion AI

Different category. Notion is a hosted database-plus-docs platform with a
chat assistant bolted on. Lauda OS is a local Markdown template for Claude
Code. Use Notion if you want team docs with hosted AI. Use Lauda OS if you
want a local vault with cadenced agents and you already live in Claude
Code.

### Claude Projects

Claude Projects gives you one system-prompt layer per project in the
Claude.ai UI. Useful for clean chat contexts but not a knowledge base.
Lauda OS is for people who want Markdown files, a graph, agents with
distinct cadences, and persistent session archives.

You can use both: Lauda OS as your working vault, Claude Projects for
specific conversations you want to keep isolated in the hosted UI.

### Mem.ai

Mem positions itself as an AI-native hosted note-taker. Strong on
automatic tagging and surfacing. Lauda OS is the opposite axis: local
files, manual tags, explicit agent boundaries, no automatic anything.

Pick Mem if you want an AI to surface things. Pick Lauda OS if you want
a system that gets out of your way and gives Claude structured context
when you ask.

### Roam / Logseq

Outliner-first. Graph-first. Opinionated about bullet structure. Lauda OS
does not use an outliner model. Files are files, headings are headings.
If you love the bullet-tree model, Roam/Logseq are a better fit and the
two approaches don't combine cleanly.

### Tana

Structured outliner with "supertags" and a strong schema. Powerful but
opinionated and not local-first. Lauda OS takes a different bet: plain
Markdown is good enough if the conventions are clear.

### Raw Custom Instructions

A single system prompt in Claude.ai or similar. The cheapest option with
the lowest ceiling. If your life fits in one paragraph, Custom
Instructions are fine. Lauda OS exists because most ambitious people's
work does not fit in one paragraph and needs to be retrievable in pieces.

## What Lauda OS deliberately does not have

- **A plugin marketplace.** The template is small and opinionated; it does
  not aim to be a platform.
- **Autonomous writes.** Agents never commit. This is a design constraint,
  not a temporary limitation.
- **Hosted sync.** iCloud / Dropbox / OneDrive work well. The project will
  not ship its own sync.
- **Full-text search.** Grep is enough for most cases, Obsidian's built-in
  search covers the rest. A full-text daemon sits on the backlog and may
  never ship.
- **Automatic tagging.** Tagging is a thinking exercise. Handing it to an
  agent defeats the point.

## When Lauda OS is the wrong choice

- You do not want to run Claude Code.
- You want an app with UI polish, not a folder and a Markdown convention.
- You want AI agents that autonomously maintain your knowledge base.
- You are building for a team of ten or more and need real permissions,
  review queues, and merge workflows.

In those cases, look at Notion AI, Mem, or Obsidian Sync with a team
convention on top of community plugins.
