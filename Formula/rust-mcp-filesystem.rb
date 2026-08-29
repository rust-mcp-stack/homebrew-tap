class RustMcpFilesystem < Formula
  desc "Blazing-fast, asynchronous MCP server for seamless filesystem operations."
  homepage "https://github.com/rust-mcp-stack/rust-mcp-filesystem"
  version "0.4.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.4.5/rust-mcp-filesystem-aarch64-apple-darwin.tar.gz"
      sha256 "b68bb574f388441dd40def767772cf614f675da33e3582a1ab406f2581b4771d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.4.5/rust-mcp-filesystem-x86_64-apple-darwin.tar.gz"
      sha256 "866f2e90d190d025ce5863c77c3eff97d7c553fa877bc9d34d7808f61b02ccb8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.4.5/rust-mcp-filesystem-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "79f0022e86532b74a6ef02e3b5745d90bc50852dd6d1c47414e0a6a292f6a310"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.4.5/rust-mcp-filesystem-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4c6a7fd06f1e55bd2928610b0b6ecb6e8589ca816fb7ea17b6a2b2f36a30e00c"
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
