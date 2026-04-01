class Urirun < Formula
  desc "YAML設定に基づいてアプリやサービスをワンコマンドで起動するランチャー"
  homepage "https://github.com/uribow-lab/uribow-run-tool"
  url "https://github.com/uribow-lab/uribow-run-tool/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "36faf9b78f8298cb32ba619bb733865f106e510ca23b02b7713611a29e31d914"
  license "MIT"
  version "1.0.0"

  def install
    bin.install "bin/urirun"
  end

  test do
    assert_match "urirun", shell_output("#{bin}/urirun --version")
  end
end
