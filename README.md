# agents

Installer and shared configuration for my coding agents: Claude Code, Codex,
pi, Antigravity and opencode.

## What it does

1. **Global instructions** — symlinks `global/AGENTS.md` to each agent's
   global instructions file:

   | Agent       | Location                         |
   |-------------|----------------------------------|
   | Claude Code | `~/.claude/CLAUDE.md`            |
   | Codex       | `~/.codex/AGENTS.md`             |
   | pi          | `~/.pi/agent/AGENTS.md`          |
   | Antigravity | `~/.gemini/GEMINI.md`            |
   | opencode    | `~/.config/opencode/AGENTS.md`   |

   Existing non-symlink files are backed up to `<file>.bak.<timestamp>`.

2. **Agent environment** — installs tools agents can use:
   - [md2html](https://github.com/stevelittlefish/md2html): latest release
     binary (checksum-verified) to `~/opt/md2html`, symlinked into
     `~/.local/bin/md2html`.

## Install

```sh
git clone https://github.com/stevelittlefish/agents ~/git/agents
cd ~/git/agents
./install.sh
```

The script is idempotent; re-run it any time to update md2html or repair links.
Requires `curl`, `tar` and `sha256sum` (or `shasum`). Make sure `~/.local/bin`
is on your `PATH`.

## Editing the instructions

Edit `global/AGENTS.md` in this repo. Because every location is a symlink,
changes apply to all agents immediately — just commit them.

(The root `AGENTS.md` is for agents working *on this repo*, not the global one.)
