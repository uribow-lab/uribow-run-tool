---
name: release
description: urirunの新バージョンをリリースする。コミット、タグ作成、プッシュ、sha256取得、Formula更新、tapリポジトリ反映までを実行する。「リリースして」「リリース」で発動。
---

# urirun リリーススキル

以下の手順でリリースを実行する。各ステップでエラーが発生した場合は中断してユーザーに報告すること。

## 手順

### 1. バージョン確認

`bin/urirun` の `VERSION` 変数からバージョン番号を読み取る。これがリリースバージョンとなる。

### 2. 変更をコミット＆プッシュ

```bash
git add -A
git commit -m "Release v<VERSION>"
git push origin main
```

- コミット前に `git status` で変更内容を確認し、ユーザーに表示する
- 変更がなければコミットをスキップする

### 3. タグを作成してプッシュ

```bash
git tag v<VERSION>
git push origin v<VERSION>
```

- 同名のタグが既に存在する場合はユーザーに確認する

### 4. sha256を取得

タグのプッシュ後、GitHubがアーカイブを生成するまで少し待ってからsha256を取得する。

```bash
curl -sL https://github.com/uribow-lab/uribow-run-tool/archive/refs/tags/v<VERSION>.tar.gz | shasum -a 256
```

### 5. Formula/urirun.rb を更新

取得したsha256で `Formula/urirun.rb` の以下を更新する:

- `url` のバージョン部分
- `sha256` の値
- `version` の値

### 6. Formulaの変更をコミット＆プッシュ

```bash
git add Formula/urirun.rb
git commit -m "Bump Formula to v<VERSION>"
git push origin main
```

### 7. tapリポジトリに反映

tapリポジトリ（`uribow-lab/homebrew-tap`）は非公開。remote は SSH（`git@github-uribow:uribow-lab/homebrew-tap.git`）に設定済みなので、SSH で pull / push する。

```bash
TAP=/usr/local/Homebrew/Library/Taps/uribow-lab/homebrew-tap

# remote が SSH になっているか確認（https:// なら中断してユーザーに報告）
git -C "$TAP" remote get-url origin

# 別のMacから反映された分を取り込む（ローカルが遅れていることがある）
git -C "$TAP" pull --ff-only origin main

cp Formula/urirun.rb "$TAP/Formula/urirun.rb"
git -C "$TAP" add Formula/urirun.rb
# tapリポジトリには作成者が未設定のため、urirunリポジトリと同じ作成者をコミット単位で指定する
git -C "$TAP" -c user.name="$(git config user.name)" -c user.email="$(git config user.email)" \
  commit -m "Bump urirun to v<VERSION>"
git -C "$TAP" push origin main
```

- remote が `https://` のままだと、非公開リポジトリのため `Repository not found` で失敗する。その場合は勝手に変更せず、以下の実行をユーザーに依頼する:
  `git -C /usr/local/Homebrew/Library/Taps/uribow-lab/homebrew-tap remote set-url origin git@github-uribow:uribow-lab/homebrew-tap.git`
- SSH 認証で失敗した場合（`Permission denied (publickey)` 等）は、HTTPS や `gh auth token` に切り替えず、ユーザーに `ssh-add` での鍵の再登録を依頼して中断する
- `pull --ff-only` が失敗した場合（ローカルに未 push のコミットがある等）は中断してユーザーに報告する

### 8. 完了報告

全ステップ完了後、以下を表示する:

- リリースしたバージョン
- 他のMacでの更新コマンド: `brew update && brew upgrade urirun`
