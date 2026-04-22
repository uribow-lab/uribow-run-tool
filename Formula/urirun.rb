class Urirun < Formula
  desc "YAML設定に基づいてアプリやサービスをワンコマンドで起動するランチャー"
  homepage "https://github.com/uribow-lab/uribow-run-tool"
  url "https://github.com/uribow-lab/uribow-run-tool/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "65b29c7c27363bb290950458fb4838e8d7076f2d462a58c2ab90371ffaf11a68"
  license "MIT"
  version "1.3.1"

  def install
    bin.install "bin/urirun"
  end

  def caveats
    <<~EOS
      command タイプ（cd等）を呼び出し元シェルに反映するには、
      ~/.bashrc または ~/.zshrc に以下を追加してください:

        eval "$(urirun --shell-init)"
    EOS
  end

  test do
    assert_match "urirun", shell_output("#{bin}/urirun --version")
  end
end
