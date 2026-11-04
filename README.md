# Homebrew Tap for Windshift

Homebrew formulae for [Windshift](https://windshift.sh) tooling.

## Install

```sh
brew install windshiftapp/tap/ws
```

Or tap first, then install:

```sh
brew tap windshiftapp/tap
brew install ws
```

## Upgrade

```sh
brew upgrade ws
```

## Formulae

| Formula | Description |
|---|---|
| `ws` | Command-line client for Windshift work management and test tracking |

## What is `ws`?

`ws` is the Windshift command-line client. It talks to a Windshift server for
task, test, page and time management, and is used for developer and coding-agent
workflows.

It needs a Windshift server URL and an API token. Configure with flags, environment
variables (`WS_URL`, `WS_TOKEN`, `WS_WORKSPACE`), a project `ws.toml`, or
`~/.config/ws/config.toml`.

```sh
ws --help
ws version
```

## Scope

This tap ships prebuilt release binaries from
[Windshiftapp/core](https://github.com/Windshiftapp/core/releases), matching the
published `SHA256SUMS.txt`. It is not part of homebrew-core.

The Windshift server and the desktop app are not distributed here. Use the
official Docker image or the releases page for those.

## Maintenance

Formulae are bumped as part of the Windshift release process. Each release updates
the version and the four platform checksums (macOS arm64/amd64, Linux arm64/amd64).

### Bumping a formula

```sh
scripts/bump.sh v0.9.4                 # fetches SHA256SUMS.txt from the release
scripts/bump.sh v0.9.4 path/to/SHA256SUMS.txt
scripts/bump.sh v0.9.4 --dry-run       # print, do not write
```

The script takes the checksums verbatim from the release's `SHA256SUMS.txt`, so the
formula always matches the signed release manifest. It fails if any of the four
`ws` artifacts is missing.

After bumping:

```sh
git add Formula/ws.rb && git commit -m "ws v0.9.4" && git push
```

### Tap trust

Homebrew 7 requires trust for third-party taps. If install is refused, run:

```sh
brew trust windshiftapp/tap
```

## License

The packaging in this repository, meaning the formula and the bump script, is
Apache-2.0. See [LICENSE](LICENSE).

That is separate from the licence of the software it packages. Windshift and the
`ws` CLI are AGPL-3.0, which is what the formula's `license` field records.
