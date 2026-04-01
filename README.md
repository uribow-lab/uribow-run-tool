# uribow-run-tool

YAML設定ファイルに基づいてアプリやサービスをワンコマンドで起動するランチャー。

## インストール

```bash
brew tap uribow-lab/tap
brew install urirun
```

## 使い方

```bash
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

### 設定例

```yaml
# setting.yaml
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
```

```yaml
# settings/work-setting.yaml
# urirun work-jira で実行
jira:
  type: chrome
  profile: work@example.com
  url: https://myproject.atlassian.net/jira
```

## 依存

- bash (macOS標準)
- 外部依存なし（Python不要）

## ライセンス

MIT
