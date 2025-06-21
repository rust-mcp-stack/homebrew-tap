class McpDiscovery < Formula
  desc "A command-line tool written in Rust for discovering and documenting MCP Server capabilities."
  homepage "https://rust-mcp-stack.github.io/mcp-discovery"
  version "0.1.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.1.12/mcp-discovery-aarch64-apple-darwin.tar.xz"
      sha256 "f4838507ccae855816080fe90c3196b251c91a2985ecda9a3d4a94f109faf5c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.1.12/mcp-discovery-x86_64-apple-darwin.tar.xz"
      sha256 "04f2b4bcd466f52ea657e518321e23becc964edb24f363253e2b544be1b18d0f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.1.12/mcp-discovery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f9935cee52488d4a851dbfc28dbe35cf5feda897b946602a347e58f1db53cd1f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.1.12/mcp-discovery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "02581b330cad22a59dffd1cfe08f3e79098269eb7fa4cf2c6bd8ae5d6215b2c8"
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
