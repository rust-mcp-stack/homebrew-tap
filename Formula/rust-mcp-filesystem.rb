class RustMcpFilesystem < Formula
  desc "Blazing-fast, asynchronous MCP server for seamless filesystem operations."
  homepage "https://github.com/rust-mcp-stack/rust-mcp-filesystem"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.2/rust-mcp-filesystem-aarch64-apple-darwin.tar.gz"
      sha256 "fb5096da065cb1973c0b61e6687311e5e77273b12bee9f9f6b5d5672342108f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.2/rust-mcp-filesystem-x86_64-apple-darwin.tar.gz"
      sha256 "48882b36f1ed4e799402db92a3d06922a8df87ede4136ea84aae279a1aa36863"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.2/rust-mcp-filesystem-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f1e31ee53306b28b478964cbb5201751400d4841d46611c608770a0b80b428b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.2/rust-mcp-filesystem-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e05a5e853d7fff474209f7d697429f2b503fcaeacc17b4e7aa03007d3bd33a18"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "rust-mcp-filesystem" if OS.mac? && Hardware::CPU.arm?
    bin.install "rust-mcp-filesystem" if OS.mac? && Hardware::CPU.intel?
    bin.install "rust-mcp-filesystem" if OS.linux? && Hardware::CPU.arm?
    bin.install "rust-mcp-filesystem" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
