class Rune < Formula
  desc "Deck toolkit for AI harnesses: your runes, deployed"
  homepage "https://github.com/runedeck/cli"
  version "0.7.1"
  license "EUPL-1.2"

  head do
    url "https://github.com/runedeck/cli.git", branch: "main"
    depends_on "rust" => :build
  end

  # scripts/update-formula writes this file from a published release.
  # A release carries a prebuilt rune for Apple Silicon macOS and for
  # x86-64 Linux. Every other platform builds the tagged source.
  on_macos do
    on_arm do
      url "https://github.com/runedeck/cli/releases/download/v0.7.1/rune-cli-macos-aarch64.tar.gz"
      sha256 "e080abc64e50f38ce5a2fbad11cab141b617de3946a52748f50eabaa8140bf7b"
    end
    on_intel do
      url "https://github.com/runedeck/cli/archive/refs/tags/v0.7.1.tar.gz"
      sha256 "faed372929149669056119653320e54665aaa41e98116ba6f238a018d0103ff0"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/runedeck/cli/releases/download/v0.7.1/rune-cli-linux-x86_64.tar.gz"
      sha256 "f38567a597151ea943e72caaeaaf7054607c83caff8587455a96963f86fa970d"
    end
    on_arm do
      url "https://github.com/runedeck/cli/archive/refs/tags/v0.7.1.tar.gz"
      sha256 "faed372929149669056119653320e54665aaa41e98116ba6f238a018d0103ff0"
      depends_on "rust" => :build
    end
  end

  def install
    # The source archive and a HEAD checkout carry a manifest to build.
    # A release archive holds the binary alone.
    if File.exist?("Cargo.toml")
      system "cargo", "install", *std_cargo_args
    else
      bin.install "rune"
    end
    generate_completions_from_executable(bin/"rune", "completion", "print")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rune --version")
    system bin/"rune", "completion", "print", "zsh"
  end
end
