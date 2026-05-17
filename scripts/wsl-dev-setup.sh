#!/usr/bin/env bash
# One-time Chatwoot dev dependencies on WSL (Ubuntu): system packages, mise (Ruby/Node), bundle, pnpm, DB prep.
# Run:  bash scripts/wsl-dev-setup.sh
# Requires: Docker Desktop running with Postgres+Redis (docker-compose.local.yml)

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq
sudo apt-get install -y \
  build-essential libssl-dev zlib1g-dev libreadline-dev libyaml-dev \
  libxml2-dev libxslt-dev libgmp-dev libpq-dev libffi-dev \
  libvips42 libvips-dev imagemagick git curl unzip pkg-config

export PATH="$HOME/.local/bin:$PATH"
hash -r
if ! command -v mise >/dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
fi
export PATH="$HOME/.local/bin:$PATH"
hash -r

mise install -y ruby@3.4.4
mise install -y node@24.13.0
mise use -g ruby@3.4.4
mise use -g node@24.13.0
eval "$(mise activate bash)"
# Prefer mise shims so leaked Windows PATH (Node, etc.) never wins over WSL toolchain.
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
hash -r

command -v node
node -v
npm install -g pnpm@10.22.0
pnpm -v

gem install bundler foreman --no-document
bundle install --jobs="$(nproc)"
pnpm install
bundle exec rails db:chatwoot_prepare

echo "Setup done. Start dev server with:  foreman start -f Procfile.dev  (from $ROOT)"
