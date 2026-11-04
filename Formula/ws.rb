class Ws < Formula
  desc "Command-line client for Windshift work management and test tracking"
  homepage "https://windshift.sh"
  version "0.9.3"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/Windshiftapp/core/releases/download/v#{version}/ws-v#{version}-darwin-amd64.tar.gz"
      sha256 "931c8f98a92e25f9dc790d7714d7a5da4b1268eb0c73c8464f9e4c8a25e4ab9f"
    end

    if Hardware::CPU.arm?
      url "https://github.com/Windshiftapp/core/releases/download/v#{version}/ws-v#{version}-darwin-arm64.tar.gz"
      sha256 "a33f5b8888d757736acba0b35cc20d6b90325f38b16332d5ba5ef156e0e0d5a9"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/Windshiftapp/core/releases/download/v#{version}/ws-v#{version}-linux-amd64.tar.gz"
      sha256 "3f686a7ad7d0b24d5ca1a66b17655134ad7e62359cf3abee49b24b7c522b31b6"
    end

    if Hardware::CPU.arm?
      url "https://github.com/Windshiftapp/core/releases/download/v#{version}/ws-v#{version}-linux-arm64.tar.gz"
      sha256 "5a4cfa38e834ed03ecabf8e22a5f045f3d9b1fa8977c1d56855187a40bc2da11"
    end
  end

  def install
    bin.install "ws"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ws version")
  end
end
