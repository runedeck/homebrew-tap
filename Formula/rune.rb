class Rune < Formula
  desc "Deck toolkit for AI harnesses: your runes, deployed"
  homepage "https://github.com/runedeck/rune"
  url "https://github.com/runedeck/rune/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "d4e50489597afb4d4717b6b180a4ebc2fbcfe297036b3abdcc9a95a97fa494cf"
  license "EUPL-1.2"
  head "https://github.com/runedeck/rune.git", branch: "main"

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
