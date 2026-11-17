class Rune < Formula
  desc "Deck toolkit for AI harnesses: your runes, deployed"
  homepage "https://github.com/runedeck/cli"
  url "https://github.com/runedeck/cli/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "33a8e2910c849184178c67cafdf014af56931ee92ec557a9bd3ee27b978d0bbc"
  license "EUPL-1.2"
  head "https://github.com/runedeck/cli.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rune", "completion", "print")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rune --version")
    system bin/"rune", "completion", "print", "zsh"
  end
end
