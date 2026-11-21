#!/usr/bin/env bash
# Installs the global AGENTS.md for all agents and the agent environment tools.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$REPO_DIR/global/AGENTS.md"
OPT_DIR="$HOME/opt"
BIN_DIR="$HOME/.local/bin"

# agent -> path where its global instructions file lives
TARGETS=(
  "claude-code:$HOME/.claude/CLAUDE.md"
  "codex:$HOME/.codex/AGENTS.md"
  "pi:$HOME/.pi/agent/AGENTS.md"
  "antigravity:$HOME/.gemini/GEMINI.md"
  "opencode:$HOME/.config/opencode/AGENTS.md"
)

link() {  # link <source> <dest>
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    echo "  ok       $dest"; return
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    local bak="$dest.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dest" "$bak"; echo "  backup   $dest -> $bak"
  fi
  ln -s "$src" "$dest"; echo "  linked   $dest -> $src"
}

install_agents_md() {
  echo "==> Linking global AGENTS.md"
  for t in "${TARGETS[@]}"; do link "$SRC" "${t#*:}"; done
}

install_md2html() {
  echo "==> Installing md2html"
  local repo="stevelittlefish/md2html" os arch
  case "$(uname -s)" in
    Linux) os=linux ;; Darwin) os=macos ;; *) echo "unsupported OS"; return 1 ;;
  esac
  case "$(uname -m)" in
    x86_64|amd64) arch=amd64 ;; aarch64|arm64) arch=arm64 ;; *) echo "unsupported arch"; return 1 ;;
  esac
  local tag
  tag="$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" \
        | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)"
  [[ -n "$tag" ]] || { echo "could not determine latest release"; return 1; }

  if [[ -x "$OPT_DIR/md2html" ]] && "$OPT_DIR/md2html" --version 2>/dev/null | grep -q "$tag"; then
    echo "  ok       md2html $tag already installed"
  else
    local asset="md2html-$tag-$os-$arch.tar.gz"
    [[ "$os" == macos ]] && asset="md2html-$tag-macos.tar.gz"
    local base="https://github.com/$repo/releases/download/$tag" tmp
    tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' RETURN
    curl -fsSL -o "$tmp/$asset" "$base/$asset"
    curl -fsSL -o "$tmp/SHA256SUMS" "$base/SHA256SUMS"
    (cd "$tmp" && grep " $asset\$" SHA256SUMS | { command -v sha256sum >/dev/null \
        && sha256sum -c - || shasum -a 256 -c -; }) >/dev/null
    mkdir -p "$tmp/x" && tar -xzf "$tmp/$asset" -C "$tmp/x"
    local bin; bin="$(find "$tmp/x" -type f -name md2html | head -1)"
    [[ -n "$bin" ]] || { echo "md2html binary not found in archive"; return 1; }
    mkdir -p "$OPT_DIR"
    install -m 755 "$bin" "$OPT_DIR/md2html"
    echo "  installed md2html $tag -> $OPT_DIR/md2html"
  fi
  link "$OPT_DIR/md2html" "$BIN_DIR/md2html"
  case ":$PATH:" in *":$BIN_DIR:"*) ;; *) echo "  note: $BIN_DIR is not on your PATH" ;; esac
}

install_agents_md
install_md2html
echo "Done."
