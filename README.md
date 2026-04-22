# uribow-run-tool

YAML設定ファイルに基づいてアプリやサービスをワンコマンドで起動するランチャー。

## インストール

```bash
brew tap uribow-lab/tap
brew install urirun
```

## シェル関数の有効化

`command` タイプで呼び出し元のシェルに影響を与える（`cd` など）には、以下を `~/.bashrc` または `~/.zshrc` に追加する。

```bash
eval "$(urirun --shell-init)"
```

これにより `urirun` がシェル関数として定義され、`command` タイプの出力が現在のシェルで実行される。

## 使い方

```bash
# 引数なしで対話選択（setting.yaml のキー + settings/ のプレフィックスから選択）
urirun

# プレフィックス単体で対話選択（settings/<prefix>-setting.yaml のキーから選択）
urirun <prefix>

# setting.yaml のキーを実行
urirun <key>

# settings/<prefix>-setting.yaml のキーを実行
urirun <prefix>-<key>

# 利用可能なキー一覧
urirun --list

# 設定ファイルを編集
urirun --edit            # setting.yaml を編集
urirun --edit <prefix>   # settings/<prefix>-setting.yaml を編集

# バージョン表示
urirun --version
```

### 対話選択モード

引数なしまたはプレフィックスのみで実行すると、カーソルキーで選択できるメニューが表示される。

- `↑` / `↓` または `k` / `j` で項目を移動
- `Enter` で決定
- `←` または `h` で親メニューに戻る（プレフィックス配下 → トップレベル）
- `q` または `ESC` でキャンセル

引数なしで実行した場合、`setting.yaml` の直接キーと `settings/` 配下のプレフィックスが一覧される。プレフィックスを選択すると、その配下のキー一覧に進む。親メニューに戻りたいときは `←` / `h` を押す。

パイプやリダイレクト（非対話実行）の場合は従来どおり `usage` と一覧が表示される。

## 設定ファイル

初回は `urirun --edit` で設定ファイルを作成してください。

```
~/.config/uribow-lab/urirun/
  setting.yaml                  # メイン設定
  settings/
    <prefix>-setting.yaml       # 追加設定（プレフィックス付きで呼び出し）
```

### キー解決の仕組み

1. `urirun github` → `setting.yaml` の `github` キーを検索
2. `urirun some-github` → まず `setting.yaml` の `some-github` を検索、なければ `settings/some-setting.yaml` の `github` を検索

### 対応type

| type | 説明 |
|------|------|
| chrome | 指定Chromeプロファイルでウェブページを開く |
| zed | Zedエディタでプロジェクトを開く |
| vscode | VS Codeでプロジェクトを開く |
| ssh | SSH接続する |
| command | シェルコマンドを順番に実行する |

### 設定例

```yaml
# setting.yaml

# zellij
# .config/zellij/layouts/[レイアウトファイル名].kdl
# zellij -s [セッション名] -n [レイアウトファイル名]
dev:
  type: command
  commands: "zellij -s plgl -n dev-plgl"
  description: "開発環境を開く"

github:
  type: chrome
  profile: user@example.com
  url: https://github.com

zed:
  type: zed
  path: /path/to/project

code:
  type: vscode
  path: /path/to/project

server:
  type: ssh
  config: myserver
  path: /home/user/webapp

check:
  type: command
  commands: "ls;cd ~;ls -la"
```

```yaml
# settings/work-setting.yaml
# urirun work-jira で実行
jira:
  type: chrome
  profile: work@example.com
  url: https://myproject.atlassian.net/jira
```

## 更新

```bash
brew update
brew upgrade urirun
```

## 依存

- bash (macOS標準)
- 外部依存なし（Python不要）

## 開発者向け：リリース手順

コードを修正した後、他のMacで `brew upgrade` できるようにするまでの手順。

### 1. コミット＆プッシュ

```bash
git add .
git commit -m "変更内容"
git push origin main
```

### 2. タグを作成してプッシュ

```bash
git tag v1.x.0
git push origin v1.x.0
```

GitHubが自動でtar.gzアーカイブを生成する。

### 3. sha256を取得

```bash
curl -sL https://github.com/uribow-lab/uribow-run-tool/archive/refs/tags/v1.x.0.tar.gz | shasum -a 256
```

### 4. Formulaを更新

`Formula/urirun.rb` の `version`、`url`、`sha256` を更新し、tapリポジトリ（`uribow-lab/homebrew-tap`）にも反映する。

```bash
# tapリポジトリにFormulaをコピーしてプッシュ
cp Formula/urirun.rb /path/to/homebrew-tap/Formula/
cd /path/to/homebrew-tap
git add Formula/urirun.rb
git commit -m "Bump urirun to v1.x.0"
git push origin main
```

これで他のMacから `brew update && brew upgrade urirun` で更新できるようになる。

## ライセンス

MIT
