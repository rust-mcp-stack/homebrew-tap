class McpDiscovery < Formula
  desc "A command-line tool written in Rust for discovering and documenting MCP Server capabilities."
  homepage "https://github.com/rust-mcp-stack/mcp-discovery"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.1.4/mcp-discovery-aarch64-apple-darwin.tar.xz"
      sha256 "9ea39558f79cd435505dbcceefee8448f86179d883a0afb0e52c5221f62db926"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.1.4/mcp-discovery-x86_64-apple-darwin.tar.xz"
      sha256 "960a288009403e76007514a6f3b7a40514c4c1165c31c91441522d23fbb90170"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.1.4/mcp-discovery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7253b3902f35fbd8b9e9f0f9526efea0a04b3b1b77bdd07004ae002ffd068646"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.1.4/mcp-discovery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8f2c13a8670fa61448fe75942296a39f2b3730a3a5b1bad5e1a9924ec3d04416"
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
