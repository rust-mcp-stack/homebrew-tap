class McpDiscovery < Formula
  desc "A command-line tool written in Rust for discovering and documenting MCP Server capabilities."
  homepage "https://rust-mcp-stack.github.io/mcp-discovery"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.2.5/mcp-discovery-aarch64-apple-darwin.tar.xz"
      sha256 "8ec8697e41b208f5a66061b615cf5c3ec4264cdf5d7d12e7ca040661891818a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.2.5/mcp-discovery-x86_64-apple-darwin.tar.xz"
      sha256 "bbf4146003c35043dbb8d8d732af65196672af217488931f433fa975f591a698"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.2.5/mcp-discovery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ebb5a243256b3a74f4df1509c8cd0ae67483c2062e32815b3fedd19f43cc9f03"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.2.5/mcp-discovery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ede19b0e8a6d960ddb3cf0abd7d33e791ad94aecfe65d94c33c6011bd5291ba9"
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
