class McpDiscovery < Formula
  desc "MCP Discovery: a command-line tool written in Rust for discovering and documenting MCP Server capabilities."
  homepage "https://rust-mcp-stack.github.io/mcp-discovery"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.3.2/mcp-discovery-aarch64-apple-darwin.tar.xz"
      sha256 "fc82b9622440b859b450e250d8b9b79c2819f7e3a84dbd1b69a825c7eb0d33a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.3.2/mcp-discovery-x86_64-apple-darwin.tar.xz"
      sha256 "6de206384abf84cee096f80c3b423b0b63fd51918b2ee323794c6135f423050d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.3.2/mcp-discovery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "072719ad13562aa52a9d07b5091d408225c05cfdcde484a59f76e1fa18efe6bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.3.2/mcp-discovery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f023e427b09e8f0d5f1879d8ecd05ba6646a5631948454be048c8ab654271ad7"
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
