class RustMcpFilesystem < Formula
  desc "Blazing-fast, asynchronous MCP server for seamless filesystem operations."
  homepage "https://github.com/rust-mcp-stack/rust-mcp-filesystem"
  version "0.3.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.7/rust-mcp-filesystem-aarch64-apple-darwin.tar.gz"
      sha256 "1d159c881ef98fea7e7653f01845041d64251dffe2a2cc35d195e168fc5f8f9e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.7/rust-mcp-filesystem-x86_64-apple-darwin.tar.gz"
      sha256 "d7fcd4ecbbce1c1e740b5d1a522601a8e71342823fbaf0121512c15f3c5591ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.7/rust-mcp-filesystem-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "18df6aac33b8caee4b0ac62f7c99564255037fb2f1074917602e7609db83d879"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.7/rust-mcp-filesystem-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23ce9eac18d0a95fac301974c01134e896dece012795a670d907183b8fcc19d9"
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
