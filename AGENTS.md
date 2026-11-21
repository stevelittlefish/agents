# AGENTS.md (this repo)

This repo installs shared configuration for coding agents. See README.md.

- `global/AGENTS.md` — the global instructions installed for all agents. Edit
  this to change agent behaviour everywhere.
- `install.sh` — idempotent installer: symlinks `global/AGENTS.md` into each
  agent's config location and installs environment tools (md2html).

When adding a new agent, add its path to `TARGETS` in `install.sh` and to the
table in README.md. When adding a new environment tool, add an `install_<tool>`
function, call it at the bottom of `install.sh`, and document it in README.md
and in the Environment section of `global/AGENTS.md`.

Keep `install.sh` idempotent and safe: never delete user files — back them up.
