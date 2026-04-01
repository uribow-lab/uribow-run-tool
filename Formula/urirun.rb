class Urirun < Formula
  desc "YAML設定に基づいてアプリやサービスをワンコマンドで起動するランチャー"
  homepage "https://github.com/uribow-lab/uribow-run-tool"
  url "https://github.com/uribow-lab/uribow-run-tool/archive/refs/tags/v1.0.0.tar.gz"
  sha256 ""
  license "MIT"
  version "1.0.0"

  def install
    bin.install "bin/urirun"
  end

  test do
    assert_match "urirun", shell_output("#{bin}/urirun --version")
  end
end
