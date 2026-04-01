class Urirun < Formula
  desc "YAML設定に基づいてアプリやサービスをワンコマンドで起動するランチャー"
  homepage "https://github.com/uribow-lab/urirun"
  url "https://github.com/uribow-lab/urirun/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "8e436a3fb3bdce071c2db64b39dfde99c846e4b4f642ff7adfe44294933d9183"
  license "MIT"
  version "1.0.0"

  def install
    bin.install "bin/urirun"
  end

  test do
    assert_match "urirun", shell_output("#{bin}/urirun --version")
  end
end
