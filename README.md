# Homebrew tap: goagwiki/cli

Install [**agwiki**](https://github.com/goagwiki/agwiki), the **agent-based wiki** CLI, via Homebrew.

**agwiki** helps you manage markdown wikis: **`init`** scaffolding, agent-driven ingest via **`aikit`**, **`validate`** (wikilinks + orphan pages), and export a wiki slice as an [Agent Skill](https://agentskills.io/).

## Platform support

- macOS (Apple Silicon arm64, Intel x86_64)
- Linux (x86_64; formula may select GNU or musl builds per glibc)

## Installation

```bash
brew install goagwiki/cli/agwiki
```

Homebrew installs the binary for your host architecture.

## Usage notes

- **`ingest`**, **`validate`**, and **`export-skill`** accept **`-C` / `--wiki-root`** (content repo with `wiki/`); if omitted, the current working directory is used.
- **`ingest`** reads **`<wiki-root>/ingest.md`**; the file must exist or the command fails. Copy the default from [agwiki `prompts/ingest.md`](https://github.com/goagwiki/agwiki/blob/main/prompts/ingest.md) to **`ingest.md`** in your wiki if needed. The template may use **`{{INGEST_PATH}}`** and **`{{WIKI_ROOT}}`** (filled by `agwiki`).
- **`ingest`** requires **`aikit`** on `PATH`. It runs **`aikit run --events`** so **NDJSON event lines** print on stdout for progress. **`-a` / `--agent` is required** (no default); optional **`-m`** and **`--stream`** like `aikit run`.

## Usage examples

```bash
agwiki --version

# New wiki root (agwiki.toml, dirs, ingest.md)
agwiki init ~/my-wiki

# Agent ingest (requires ~/my-wiki/ingest.md and -a); stdout is aikit --events NDJSON
agwiki ingest -C ~/my-wiki -a opencode ~/my-wiki/raw/article.md
cd ~/my-wiki && agwiki ingest -a opencode ./raw/article.md

# Broken links + orphan pages (exit 1 if any); optional --format json
agwiki validate -C ~/my-wiki
agwiki validate --format json

# Build skill/ from wiki (template + index-driven section list)
agwiki export-skill -C ~/my-wiki --prune
```

Use `agwiki <subcommand> --help` for flags (including `after_help` examples).

## Upgrading

```bash
brew upgrade agwiki
```

## Uninstalling

```bash
brew uninstall agwiki
brew untap goagwiki/cli
```

## Links

- [agwiki on GitHub](https://github.com/goagwiki/agwiki)
- [Scoop bucket (Windows)](https://github.com/goagwiki/scoop-bucket)
