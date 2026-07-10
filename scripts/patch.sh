#!/usr/bin/env bash
#
# patch.sh
# 把本地 master 推上 GitHub，觸發 patch.yml：
#   對「最新 tag 對應的 release 版本」下 shorebird patch，
#   純 Dart 變更數分鐘內 OTA 出貨，不經 Play Store 審查。
#
# 用法（從專案根目錄執行）：
#   ./scripts/patch.sh
#
# 注意：
# - 動到 native（gradle / AndroidManifest / 含 native code 的 plugin / Flutter 升版）
#   無法 patch，CI 會偵測並失敗——此時請改跑 ./scripts/release.sh 打新版上架。
# - 需要至少一個已 release 的 v* tag 當 baseline。
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT_DIR"

# --- 前置檢查 ---------------------------------------------------------------
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$BRANCH" != "master" ]]; then
  echo "❌ 目前在分支 ${BRANCH}，patch 只能出自 master。" >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "❌ working tree 不乾淨，請先 commit 或 stash。" >&2
  exit 1
fi

echo "🔄 同步遠端狀態..."
git fetch origin --tags

if ! git merge-base --is-ancestor origin/master HEAD; then
  echo "❌ 本地 master 落後 origin/master，請先 git pull。" >&2
  exit 1
fi

LATEST_TAG=$(git describe --tags --abbrev=0 --match 'v*' 2>/dev/null || echo "")
if [[ -z "$LATEST_TAG" ]]; then
  echo "❌ 尚無任何 v* tag，沒有可 patch 的 baseline。請先跑 ./scripts/release.sh。" >&2
  exit 1
fi

if git describe --tags --exact-match HEAD >/dev/null 2>&1; then
  echo "❌ HEAD 就是 tag $LATEST_TAG 本身，沒有新變更可 patch。" >&2
  exit 1
fi

VERSION_NAME=${LATEST_TAG#v}
BUILD_NUMBER=$(git rev-list "$LATEST_TAG" --count)
AHEAD=$(git rev-list "$LATEST_TAG"..HEAD --count)

echo ""
echo "🩹 即將 OTA patch："
echo "   目標 release : ${VERSION_NAME}+${BUILD_NUMBER}（tag ${LATEST_TAG}，領先 ${AHEAD} commits）"
echo "   commit       : $(git log -1 --oneline)"
echo ""
read -r -p "確認出貨？[y/N] " REPLY
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
  echo "已取消。"
  exit 0
fi

# --- 觸發 workflow -----------------------------------------------------------
# 正常流程：有未推的 commit，push 即觸發 patch.yml。
# 若 HEAD 已在 origin/master 上（無東西可推），表示上次 push 時 patch 已觸發過，
# 屬預期外狀況，先擋下——要重跑失敗的 CI 請直接到 Actions 頁面 re-run。
if [[ "$(git rev-parse HEAD)" == "$(git rev-parse origin/master)" ]]; then
  echo "❌ master 已是最新（無新 commit 可推），上次 push 應已觸發過 patch。" >&2
  echo "   若要重跑失敗的 run，請到 Actions 頁面 re-run 該 workflow。" >&2
  exit 1
fi

git push origin master
echo "✅ 已推送 master，patch workflow 啟動中。"

# （備用）已推過但仍想重新觸發時，可改走 workflow_dispatch：
# gh workflow run patch.yml

REPO_URL=$(git remote get-url origin | sed -E 's#^git@github.com:#https://github.com/#; s#\.git$##')
echo "   $REPO_URL/actions/workflows/patch.yml"

if command -v gh >/dev/null 2>&1; then
  sleep 8
  RUN_URL=$(gh run list --workflow=patch.yml --limit 1 --json url --jq '.[0].url' 2>/dev/null || true)
  [[ -n "$RUN_URL" ]] && echo "   本次 run：$RUN_URL"
  echo "   即時追蹤：gh run watch"
fi
