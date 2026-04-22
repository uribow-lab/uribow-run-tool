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
# 引数なしで対話選択（setting.yaml のキー + settings/ のプロジェクトから選択）
urirun

# プロジェクト単体で対話選択（settings/<プロジェクト>-setting.yaml のキーから選択）
urirun <プロジェクト>

# setting.yaml のキーを実行
urirun <key>

# settings/<プロジェクト>-setting.yaml のキーを実行
urirun <プロジェクト>-<key>

# 利用可能なキー一覧
urirun --list

# 設定ファイルを編集
urirun --edit                  # setting.yaml を編集
urirun --edit <プロジェクト>   # settings/<プロジェクト>-setting.yaml を編集

# バージョン表示
urirun --version
```

### 対話選択モード

引数なしまたはプロジェクト名のみで実行すると、カーソルキーで選択できるメニューが表示される。

- `↑` / `↓` または `k` / `j` で項目を移動
- `Enter` で決定
- `←` または `h` で親メニューに戻る（プロジェクト配下 → トップレベル）
- `q` または `ESC` でキャンセル

引数なしで実行した場合、`setting.yaml` のキーと `settings/` 配下のプロジェクトが一覧表示される。プロジェクトを選択するとその配下のキー一覧に進む。

セレクタの各行は「識別子 + 説明」の2列で表示される:

- キー行: `キー名  description`（`description` が未設定の場合は `キー名  (type)`）
- プロジェクト行: `[プロジェクト名]  name`（`name` が未設定のプロジェクトは右側が空欄）

パイプやリダイレクト（非対話実行）の場合は従来どおり `usage` と一覧が表示される。

## 設定ファイル

初回は `urirun --edit` で設定ファイルを作成してください。

```
~/.config/uribow-lab/urirun/
  setting.yaml                       # メイン設定
  settings/
    <プロジェクト>-setting.yaml      # 追加設定（プロジェクト名付きで呼び出し）
```

### 設定ファイルの書式

v1.4.0 から、各キーは `keys:` 配下にネストし、トップレベルにはプロジェクトの `name` と `description` を記述する:

```yaml
name: Personal
description: 個人用設定
keys:
  github:
    type: chrome
    profile: user@example.com
    url: https://github.com
    description: GitHub を開く
```

トップレベルの `name` はセレクタの `[プロジェクト]` 行の右側に表示される。

### キー解決の仕組み

1. `urirun github` → `setting.yaml` の `keys:` 配下から `github` を検索
2. `urirun work-jira` → まず `setting.yaml` の `work-jira` を検索、なければ `settings/work-setting.yaml` の `keys:` 配下から `jira` を検索

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
name: Personal
description: 個人用設定
keys:
  dev:
    type: command
    commands: "zellij -s plgl -n dev-plgl"
    description: 開発環境を開く

  github:
    type: chrome
    profile: user@example.com
    url: https://github.com
    description: GitHub を開く

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
name: Work
description: 仕事用
keys:
  jira:
    type: chrome
    profile: work@example.com
    url: https://myproject.atlassian.net/jira
    description: Jira を開く
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
