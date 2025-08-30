class RustMcpFilesystem < Formula
  desc "Blazing-fast, asynchronous MCP server for seamless filesystem operations."
  homepage "https://github.com/rust-mcp-stack/rust-mcp-filesystem"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.2.3/rust-mcp-filesystem-aarch64-apple-darwin.tar.gz"
      sha256 "d86c0e670ff5a20e3d4806bbaf2e6148264624560e1fc6432931896b64406c3b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.2.3/rust-mcp-filesystem-x86_64-apple-darwin.tar.gz"
      sha256 "c579b276dd88b70ed05f0b159e5aaa8f1016194d02d0f453f447463e75192eb6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.2.3/rust-mcp-filesystem-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "db5604a7cc82a0ed643ce2f8e23d6bc4d29ce139814666e8a11c57a05e7ef207"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.2.3/rust-mcp-filesystem-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6e589bfd8c4fb62a3d99286cee25819dfcafd40b12e1ad7e402688ab9732faeb"
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
