class Oauth2TestServer < Formula
  desc "A fast, fully configurable, in-memory OAuth 2.0 + OpenID Connect authorization server for testing, zero-HTTP mode and DCR support for testing auth flow in MCP Servers and MCP Clients"
  homepage "https://github.com/rust-mcp-stack/oauth2-test-server"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/oauth2-test-server/releases/download/v0.2.1/oauth2-test-server-aarch64-apple-darwin.tar.xz"
      sha256 "2d8c54d12e5fafec5fd8af091869345b2b7c64fd7c478e636f214b6d6a501591"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/oauth2-test-server/releases/download/v0.2.1/oauth2-test-server-x86_64-apple-darwin.tar.xz"
      sha256 "2f8c51c3bce59c392959f783983efae1db2fb3415d7682efc3a208d117e8d260"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/oauth2-test-server/releases/download/v0.2.1/oauth2-test-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aa35133a051a036cfaa27034487160e81ef189fa75f0f9019ac8135f94eae7b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/oauth2-test-server/releases/download/v0.2.1/oauth2-test-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "786c5ab37fa1246f892508dfde88a2b5aa0aa438a53ceba8de2d7cc1c5ea14b2"
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
    bin.install "oauth2-test-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "oauth2-test-server" if OS.mac? && Hardware::CPU.intel?
    bin.install "oauth2-test-server" if OS.linux? && Hardware::CPU.arm?
    bin.install "oauth2-test-server" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
