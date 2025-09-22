class McpDiscovery < Formula
  desc "A command-line tool written in Rust for discovering and documenting MCP Server capabilities."
  homepage "https://rust-mcp-stack.github.io/mcp-discovery"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.2.0/mcp-discovery-aarch64-apple-darwin.tar.xz"
      sha256 "0eacff7c268c7bd12df97c1ea26f9d85ef31f9664099e137ff0c35ef25a7306f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.2.0/mcp-discovery-x86_64-apple-darwin.tar.xz"
      sha256 "78d151970e5d26a422e507b1c25ca5d91db03b2bfe27ca6a1923b1b2d1228057"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.2.0/mcp-discovery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "77905f0e2c79ada8a1257cfdac615815179c3c68b8ac70bf25bfc85804b11027"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/mcp-discovery/releases/download/v0.2.0/mcp-discovery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5c8f5af0b88b07819c5b8cca05eb984f34f53bfd076dda1a8d191360600dea2c"
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
