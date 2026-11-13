#!/bin/sh
# Install the Aya CLI as one self-contained executable — no Node, no npm.
#
#   curl -fsSL https://github.com/univelop/aya-cli-dist/releases/latest/download/install.sh | sh
#
#   AYA_VERSION=0.1.80 … | sh          # pin a release (or: sh install.sh --version 0.1.80)
#   AYA_INSTALL_DIR=~/bin … | sh       # where `aya` goes (or: --dir ~/bin)
#   … | sh -s -- --force               # replace a file at that path that is not an aya binary
#   AYA_DIST_URL=http://host:8000 …    # a directory serving the assets of a build that is not
#                                      # released yet (its layout: <url>/releases/...)
#
# Picks the release asset for this machine (`aya-<platform>-<arch>`), puts it
# at <dir>/aya and checks that it runs. <dir> is /usr/local/bin when that is
# writable, else ~/.local/bin. In Git Bash (or MSYS2 / Cygwin) on Windows it
# runs the Windows setup headless instead: %LOCALAPPDATA%\Programs\Aya, or <dir>.
# Re-running installs the latest release over the old one; `aya upgrade` does
# the same from then on.
#
# Shipped as a release asset by `release-cli.yml`; the source of truth is
# apps/cli/scripts/install.sh in univelop/aya. POSIX sh on purpose: a fresh
# macOS or a minimal container has no bash guarantee, and no `local`.
set -eu

REPO_URL="${AYA_DIST_URL:-https://github.com/univelop/aya-cli-dist}"

VERSION="${AYA_VERSION:-}"
DIR="${AYA_INSTALL_DIR:-}"
FORCE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --version) VERSION="${2:-}"; shift ;;
    --version=*) VERSION="${1#--version=}" ;;
    --dir) DIR="${2:-}"; shift ;;
    --dir=*) DIR="${1#--dir=}" ;;
    --force) FORCE=1 ;;
    -h|--help) sed -n '2,17p' "$0" 2>/dev/null | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "install.sh: unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

fail() { echo "install.sh: $*" >&2; exit 1; }

# download <url> <file>
download() {
  echo "Downloading $1" >&2
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL --retry 3 -o "$2" "$1" || fail "download failed — is $1 a release asset?"
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$2" "$1" || fail "download failed — is $1 a release asset?"
  else
    fail "neither curl nor wget is installed"
  fi
}

# release_url <asset>: the asset of the pinned release, or of the latest one.
release_url() {
  if [ -n "$VERSION" ]; then
    echo "$REPO_URL/releases/download/v$VERSION/$1"
  else
    echo "$REPO_URL/releases/latest/download/$1"
  fi
}

if [ -n "$VERSION" ]; then
  case "$VERSION" in
    [0-9]*.[0-9]*.[0-9]*) ;;
    *) fail "'$VERSION' is not a release version (expected X.Y.Z)" ;;
  esac
fi

# --- Windows: Git Bash (what Claude Code runs commands in there), MSYS2, Cygwin
# The setup, not a bare copy: it puts aya on the user PATH, registers an
# uninstaller and moves a running aya.exe aside, all without admin rights.
install_windows() {
  WORK="$(mktemp -d)"
  trap 'rm -rf "$WORK"' EXIT INT TERM
  SETUP="$WORK/aya-setup-win32-x64.exe"
  download "$(release_url aya-setup-win32-x64.exe)" "$SETUP"
  chmod 755 "$SETUP"
  set -- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART
  if [ -n "$DIR" ]; then
    set -- "$@" "/DIR=$(cygpath -aw "$DIR")"
  fi
  echo "Running the Aya setup" >&2
  # MSYS2_ARG_CONV_EXCL: Git Bash would otherwise take /VERYSILENT for a path
  # and hand the setup C:/Program Files/Git/VERYSILENT.
  CODE=0
  MSYS2_ARG_CONV_EXCL='*' "$SETUP" "$@" || CODE=$?
  [ "$CODE" -eq 0 ] || fail "the setup exited with $CODE"

  if [ -n "$DIR" ]; then
    APP_DIR="$(cygpath -au "$DIR")"
  else
    [ -n "${LOCALAPPDATA:-}" ] || fail "LOCALAPPDATA is not set, so the installed aya.exe cannot be found"
    APP_DIR="$(cygpath -u "$LOCALAPPDATA")/Programs/Aya"
  fi
  EXE="$APP_DIR/aya.exe"
  GOT="$("$EXE" --version 2>/dev/null | tr -d '\r' || true)"
  [ -n "$GOT" ] || fail "the setup finished, but $EXE does not run"
  if [ -n "$VERSION" ] && [ "$GOT" != "$VERSION" ]; then
    fail "the installed aya reports $GOT, not $VERSION"
  fi
  echo "aya $GOT installed to $EXE" >&2
  echo "It is on your user PATH for every terminal opened from now on. Restart this one (or the agent running it), or for this shell:" >&2
  echo "  export PATH=\"$APP_DIR:\$PATH\"" >&2
}

# --- which asset ------------------------------------------------------------
OS="$(uname -s)"
ARCH="$(uname -m)"
case "$OS" in
  MINGW* | MSYS* | CYGWIN*) install_windows; exit 0 ;;
esac
case "$OS/$ARCH" in
  Darwin/arm64) TARGET="darwin-arm64" ;;
  Darwin/x86_64)
    # A shell under Rosetta 2 says x86_64 on an Apple Silicon Mac; the native
    # executable is the one to install there.
    if [ "$(sysctl -n sysctl.proc_translated 2>/dev/null || true)" = 1 ]; then
      TARGET="darwin-arm64"
    else
      TARGET="darwin-x64"
    fi ;;
  Linux/x86_64 | Linux/amd64) TARGET="linux-x64" ;;
  Linux/aarch64 | Linux/arm64) TARGET="linux-arm64" ;;
  *)
    fail "no prebuilt aya for $OS/$ARCH. Releases carry one for macOS (Apple Silicon and Intel),
Linux (x86_64 and arm64) and Windows (x64, through its setup: $REPO_URL/releases/latest/download/aya-setup-win32-x64.exe)." ;;
esac

URL="$(release_url "aya-$TARGET")"

# --- where -------------------------------------------------------------------
if [ -z "$DIR" ]; then
  if [ -d /usr/local/bin ] && [ -w /usr/local/bin ]; then
    DIR=/usr/local/bin
  else
    DIR="$HOME/.local/bin"
  fi
fi
mkdir -p "$DIR" 2>/dev/null || fail "cannot create $DIR"
[ -w "$DIR" ] || fail "$DIR is not writable. Pick another directory with --dir (or AYA_INSTALL_DIR), or run with sudo."

DEST="$DIR/aya"
# A text file at the destination is somebody else's `aya` — most likely the
# launcher the Aya Claude plugin writes to ~/.local/bin/aya, which the plugin
# updates itself. Replacing it silently would break that plugin.
if [ -e "$DEST" ] && [ "$FORCE" -eq 0 ]; then
  if [ "$(head -c 2 "$DEST" 2>/dev/null || true)" = "#!" ]; then
    fail "$DEST is a script, not an aya executable (the Aya Claude plugin's launcher?). Keep it and install elsewhere with --dir, or replace it with --force."
  fi
fi

# --- download ----------------------------------------------------------------
TMP="$DIR/.aya.download.$$"
trap 'rm -f "$TMP"' EXIT INT TERM
download "$URL" "$TMP"
chmod 755 "$TMP"

# --- check it runs, then move it into place ----------------------------------
GOT="$("$TMP" --version 2>/dev/null || true)"
[ -n "$GOT" ] || fail "the downloaded executable does not run on this machine ($TARGET)"
if [ -n "$VERSION" ] && [ "$GOT" != "$VERSION" ]; then
  fail "the downloaded executable reports $GOT, not $VERSION"
fi
mv -f "$TMP" "$DEST"
trap - EXIT INT TERM

echo "aya $GOT installed to $DEST" >&2
case ":$PATH:" in
  *":$DIR:"*) ;;
  *) echo "Note: $DIR is not on your PATH. Add it, e.g.  export PATH=\"$DIR:\$PATH\"" >&2 ;;
esac
