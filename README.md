# Aya CLI — Distribution

Public download location for **`@univelop/aya-cli`**, the command-line interface for
the Aya workspace and record management platform.

This repository contains **no source code**. It exists only to host release
assets so that anyone can install the CLI without a GitHub token or npm
registry credentials. The source lives in the private monorepo
[`univelop/aya`](https://github.com/univelop/aya) under `apps/cli`.

## Install

### One executable, no Node (macOS Apple Silicon, Linux x86-64 / arm64)

```bash
curl -fsSL https://github.com/univelop/aya-cli-dist/releases/latest/download/install.sh | sh
```

The installer picks the executable for your machine, puts it in `/usr/local/bin`
(when writable) or `~/.local/bin`, and checks that it runs. Pin a version with
`AYA_VERSION=0.1.82`, relocate with `AYA_INSTALL_DIR=~/bin`. Afterwards:

```bash
aya upgrade            # the latest release
aya upgrade 0.1.82     # a pinned one — also the way back from a broken release
```

### The JS package (any platform with Node >= 20)

```bash
npm install -g https://github.com/univelop/aya-cli-dist/releases/latest/download/univelop-aya-cli.tgz
```

Pinned (recommended for CI):

```bash
npm install -g https://github.com/univelop/aya-cli-dist/releases/download/v0.1.82/univelop-aya-cli-0.1.82.tgz
```

`pnpm add -g <url>` works the same way, and `aya upgrade` moves either install
to the latest release. See [Releases](https://github.com/univelop/aya-cli-dist/releases)
for the available versions.

Verify the install:

```bash
aya --version
```

## Getting started

```bash
aya login                          # interactive login
aya login --token <aya_pat_…>      # or authenticate with a personal access token
aya org list                       # confirm access
aya workspace clone <slugOrId>     # pull a workspace into the current directory
```

For headless / CI use, set `AYA_API_KEY` instead of running `aya login`; it
accepts both user-scoped PATs (`aya_pat_…`) and org-scoped API keys
(`aya_key_…`). Run `aya --help` or `aya <command> --help` for the full command
surface, and `aya completion <bash|zsh|fish|powershell|nushell>` to install
shell completions.

## Release assets

| Asset | Purpose |
| --- | --- |
| `install.sh` | The installer above. Also tracked in this repo. |
| `aya-darwin-arm64`, `aya-linux-x64`, `aya-linux-arm64` | One self-contained executable per platform (`bun build --compile`; no Node needed, ~4–6× faster to start). |
| `univelop-aya-cli-<X.Y.Z>.tgz` | The JS package, versioned — use this to pin. |
| `univelop-aya-cli.tgz` | An unversioned copy, so `releases/latest/download/univelop-aya-cli.tgz` is a stable URL. |
| `univelop-aya-cli-<target>[-<X.Y.Z>].tgz` | The executable wrapped as an npm package (`os` / `cpu` pinned). The linux-x64 one is what Aya's agent sandbox preinstalls; a person does not need these. |

Each release's notes record the `univelop/aya` commit it was built from.

## How releases get here

Releases are published automatically by the `release-cli` GitHub Actions
workflow in `univelop/aya` when a `cli-v*` tag is pushed. Maintainers cut a
release from the monorepo, not from this repository:

```bash
git tag cli-v0.1.0
git push origin cli-v0.1.0
```

The workflow stamps the version from the tag, packs the JS package, builds each
executable natively on a runner of its platform, and uploads everything as a
release here.

## Issues

Please report bugs and feature requests against the source repository,
[`univelop/aya`](https://github.com/univelop/aya/issues) — this repository does
not track issues.

## License

UNLICENSED — © univelop. All rights reserved.
