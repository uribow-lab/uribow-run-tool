#!/bin/bash
# urirun.sh - YAML設定に基づいてアプリを開くランチャー
# Usage: ./urirun.sh <key>

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
YAML_FILE="$SCRIPT_DIR/urirun.yaml"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <key>"
  echo ""
  echo "利用可能なキー:"
  python3 -c "
import yaml, sys
with open('$YAML_FILE') as f:
    content = f.read().replace('\t', '  ')
conf = yaml.safe_load(content)
for key in conf:
    print(f'  {key} - {conf[key].get(\"type\",\"\")} / {conf[key].get(\"url\",\"\")}')
" 2>/dev/null
  exit 1
fi

KEY="$1"

# YAMLからエントリを読み取る
ENTRY=$(python3 -c "
import yaml, json, sys
with open('$YAML_FILE') as f:
    content = f.read().replace('\t', '  ')
conf = yaml.safe_load(content)
entry = conf.get('$KEY')
if entry is None:
    print('ERROR_NOT_FOUND', file=sys.stderr)
    sys.exit(1)
print(json.dumps(entry))
" 2>/dev/null)

if [ $? -ne 0 ]; then
  echo "Error: キー '$KEY' が urirun.yaml に見つかりません"
  exit 1
fi

# エントリから各フィールドを取得（PATH/CONFIGはシェル予約変数のため別名に変換）
TYPE=$(echo "$ENTRY" | python3 -c "import json,sys; print(json.load(sys.stdin).get('type',''))")
PROFILE=$(echo "$ENTRY" | python3 -c "import json,sys; print(json.load(sys.stdin).get('profile',''))")
URL=$(echo "$ENTRY" | python3 -c "import json,sys; print(json.load(sys.stdin).get('url',''))")
TARGET_PATH=$(echo "$ENTRY" | python3 -c "import json,sys; print(json.load(sys.stdin).get('path',''))")
WORKSPACE=$(echo "$ENTRY" | python3 -c "import json,sys; print(json.load(sys.stdin).get('workspace',''))")
SSH_CONFIG=$(echo "$ENTRY" | python3 -c "import json,sys; print(json.load(sys.stdin).get('config',''))")

case "$TYPE" in
  chrome)
    CHROME_DIR="$HOME/Library/Application Support/Google/Chrome"
    PROFILE_DIR=""

    for dir in "$CHROME_DIR"/Default "$CHROME_DIR"/Profile\ *; do
      [ -f "$dir/Preferences" ] || continue
      primary_email=$(python3 -c "
import json
with open('$dir/Preferences') as f:
    prefs = json.load(f)
info = prefs.get('account_info', [])
print(info[0].get('email', '') if info else '')
" 2>/dev/null)
      if [ "$primary_email" = "$PROFILE" ]; then
        PROFILE_DIR="$(basename "$dir")"
        break
      fi
    done

    if [ -z "$PROFILE_DIR" ]; then
      echo "Error: Chromeプロファイルが見つかりません: $PROFILE"
      exit 1
    fi

    echo "[$KEY] Chrome ($PROFILE_DIR / $PROFILE) -> $URL"
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
      --profile-directory="$PROFILE_DIR" \
      "$URL" >/dev/null 2>&1 &
    disown
    ;;

  zed)
    if [ -z "$TARGET_PATH" ]; then
      echo "Error: zed には path が必要です"
      exit 1
    fi
    if [ ! -d "$TARGET_PATH" ]; then
      echo "Error: パスが存在しません: $TARGET_PATH"
      exit 1
    fi
    echo "[$KEY] Zed -> $TARGET_PATH"
    cd "$TARGET_PATH" && zed .
    ;;

  vscode)
    if [ -n "$WORKSPACE" ]; then
      echo "[$KEY] VS Code (workspace) -> $WORKSPACE"
      code "$WORKSPACE"
    elif [ -n "$TARGET_PATH" ]; then
      if [ ! -d "$TARGET_PATH" ]; then
        echo "Error: パスが存在しません: $TARGET_PATH"
        exit 1
      fi
      echo "[$KEY] VS Code -> $TARGET_PATH"
      cd "$TARGET_PATH" && code .
    else
      echo "Error: vscode には workspace または path が必要です"
      exit 1
    fi
    ;;

  ssh)
    if [ -z "$SSH_CONFIG" ]; then
      echo "Error: ssh には config (Host名) が必要です"
      exit 1
    fi
    if [ -n "$TARGET_PATH" ]; then
      echo "[$KEY] SSH -> $SSH_CONFIG (cd $TARGET_PATH)"
      ssh -t "$SSH_CONFIG" "cd $TARGET_PATH && exec \$SHELL -l"
    else
      echo "[$KEY] SSH -> $SSH_CONFIG"
      ssh "$SSH_CONFIG"
    fi
    ;;

  command)
    COMMANDS=$(echo "$ENTRY" | python3 -c "import json,sys; print(json.load(sys.stdin).get('commands',''))")
    if [ -z "$COMMANDS" ]; then
      echo "Error: command には commands が必要です"
      exit 1
    fi
    echo "[$KEY] Command -> $COMMANDS"
    IFS=';' read -ra CMD_LIST <<< "$COMMANDS"
    for cmd in "${CMD_LIST[@]}"; do
      cmd=$(echo "$cmd" | xargs)
      [ -z "$cmd" ] && continue
      echo "  > $cmd"
      eval "$cmd"
    done
    ;;

  *)
    echo "Error: 未対応のtype '$TYPE'"
    exit 1
    ;;
esac
