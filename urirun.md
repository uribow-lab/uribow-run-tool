# urirun

YAML設定ファイルに基づいてアプリやサービスをワンコマンドで起動するランチャー。

## 必要なもの

| 依存 | インストール |
|------|-------------|
| python3 | macOS標準搭載 / `brew install python3` |
| PyYAML | `pip3 install pyyaml` |

## ファイル構成

```
urirun.sh    # ランチャー本体
urirun.yaml  # 設定ファイル（同じディレクトリに置く）
```

## 使い方

```bash
# キーを指定して実行
./urirun.sh <key>

# 引数なしで利用可能なキー一覧を表示
./urirun.sh
```

## 対応type一覧

### chrome

指定したChromeプロファイル（メールアドレス）でURLを開く。

```yaml
github:
  type: chrome
  profile: user@example.com    # Chromeプロファイルのメールアドレス
  url: https://github.com
```

### zed

指定パスをZedエディタで開く。

```yaml
zed:
  type: zed
  path: /path/to/project
```

### vscode

VS Codeでプロジェクトを開く。`workspace` と `path` の2通りの指定が可能。

```yaml
# ワークスペースファイルを指定して開く
code-ws:
  type: vscode
  workspace: /path/to/project.code-workspace

# ディレクトリを指定して開く
code:
  type: vscode
  path: /path/to/project
```

`workspace` が設定されている場合はワークスペースを優先して開く。

### ssh

`~/.ssh/config` に定義されたHost名でSSH接続する。

```yaml
ssh:
  type: ssh
  config: myserver              # ~/.ssh/config の Host名
  path: /home/user/project      # 接続後に移動するパス（省略可）
```

`path` を設定すると、SSH接続後にそのディレクトリへ自動で移動する。

## 設定ファイル例（urirun.yaml）

```yaml
github:
  type: chrome
  profile: user@example.com
  url: https://github.com

jira:
  type: chrome
  profile: user@example.com
  url: https://myproject.atlassian.net/jira

front:
  type: chrome
  profile: user@example.com
  url: http://localhost:5173

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

### command

セミコロン区切りで複数のシェルコマンドを順番に実行する。

```yaml
check:
  type: command
  commands: "ls;cd ~;ls -la"
```

各コマンドはセミコロン `;` で区切って指定する。空のコマンドは自動でスキップされる。

## 備考

- YAML内のタブ文字は自動的にスペースに変換して読み込まれる
- `urirun.yaml` は `urirun.sh` と同じディレクトリに配置すること
