class McpDiscovery < Formula
  desc "A command-line tool written in Rust for discovering and documenting MCP Server capabilities."
  homepage "https://rust-mcp-stack.github.io/mcp-discovery"
  version "0.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.2.6/mcp-discovery-aarch64-apple-darwin.tar.xz"
      sha256 "55806959e48247455acc25e10a43c37706582aaa3ba0e1afb8a08cea49b2bfc5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.2.6/mcp-discovery-x86_64-apple-darwin.tar.xz"
      sha256 "a25af59f1b7d93642a48adff5be74014e40e895a462457a9c53289dd44d4dbe7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.2.6/mcp-discovery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6f1e9ff49d7c6a49453e0f90b9d34e822f00db9506e224fdda3ebbef34ccfb59"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.2.6/mcp-discovery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ebf55c4b14d4a5992bbe869925b12a9ec3f43c1fd8dd35c8d78f39fa373f1815"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "mcp-discovery"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "mcp-discovery"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "mcp-discovery"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "mcp-discovery"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
