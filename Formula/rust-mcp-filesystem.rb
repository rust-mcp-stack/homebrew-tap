class RustMcpFilesystem < Formula
  desc "Blazing-fast, asynchronous MCP server for seamless filesystem operations."
  homepage "https://github.com/rust-mcp-stack/rust-mcp-filesystem"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.4/rust-mcp-filesystem-aarch64-apple-darwin.tar.gz"
      sha256 "f2d2a4a35df55500d3302b58f62a64534ee5fbd40a9b8cfdb431805a19c1daeb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.4/rust-mcp-filesystem-x86_64-apple-darwin.tar.gz"
      sha256 "aeb120f76e9ccca0ec3edd4cffe3469974a5a4fb1f16287766feac4baf24f0db"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.4/rust-mcp-filesystem-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7f631bc535d7f6df8305370212eed0640d1e2391e5c99bc7501e75da977d3882"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.4/rust-mcp-filesystem-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3c30a68df37270dfcc7b835adc33ef95ab5ab70ad11a5b90eb882cd46e6c547b"
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
