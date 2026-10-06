class Urirun < Formula
  desc "YAML設定に基づいてアプリやサービスをワンコマンドで起動するランチャー"
  homepage "https://github.com/uribow-lab/uribow-run-tool"
  url "https://github.com/uribow-lab/uribow-run-tool/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "def35b10db22c903b142a13cb272907886aa079ddc87464104e55281a8eca369"
  license "MIT"
  version "1.4.1"

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
