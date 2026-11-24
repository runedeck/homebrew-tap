# runedeck/homebrew-tap

Homebrew formulae for the runedeck toolchain.

```sh
brew install runedeck/tap/rune
```

## What the formula installs

| Platform | Install |
| --- | --- |
| macOS on Apple Silicon | The prebuilt `rune` of the release |
| Linux on x86-64, WSL included | The prebuilt `rune` of the release |
| macOS on Intel, Linux on ARM | Built from the tagged source with Rust |

Homebrew does not run on Windows itself. A Windows user takes
`rune-cli-windows-x86_64.zip` from the
[release page](https://github.com/runedeck/cli/releases) and checks it
against `SHA256SUMS` there.

## Updating the formula

After a release of [runedeck/cli](https://github.com/runedeck/cli) is
published, write the formula from it:

```sh
scripts/update-formula v0.7.1
```

The script reads the digests of the two prebuilt archives from the
release's `SHA256SUMS`, takes the digest of the tagged source archive, and
rewrites `Formula/rune.rb`. It refuses a tag whose release is not published
or has no digest for an archive. Then check the result on a Mac or on Linux
before the pull request:

```sh
brew install --formula ./Formula/rune.rb
brew test rune
```
