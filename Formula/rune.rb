class Rune < Formula
  desc "Deck toolkit for AI harnesses: your runes, deployed"
  homepage "https://github.com/runedeck/cli"
  url "https://github.com/runedeck/cli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "0518ac2e12298571f2abe8c188ca79069f27ffa3b21f4eea6bf4463841cd2459"
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
