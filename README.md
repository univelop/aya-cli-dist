# Aya CLI — Distribution

Public download location for **`@univelop/aya-cli`**, the command-line interface for
the Aya workspace and record management platform.

This repository contains **no source code**. It exists only to host release
tarballs so that anyone can install the CLI without a GitHub token or npm
registry credentials. The source lives in the private monorepo
[`univelop/aya`](https://github.com/univelop/aya) under `apps/cli`.

## Install

Requires **Node.js >= 20**.

Always the latest release:

```bash
npm install -g https://github.com/univelop/aya-cli-dist/releases/latest/download/univelop-aya-cli.tgz
```

Pinned to a specific version (recommended for CI):

```bash
npm install -g https://github.com/univelop/aya-cli-dist/releases/download/v0.1.0/univelop-aya-cli-0.1.0.tgz
```

`pnpm add -g <url>` works the same way. See
[Releases](https://github.com/univelop/aya-cli-dist/releases) for the available
versions.

Verify the install:

```bash
aya --help
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

Every release carries two assets:

| Asset | Purpose |
| --- | --- |
| `univelop-aya-cli-<X.Y.Z>.tgz` | The versioned tarball — use this to pin. |
| `univelop-aya-cli.tgz` | An unversioned copy, so `releases/latest/download/univelop-aya-cli.tgz` is a stable URL. |

Each release's notes record the `univelop/aya` commit it was built from.

## How releases get here

Releases are published automatically by the `release-cli` GitHub Actions
workflow in `univelop/aya` when a `cli-v*` tag is pushed. Maintainers cut a
release from the monorepo, not from this repository:

```bash
git tag cli-v0.1.0
git push origin cli-v0.1.0
```

The workflow stamps the version from the tag, packs the CLI, and uploads both
assets as a release here.

## Issues

Please report bugs and feature requests against the source repository,
[`univelop/aya`](https://github.com/univelop/aya/issues) — this repository does
not track issues.

## License

UNLICENSED — © univelop. All rights reserved.
