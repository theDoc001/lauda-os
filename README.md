# Lauda OS

A personal knowledge base for ambitious knowledge workers running multiple
projects in parallel. Extends Obsidian and Claude to hold your work, keep
the racing lines clean between projects, and make your voice carry across
everything you ship.

<img width="1800" height="1100" alt="Image" src="https://github.com/user-attachments/assets/88a9e8f3-bd9a-4354-a79d-47d8d380f16a" />

> Lauda is the voice in your ear during every stint and the engineer who
> takes the car apart after. He saves what you decided yesterday, keeps the
> lines between your projects clean, and calls the warning before you drift
> into the gravel. He proposes, you commit. He tells you the truth, even
> when the truth is that you were wrong on the last lap.

## What this actually is

A starter template (a folder, a few CLAUDE.md files, a small pile of
scripts) that turns a directory into a single, coherent workspace for a
person running several long-running projects with Claude as a working
partner.

You clone it, open it in Cowork or Claude Code, type `Hello wizard`,
answer a handful of questions, and you have a working vault. After that,
the daily loop is: you work, Claude helps, the system keeps the context
clean.

## Before you start

**You need one AI runtime.** Either works:

- **Cowork** (Claude desktop app, currently in research preview). Good if
  you want a chat-first experience and don't live in a terminal.
- **Claude Code CLI**. Good if you already work in a terminal and want
  tight coupling to git and shell tools.

**Obsidian is optional but recommended.** The vault is plain Markdown in
a folder, so Obsidian reads it natively. You get a graph view, backlinks,
and search for free. Install it from [obsidian.md](https://obsidian.md)
and "Open folder as vault" pointed at your cloned Lauda OS folder.

**Git is recommended but optional.** Lauda OS ships as a GitHub template
repo, so the obvious path is `gh repo create` to start your vault. If you
don't use git, you can download the ZIP and unpack it anywhere.

**Time budget.** The setup wizard takes about five to ten minutes end to
end. Pour a coffee first. The wizard asks short questions, confirms once,
scaffolds the vault, and archives itself. You should have a working vault
before the cup cools.

## Quick start

### Via Cowork

1. Clone or download this repo into a folder on your computer.
2. Open Cowork. "Create a new project" then "Use an existing folder" and
   point it at your cloned `lauda-os/` folder.
3. In the chat, type: `Hello wizard`
4. Answer the wizard's questions.

### Via Claude Code CLI

```bash
# clone the template
gh repo create my-vault --template theDoc001/lauda-os --private --clone
cd my-vault

# start a session
claude

# inside the session, trigger the wizard
Hello wizard
```

Either route ends with the wizard scaffolding your vault and archiving
itself. Open `system/MANUAL.md` to learn the daily loop.

## The gist of it

Four ideas do most of the work.

1. **Pushed context beats triggered tools.** Every folder with work in it
   has a `CLAUDE.md` that tells Claude what matters there. The root
   CLAUDE.md links down into project-level ones. Claude never needs to be
   asked to "read the docs" because the context is already there when the
   session starts. (Context from the Vercel AI evals: MCP-trigger retrieval
   fails around 56% of the time. Pushed context doesn't miss.)
2. **Three agents, three cadences.** Each runs on its own rhythm. They
   propose, you commit. No agent autonomously changes principles,
   priorities, or root files.

   - **Engineer (daily):** your working partner for the day. Picks up the
     last handover, flags what is stale, drafts the next move.
   - **Scrutineer (weekly):** audits the system. Checks CLAUDE.md health,
     tag hygiene, folder drift. Files a proposal, never rewrites.
   - **Principal (monthly):** steps back. Reviews direction, scans online
     topics you follow, flags shifts in the landscape worth noticing.
     
3. **Archive, never delete.** Everything retired moves to `archive/` with
   a timestamp. Nothing is ever gone.
4. **Obsidian is the graph.** Use Obsidian for navigation, backlinks, and
   search. Claude reads the same files. They don't compete.

That is the system. Everything in `system/MANUAL.md` is detail on top.

## Who this is for

Knowledge workers running more than one long-running project (side
projects, client work, a thesis, a company, a public presence). People
who already use Claude in some form and want the vault to give Claude
durable context instead of re-explaining every session. People who like
Obsidian but don't want to live inside it. People who want a system that
gets out of their way between pit stops.

It is **not** for teams of more than a few people editing the same vault
(works, but expect rough edges), anyone who wants a hosted polished app
(this is plain Markdown in a folder), or anyone who wants agents to write
autonomously (Lauda OS is propose-never-commit by design).

## How it compares

| System | Graph | Agents | Pushed context | Local-first | Propose-never-commit | Template |
|---|---|---|---|---|---|---|
| Notion AI | no | no | no | no | no | no |
| Obsidian + community plugins | yes | partial | no | yes | varies | yes |
| Claude Projects | no | no | yes (one layer) | no | n/a | no |
| Mem.ai | yes | yes | partial | no | no | no |
| Roam / Logseq | yes | no | no | yes | n/a | partial |
| Tana | yes | partial | no | no | n/a | no |
| Raw Custom Instructions | no | no | yes | n/a | n/a | no |
| **Lauda OS** | yes (via Obsidian) | yes (3, cadenced) | yes (multi-level chain) | yes | yes | yes |

## What you get

```
your-vault/
├── CLAUDE.md              # operating root (written by the wizard)
├── README.md              # this file
├── LICENSE · NOTICE · CHANGELOG.md
├── .claude/settings.json  # hook wiring for session archive
├── docs/                  # deeper docs: setup, architecture, comparison
├── projects/              # where work happens
├── personal/              # principles, priorities, voice, backlog
├── system/
│   ├── MANUAL.md          # user-facing guide
│   ├── conventions.md     # naming, tags, writing style
│   ├── redactions.txt     # PreCompact hook redactions
│   ├── check.sh           # vault health check
│   ├── agents/            # scrutineer, engineer, principal, pending-decisions
│   ├── hooks/             # pre-compact.sh session archiver
│   └── chat-archive/      # YYYY-MM/{timestamp}-session.md
└── archive/               # retired files (never deleted)
```

## Philosophy

Built, not pitched. The aim is to make a Claude-assisted workspace feel
like a decent car: predictable, honest about what it can do, quiet between
corners. No hype, no agent swarms writing over your principles, no
"AI-first" packaging. A folder, some files, a set of agreements about
what gets written where.

The three locked rules:

- **Propose, never commit.** Agents draft. You decide.
- **Archive, never delete.** Reversibility is cheap. Certainty isn't.
- **Keep the racing lines clean.** One owner per file, clear firewalls,
  honest tags.

## About the name

Lauda OS takes its vocabulary from racing culture and heritage. It is an
independent open-source project, not affiliated with, sponsored by, or
endorsed by any motorsport team, or trademarked entity. No photographs,
logos, or registered marks of any third party are used, and none should
be inferred.

## Contributing

Issues and pull requests welcome. Before opening either, skim
[docs/architecture.md](docs/architecture.md) to make sure your proposal
fits the design principles. Things that lean toward autonomous-commit,
required sign-in, or hosted state will be closed.

## License

Apache 2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE).

## Status

Early. MVP scaffolding in place. Expect sharp edges. Feedback welcome.
