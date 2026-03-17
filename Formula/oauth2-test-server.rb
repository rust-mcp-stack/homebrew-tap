class Oauth2TestServer < Formula
  desc "A fast, fully configurable, in-memory OAuth 2.0 + OpenID Connect authorization server for testing, zero-HTTP mode and DCR support for testing auth flow in MCP Servers and MCP Clients"
  homepage "https://github.com/rust-mcp-stack/oauth2-test-server"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/oauth2-test-server/releases/download/v0.2.2/oauth2-test-server-aarch64-apple-darwin.tar.xz"
      sha256 "414d25dd0dc95e7a593fc3c9a17f52fb7b3e508a15537798618b6ccea459db47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/oauth2-test-server/releases/download/v0.2.2/oauth2-test-server-x86_64-apple-darwin.tar.xz"
      sha256 "bffcee0986b84fb311c3b9778d08ed827b5953b5a0bc7e0d4ac28a8b3a1c0c8e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rust-mcp-stack/oauth2-test-server/releases/download/v0.2.2/oauth2-test-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7faa1a625a7d6d3bd3fa79f4768f97393675b22bca6f600d647104f7278fe8f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rust-mcp-stack/oauth2-test-server/releases/download/v0.2.2/oauth2-test-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "64deccb6738c548bf17078996b61747356ba5fdfd6a3424969272142a2ee31dd"
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
