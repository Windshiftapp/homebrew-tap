class Ws < Formula
  desc "Command-line client for Windshift work management and test tracking"
  homepage "https://windshift.sh"
  version "0.9.4"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/Windshiftapp/core/releases/download/v#{version}/ws-v#{version}-darwin-amd64.tar.gz"
      sha256 "9360ee5feddf137f4e6ae077945c2292bd45ebff84ad109a0b4a87e207a4a470"
    end

    if Hardware::CPU.arm?
      url "https://github.com/Windshiftapp/core/releases/download/v#{version}/ws-v#{version}-darwin-arm64.tar.gz"
      sha256 "8ecd7fa4bbfc07fb5976d2f11dfcc7a59be933d1e25fe9b4a01fdb5e4e0fce46"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/Windshiftapp/core/releases/download/v#{version}/ws-v#{version}-linux-amd64.tar.gz"
      sha256 "423007362d49c8e24a2181d70f3dca4c30752058366a368c19c35fb3ad43b8a8"
    end

    if Hardware::CPU.arm?
      url "https://github.com/Windshiftapp/core/releases/download/v#{version}/ws-v#{version}-linux-arm64.tar.gz"
      sha256 "b96355cd56cf1320ea47bc0e1218a5850bee3d99de904ee989599967ad4f23e7"
    end
  end

  def install
    bin.install "ws"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ws version")
  end
end
