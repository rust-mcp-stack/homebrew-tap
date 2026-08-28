class RustMcpFilesystem < Formula
  desc "Blazing-fast, asynchronous MCP server for seamless filesystem operations."
  homepage "https://github.com/rust-mcp-stack/rust-mcp-filesystem"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.4.4/rust-mcp-filesystem-aarch64-apple-darwin.tar.gz"
      sha256 "7af570caec994c847287accb794994f2638956cc2ee6502ad461daeafdcefcb5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.4.4/rust-mcp-filesystem-x86_64-apple-darwin.tar.gz"
      sha256 "34918d63d1cc1597cb992eafed6bc1b8880b228baea2f251df422b9bddb4f244"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.4.4/rust-mcp-filesystem-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ee2dc35e863ae8f15dd3dc1e16640edb217fac1090c493c626f6c7494e5ce611"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.4.4/rust-mcp-filesystem-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "12b9d045d53c13d2932871f369320153ff2210129f4176a558d0b8ba82850e85"
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
      bin.install "rust-mcp-filesystem"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rust-mcp-filesystem"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rust-mcp-filesystem"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rust-mcp-filesystem"
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
