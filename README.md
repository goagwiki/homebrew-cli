# Homebrew tap: goagwiki/cli

Install [**agwiki**](https://github.com/goagwiki/agwiki), the **agent-based wiki** CLI, via Homebrew.

**agwiki** helps you manage markdown wikis: resolve ingest paths, run agent-driven ingest (`aikit` / `opencode`), validate wikilinks, list orphan pages, and export a wiki slice as an [Agent Skill](https://agentskills.io/).

## Platform support

- macOS (Apple Silicon arm64, Intel x86_64)
- Linux (x86_64; formula may select GNU or musl builds per glibc)

## Installation

```bash
brew install goagwiki/cli/agwiki
```

Homebrew installs the binary for your host architecture.

## Environment

| Variable | Purpose |
|----------|---------|
| `AGWIKI_ROOT` | Path to agwiki toolkit (`prompts/ingest.md`, `AGENTS.md`). Also `FASTWIKI_ROOT` / `WIKIFY_ROOT`. |
| `WIKI_ROOT` | Default content wiki root (overridden by `-C` / `--wiki-root`). |

For ingest you need **`aikit`** and **`opencode`** on `PATH` unless you use `--runner opencode` only.

## Usage examples

```bash
agwiki --version

# Print absolute path to a source note (optional: require path under raw/)
agwiki prep -C ~/my-wiki ~/my-wiki/raw/article.md
agwiki prep -C ~/my-wiki --raw-only ~/my-wiki/raw/article.md

# Agent ingest (set AGWIKI_ROOT to your agwiki checkout)
export AGWIKI_ROOT=/path/to/agwiki
agwiki ingest -C ~/my-wiki ~/my-wiki/raw/article.md
agwiki ingest -C ~/my-wiki --runner opencode ~/my-wiki/raw/article.md

# Lint wiki links (exit 1 if any broken)
agwiki check-links -C ~/my-wiki

# Pages with no incoming wikilink
agwiki orphans -C ~/my-wiki

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
