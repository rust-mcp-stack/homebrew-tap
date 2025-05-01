class McpDiscovery < Formula
  desc "A command-line tool written in Rust for discovering and documenting MCP Server capabilities."
  homepage "https://rust-mcp-stack.github.io/mcp-discovery"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.1.8/mcp-discovery-aarch64-apple-darwin.tar.xz"
      sha256 "e7228d9a2c569d4c10a161f62376916a23641532aef83fd840c45d09623b1575"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.1.8/mcp-discovery-x86_64-apple-darwin.tar.xz"
      sha256 "99ae7b3c5cdc26f562f31a8ef257a1dbdffaa0396ae7e4bc9c53a9f8e56a0f20"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.1.8/mcp-discovery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "31b8d452869a4d8397d587a2a1bba3c398763ef6022321b7800bdf0377476ca2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.1.8/mcp-discovery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4a5bf73a6b07af1d2cddf539a7bb29ef78e388e10aeb2bedc0b0c449382079b2"
    end
  end
  license "MIT"

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
    bin.install "mcp-discovery" if OS.mac? && Hardware::CPU.arm?
    bin.install "mcp-discovery" if OS.mac? && Hardware::CPU.intel?
    bin.install "mcp-discovery" if OS.linux? && Hardware::CPU.arm?
    bin.install "mcp-discovery" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
