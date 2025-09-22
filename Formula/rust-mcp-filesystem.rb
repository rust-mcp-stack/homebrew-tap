class RustMcpFilesystem < Formula
  desc "Blazing-fast, asynchronous MCP server for seamless filesystem operations."
  homepage "https://github.com/rust-mcp-stack/rust-mcp-filesystem"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.3/rust-mcp-filesystem-aarch64-apple-darwin.tar.gz"
      sha256 "7878b6d62a3ca0b83f77752540963e7a51221f44c7a93b52ffdb5675822ca798"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.3/rust-mcp-filesystem-x86_64-apple-darwin.tar.gz"
      sha256 "eabb7094ab9869a76825b32f97c2cb57da5f20f77eb0926b0a44af1a272a401f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.3/rust-mcp-filesystem-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "30dfe8bf991c2d97055e56c3a8d171af2a8e0445991a5a036e31e325d117c7a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/rust-mcp-filesystem/releases/download/v0.3.3/rust-mcp-filesystem-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9618f78b602c7ef192640d17fda8a44cd2380f0210200b6be0c377541fcfa2da"
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
