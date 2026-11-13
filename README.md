# Aya CLI — Downloads

Public download location for **`aya`**, the command-line interface for the Aya
workspace and record management platform.

This repository contains **no source code**. It only hosts the release
downloads, so that anyone can install the CLI without a GitHub token or npm
registry credentials. Every release is built from the private monorepo
`univelop/aya`; its notes name the commit it was built from.

## Install

### macOS (Apple Silicon and Intel) and Linux (x86-64, arm64)

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

### Windows (x64)

Download and run
[`aya-setup-win32-x64.exe`](https://github.com/univelop/aya-cli-dist/releases/latest/download/aya-setup-win32-x64.exe).
It installs for the current user (no administrator rights), puts `aya` on your
`PATH` and can be removed again under _Settings → Apps_.

Headless — from a script, CI or an AI agent:

```bat
:: cmd.exe or Git Bash
curl -fsSLo aya-setup.exe https://github.com/univelop/aya-cli-dist/releases/latest/download/aya-setup-win32-x64.exe
aya-setup.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART
```

```powershell
# PowerShell — Start-Process -Wait, because PowerShell does not wait for a setup on its own
Invoke-WebRequest https://github.com/univelop/aya-cli-dist/releases/latest/download/aya-setup-win32-x64.exe -OutFile aya-setup.exe
Start-Process -Wait .\aya-setup.exe -ArgumentList '/VERYSILENT','/SUPPRESSMSGBOXES','/NORESTART'
```

In Git Bash (what Claude Code uses on Windows) the `install.sh` line above runs
this setup for you. `aya.exe` lands in `%LOCALAPPDATA%\Programs\Aya`. Terminals
and agents that were already open see the new `PATH` only after a restart —
until then, call `%LOCALAPPDATA%\Programs\Aya\aya.exe` directly.

Setup options: `/DIR="C:\tools\aya"` installs elsewhere,
`/MERGETASKS="!modifypath"` leaves `PATH` alone, `/LOG="setup.log"` writes a
log. Uninstall headless with
`"%LOCALAPPDATA%\Programs\Aya\unins000.exe" /VERYSILENT`.

### Updating

```bash
aya upgrade            # the latest release
aya upgrade 0.1.84     # a specific version
```

`aya upgrade` replaces the executable in place. Re-running the installer or the
Windows setup does the same.

**Installed with `npm install -g` before?** The npm variant is discontinued.
Install the executable as above, then remove the old one with
`npm uninstall -g @univelop/aya-cli`.

## Getting started

```bash
aya --version
aya login                        # sign in in the browser
aya org list                     # confirm access
aya workspace clone <slugOrId>   # a workspace into the current directory
```

The CLI talks to `https://api.hey-aya.ai` unless `AYA_SERVER` (or a working
copy's `aya.json`) names another server.

Run `aya --help` or `aya <command> --help` for the full command surface, and
`aya completion <bash|zsh|fish|powershell|nushell>` for shell completions.

### Headless use (CI, agents)

| Variable         | Meaning                                                                                        |
| ---------------- | ---------------------------------------------------------------------------------------------- |
| `AYA_API_KEY`    | An API key (`aya_key_…`), used instead of `aya login`.                                         |
| `AYA_SERVER`     | Another Aya API than `https://api.hey-aya.ai`.                                                 |
| `AYA_ORG`        | The organization to work in (id or slug).                                                      |
| `AYA_CONFIG_DIR` | Where the CLI keeps `credentials.json` — for sandboxes that cannot write the default location. |

`aya login --token -` reads a key from standard input instead of the command
line.

### Where the CLI keeps its login

| Platform | `credentials.json`                                    |
| -------- | ----------------------------------------------------- |
| macOS    | `~/.config/aya/`                                      |
| Linux    | `$XDG_CONFIG_HOME/aya/` (`~/.config/aya/` by default) |
| Windows  | `%APPDATA%\aya\Config\`                               |

`aya status` shows the path in use; `aya logout` removes the file.

## Release assets

| Asset                                     | What it is                                                                                                                                 |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| `install.sh`                              | The installer for macOS, Linux and Git Bash on Windows.                                                                                    |
| `aya-setup-win32-x64.exe`                 | The Windows installer (wizard, or headless with `/VERYSILENT`).                                                                            |
| `aya-<platform>`                          | The executable alone, e.g. `aya-darwin-arm64`, `aya-linux-x64`, `aya-win32-x64.exe`.                                                       |
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
