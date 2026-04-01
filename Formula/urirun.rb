class Urirun < Formula
  desc "YAML設定に基づいてアプリやサービスをワンコマンドで起動するランチャー"
  homepage "https://github.com/uribow-lab/uribow-run-tool"
  url "https://github.com/uribow-lab/uribow-run-tool/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ade85acffa4380297ebd69d8df6a06e3d55b76a2648cb9b01f9ba0ed6ab1c22f"
  license "MIT"
  version "1.1.0"

  def install
    bin.install "bin/urirun"
  end

  test do
    assert_match "urirun", shell_output("#{bin}/urirun --version")
  end
end
