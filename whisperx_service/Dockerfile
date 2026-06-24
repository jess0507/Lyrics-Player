# WhisperX forced-alignment 服務(Cloud Run)。
#
# 與 aeneas_service/(Python 3.8)不同,whisperx 需要較新的 Python / torch;此處
# 用 Python 3.11。本容器與 functions/(python312)、aeneas_service/ 互相獨立。
FROM python:3.11-slim-bookworm

# 系統依賴:
# - ffmpeg:whisperx.load_audio 以 ffmpeg 解碼(執行期)。
# - git:部分 pip 套件需。
# - build-essential:PyAV 從源碼編譯需要 gcc,slim 映像不含,缺則報
#   「command 'gcc' failed: No such file or directory」。
# - pkg-config + libav*-dev:whisperx 連帶的 PyAV(av)在無對應預編譯 wheel 時需
#   從原始碼對系統 ffmpeg 編譯,缺這些會在 build wheel 階段報「pkg-config is
#   required for building PyAV」。
# 模型權重在執行期由 HuggingFace 下載,故 HF 快取目錄需可寫。
RUN apt-get update && apt-get install -y --no-install-recommends \
        ffmpeg \
        git \
        build-essential \
        pkg-config \
        libavformat-dev \
        libavcodec-dev \
        libavdevice-dev \
        libavutil-dev \
        libavfilter-dev \
        libswscale-dev \
        libswresample-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# torch / torchaudio 走官方 CPU wheel(Cloud Run 預設無 GPU);其餘依 requirements。
COPY requirements.txt .
RUN pip install --no-cache-dir \
        --extra-index-url https://download.pytorch.org/whl/cpu \
        -r requirements.txt

# 預烤 WhisperX 的 VAD 權重:whisperx 3.1.5 以 urllib 抓寫死的 S3 VAD URL,該 URL
# 現會回 301 轉址、urllib 不跟,導致 runtime 載模型時拋「HTTP Error 301」→ 整批
# 轉寫 422。改在 build 時用 requests(會跟轉址)抓好,放到 whisperx 預期的路徑
# ($TORCH_HOME),runtime 直接命中本機檔、不再下載。URL 與檔名皆取自 whisperx 自身
# 常數,與版本無關;放在 COPY 應用碼之前,讓本層隨 requirements 一起被 layer 快取。
ENV TORCH_HOME=/app/.cache/torch
RUN python -c "import whisperx.vad as v, torch, os, requests; \
d=torch.hub._get_torch_home(); os.makedirs(d, exist_ok=True); \
fp=os.path.join(d, 'whisperx-vad-segmentation.bin'); \
r=requests.get(v.VAD_SEGMENTATION_URL, allow_redirects=True, timeout=120); r.raise_for_status(); \
open(fp, 'wb').write(r.content); \
print('VAD cached:', fp, len(r.content), 'bytes')"

COPY . .

# HuggingFace 快取:首呼會下載對齊模型;指到容器內可寫路徑(冷啟動較慢,屬已知
# 取捨,見 README「冷啟動 / 成本」)。
ENV HF_HOME=/app/.cache/huggingface
ENV PORT=8080
# 對齊為 CPU 密集且單檔耗時可達數十秒~分鐘:單 worker 多 thread,逾時放寬到 600s
# (與 functions/ 的 align_lyrics callable timeout_sec=600 一致)。
CMD exec gunicorn --bind ":$PORT" --workers 1 --threads 4 --timeout 600 main:app
