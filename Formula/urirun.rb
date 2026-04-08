class Urirun < Formula
  desc "YAML設定に基づいてアプリやサービスをワンコマンドで起動するランチャー"
  homepage "https://github.com/uribow-lab/uribow-run-tool"
  url "https://github.com/uribow-lab/uribow-run-tool/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "67920a9646d802c1d489300128a1b97d1f1258e661c450868477f9f09c17fb28"
  license "MIT"
  version "1.2.0"

  def install
    bin.install "bin/urirun"
  end

  test do
    assert_match "urirun", shell_output("#{bin}/urirun --version")
  end
end
