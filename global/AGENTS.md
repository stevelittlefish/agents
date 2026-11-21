# Global Agent Instructions

These instructions apply to every coding agent (Claude Code, Codex, pi,
Antigravity, opencode). They are installed from `~/git/agents` — edit them
there, not at the symlinked locations.

## Environment

Tools available on this machine:

- **md2html** — converts Markdown to HTML (`md2html --help` for usage).
  Use it when HTML output of a Markdown document is wanted.

## File references

When showing the user a file path, write it as a clickable `file://` link
with the absolute path, e.g. `file:///home/steve/git/agents/README.md`.

## Commit messages

Use this format:

```
Short imperative summary (≤72 chars)

Optional body explaining what changed and why, wrapped at 72 columns.

Co-Authored-By: <Model Name> <noreply@<vendor domain>>
```

- Summary line in the imperative mood ("Add X", not "Added X"), no
  trailing period.
- Blank line between summary and body.
- Always end with a `Co-Authored-By:` trailer naming the model that wrote
  the change, e.g.:
  - `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`
  - `Co-Authored-By: GPT-5 <noreply@openai.com>`
  - `Co-Authored-By: Gemini 3 Pro <noreply@google.com>`

## Git usage

- Prefer merge over rebase.
- Never rewrite history unless asked to.
- Prefer follow-up commits to fix things instead of reverting, unless the
  entire commit needs to be reverted.
- It's fine to bundle several changes into one commit. When the work is
  done, there's no need to split it into multiple commits.
