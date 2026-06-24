class Oauth2TestServer < Formula
  desc "A fast, fully configurable, in-memory OAuth 2.0 + OpenID Connect authorization server for testing, zero-HTTP mode and DCR support for testing auth flow in MCP Servers and MCP Clients"
  homepage "https://github.com/rust-mcp-stack/oauth2-test-server"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/oauth2-test-server/releases/download/v0.2.3/oauth2-test-server-aarch64-apple-darwin.tar.xz"
      sha256 "52401a347fdedbe71dce831ffafd32c61462e17c38af0ca1f439a6e51d64fc9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/oauth2-test-server/releases/download/v0.2.3/oauth2-test-server-x86_64-apple-darwin.tar.xz"
      sha256 "111ff7f57120fe8df4a02fe91fc444037acec3d725f6aca945a90f6aabb3687e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/oauth2-test-server/releases/download/v0.2.3/oauth2-test-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "209d6084885b1d5bdb2c792cb1573fe032d4ce17ffbe25902a81f17bcd4d15b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/oauth2-test-server/releases/download/v0.2.3/oauth2-test-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "779423c5b7192b445107a87628747bfbbc753a2e07742f80461d8883b3912292"
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
