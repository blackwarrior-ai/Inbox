#!/usr/bin/env bash
# Start Rails + Vite + Sidekiq for local UI dev (run inside WSL).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Shims + mise first so Windows Node (if PATH leaks from WSL interop) never shadows Ruby/bundler.
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:${PATH:-}"
MISE_BIN="${HOME}/.local/bin/mise"
if [[ ! -x "$MISE_BIN" ]]; then
  echo "mise not found at $MISE_BIN — install from https://mise.jdx.dev" >&2
  exit 1
fi
eval "$("$MISE_BIN" activate bash)"
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
hash -r

exec foreman start -f Procfile.dev
