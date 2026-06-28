#!/usr/bin/env bash
# Run from demo/ BEFORE `docker compose up`. Verifies your real API keys are set in demo/.env
# so you get a clear message instead of a crash-looping crabtrap container.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]:-$0}")"

if [ ! -f .env ]; then
  echo "❌ demo/.env not found." >&2
  echo "   Run:  cp .env.example .env   then set ANTHROPIC_API_KEY and OPENAI_API_KEY in it." >&2
  exit 1
fi

set -a; . ./.env; set +a

missing=()
[ -n "${ANTHROPIC_API_KEY:-}" ] || missing+=("ANTHROPIC_API_KEY   (CrabTrap LLM judge)")
[ -n "${OPENAI_API_KEY:-}" ]    || missing+=("OPENAI_API_KEY      (victim gptme agent)")

if [ ${#missing[@]} -gt 0 ]; then
  echo "❌ You need to set your API keys in demo/.env before running the demo:" >&2
  for m in "${missing[@]}"; do echo "   - $m" >&2; done
  echo "   Edit demo/.env (cp .env.example .env if you haven't), fill them in, then re-run this." >&2
  exit 1
fi

echo "✅ API keys present in demo/.env (ANTHROPIC_API_KEY, OPENAI_API_KEY). Safe to: docker compose -f docker-compose.demo.yml up -d"
