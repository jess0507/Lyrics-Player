#!/usr/bin/env bash
#
# gen_app_assets.sh
# 由 assets/icon/app_logo.svg 產生 App 圖示與啟動畫面（splash）資源。
#
# 流程：
#   1. 用 Chrome headless 把 SVG 渲染成透明背景 PNG
#        - assets/icon/app_logo.png            (1024x1024，給 launcher icon / splash)
#        - assets/icon/app_logo_android12.png  (1152x1152，留白多，避開 Android 12 圓形遮罩裁切)
#   2. dart run flutter_launcher_icons      產生各平台 App 圖示
#   3. dart run flutter_native_splash:create 產生啟動畫面資源
#
# 需求：Google Chrome（headless 渲染 SVG）、Flutter SDK。
# 用法：從專案根目錄執行  ./scripts/gen_app_assets.sh
#   設定 launcher icon 背景色（Android adaptive icon），可用環境變數覆寫：
#     ICON_BG="#000000" ./scripts/gen_app_assets.sh
#
set -euo pipefail

# --- 可調整參數 -----------------------------------------------------------
# launcher icon 自適應背景色（Android adaptive icon）。預設白色。
ICON_BG="${ICON_BG:-#FFFFFF}"

# logo 在畫布中的繪製尺寸（px）。數字越大、留白越少，圖示看起來越大。
#   LOGO_SIZE          → 主圖示 / splash（畫布固定 1024）
#   LOGO_SIZE_ANDROID12 → Android 12 splash（畫布固定 1152，會被圓形遮罩裁切，故留白多）
LOGO_SIZE="${LOGO_SIZE:-880}"
LOGO_SIZE_ANDROID12="${LOGO_SIZE_ANDROID12:-600}"

# --- 路徑設定 -------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ICON_DIR="$ROOT_DIR/assets/icon"
SVG="$ICON_DIR/app_logo.svg"
PUBSPEC="$ROOT_DIR/pubspec.yaml"

if [[ ! -f "$SVG" ]]; then
  echo "❌ 找不到來源檔：$SVG" >&2
  exit 1
fi

# --- 找出 Chrome ----------------------------------------------------------
CHROME=""
for c in \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/Applications/Chromium.app/Contents/MacOS/Chromium" \
  "$(command -v google-chrome 2>/dev/null || true)" \
  "$(command -v chromium 2>/dev/null || true)"; do
  if [[ -n "$c" && -x "$c" ]]; then CHROME="$c"; break; fi
done

if [[ -z "$CHROME" ]]; then
  echo "❌ 找不到 Google Chrome / Chromium，無法渲染 SVG。" >&2
  exit 1
fi

# --- 渲染函式：$1=輸出png  $2=畫布尺寸  $3=logo尺寸 ----------------------
render() {
  local out="$1" canvas="$2" logo="$3"
  local tmp_html
  tmp_html="$(mktemp -t app_logo_render).html"
  # SVG 與 HTML 放同目錄，img 才能以相對路徑載入
  cp "$SVG" "$(dirname "$tmp_html")/app_logo.svg"
  cat > "$tmp_html" <<EOF
<!DOCTYPE html><html><head><style>
html,body{margin:0;padding:0;background:transparent}
.box{width:${canvas}px;height:${canvas}px;display:flex;align-items:center;justify-content:center}
img{width:${logo}px;height:${logo}px}
</style></head><body><div class="box"><img src="app_logo.svg"></div></body></html>
EOF
  "$CHROME" --headless --disable-gpu --no-sandbox \
    --default-background-color=00000000 \
    --hide-scrollbars \
    --screenshot="$out" --window-size="${canvas},${canvas}" \
    "$tmp_html" >/dev/null 2>&1
  rm -f "$tmp_html" "$(dirname "$tmp_html")/app_logo.svg"
  echo "  ✓ $out (${canvas}x${canvas}, logo ${logo}px)"
}

echo "🎨 由 SVG 渲染 PNG..."
render "$ICON_DIR/app_logo.png"           1024 "$LOGO_SIZE"
render "$ICON_DIR/app_logo_android12.png" 1152 "$LOGO_SIZE_ANDROID12"

# 將背景色寫入 pubspec.yaml 的 adaptive_icon_background（供 flutter_launcher_icons 讀取）
if grep -qE '^[[:space:]]*adaptive_icon_background:' "$PUBSPEC"; then
  sed -i.bak -E "s|^([[:space:]]*adaptive_icon_background:[[:space:]]*).*|\1\"$ICON_BG\"|" "$PUBSPEC"
  rm -f "$PUBSPEC.bak"
  echo "🎯 launcher icon 背景色 = $ICON_BG"
else
  echo "⚠️  pubspec.yaml 找不到 adaptive_icon_background，略過背景色設定。" >&2
fi

echo "📱 產生 App 圖示 (flutter_launcher_icons)..."
( cd "$ROOT_DIR" && dart run flutter_launcher_icons )

echo "🚀 產生啟動畫面 (flutter_native_splash)..."
( cd "$ROOT_DIR" && dart run flutter_native_splash:create )

echo "✅ 完成：App 圖示與啟動畫面已更新。"
