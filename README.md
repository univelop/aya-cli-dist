# Aya CLI — Downloads

Public download location for **`aya`**, the command-line interface for the Aya
workspace and record management platform.

This repository contains **no source code**. It only hosts the release
downloads, so that anyone can install the CLI without a GitHub token or npm
registry credentials. Every release is built from the private monorepo
`univelop/aya`; its notes name the commit it was built from.

## Install

### macOS (Apple Silicon) and Linux (x86-64, arm64)

One self-contained executable — no Node.js needed:

```bash
curl -fsSL https://github.com/univelop/aya-cli-dist/releases/latest/download/install.sh | sh
```

It picks the executable for your machine, puts it in `/usr/local/bin` when that
is writable (else `~/.local/bin`) and checks that it runs. Options:

```bash
# a specific version
curl -fsSL https://github.com/univelop/aya-cli-dist/releases/latest/download/install.sh | AYA_VERSION=0.1.84 sh
# another directory
curl -fsSL https://github.com/univelop/aya-cli-dist/releases/latest/download/install.sh | sh -s -- --dir ~/bin
```

### Updating

```bash
aya upgrade            # the latest release
aya upgrade 0.1.84     # a specific version
```

`aya upgrade` replaces the executable in place. Re-running the installer does the same.

**Installed with `npm install -g` before?** The npm variant is discontinued.
Install the executable as above, then remove the old one with
`npm uninstall -g @univelop/aya-cli`.

## Getting started

```bash
aya --version
AYA_SERVER=https://api.hey-aya.ai aya login   # sign in in the browser
aya org list                                  # confirm access
aya workspace clone <slugOrId>                # a workspace into the current directory
```

To keep the server without the variable, pin it once:
`aya org use <org> --server https://api.hey-aya.ai`.

Run `aya --help` or `aya <command> --help` for the full command surface, and
`aya completion <bash|zsh|fish|powershell|nushell>` for shell completions.

### Headless use (CI, agents)

| Variable | Meaning |
| --- | --- |
| `AYA_API_KEY` | An API key (`aya_key_…`), used instead of `aya login`. |
| `AYA_SERVER` | The Aya API, e.g. `https://api.hey-aya.ai`. |
| `AYA_ORG` | The organization to work in (id or slug). |

`aya login --token -` reads a key from standard input instead of the command
line.

### Where the CLI keeps its login

| Platform | `credentials.json` |
| --- | --- |
| macOS | `~/.config/aya/` |
| Linux | `~/.config/aya/` |

`aya status` shows the path in use; `aya logout` removes the file.

## Release assets

| Asset | What it is |
| --- | --- |
| `install.sh` | The installer for macOS and Linux. |
| `aya-<platform>` | The executable alone, e.g. `aya-darwin-arm64`, `aya-linux-x64`. |
| `univelop-aya-cli-<platform>-<X.Y.Z>.tgz` | The macOS / Linux executable wrapped as an npm package, for environments that install packages by URL (npm refuses it on other platforms). |

Every asset without a version in its name is also reachable at
`https://github.com/univelop/aya-cli-dist/releases/latest/download/<asset>`.
Files with a version have an unversioned twin for that URL (e.g.
`univelop-aya-cli-linux-x64.tgz`).

Releases are published by a workflow in the source repository, never by hand.

## Issues

This repository does not track issues. Customers: please contact Univelop
support.

## License

UNLICENSED — © Univelop. All rights reserved.
