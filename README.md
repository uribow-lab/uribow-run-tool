# urirun

YAML設定ファイルに基づいてアプリやサービスをワンコマンドで起動するランチャー。

## インストール

```bash
brew tap uribow-lab/tap
brew install urirun
```

## 使い方

```bash
# キーを指定して実行
urirun <key>

# 利用可能なキー一覧
urirun --list

# 設定ファイルを編集
urirun --edit

# バージョン表示
urirun --version
```

## 設定ファイル

初回は `urirun --edit` で設定ファイルを作成してください。

場所: `~/.config/urirun/urirun.yaml`

### 対応type

| type | 説明 |
|------|------|
| chrome | 指定Chromeプロファイルでウェブページを開く |
| zed | Zedエディタでプロジェクトを開く |
| vscode | VS Codeでプロジェクトを開く |
| ssh | SSH接続する |

### 設定例

```yaml
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

code-ws:
  type: vscode
  workspace: /path/to/project.code-workspace

server:
  type: ssh
  config: myserver
  path: /home/user/webapp
```

## 依存

- bash (macOS標準)
- 外部依存なし（Python不要）

## ライセンス

MIT
