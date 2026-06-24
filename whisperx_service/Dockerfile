# WhisperX forced-alignment 服務(Cloud Run)。
#
# 與 aeneas_service/(Python 3.8)不同,whisperx 需要較新的 Python / torch;此處
# 用 Python 3.11。本容器與 functions/(python312)、aeneas_service/ 互相獨立。
FROM python:3.11-slim-bookworm

# 系統依賴:
# - ffmpeg:whisperx.load_audio 以 ffmpeg 解碼(執行期)。
# - git:部分 pip 套件需。
# - pkg-config + libav*-dev:whisperx 連帶的 PyAV(av)在無對應預編譯 wheel 時需
#   從原始碼對系統 ffmpeg 編譯,缺這些會在 build wheel 階段報「pkg-config is
#   required for building PyAV」。
# 模型權重在執行期由 HuggingFace 下載,故 HF 快取目錄需可寫。
RUN apt-get update && apt-get install -y --no-install-recommends \
        ffmpeg \
        git \
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

COPY . .

# HuggingFace 快取:首呼會下載對齊模型;指到容器內可寫路徑(冷啟動較慢,屬已知
# 取捨,見 README「冷啟動 / 成本」)。
ENV HF_HOME=/app/.cache/huggingface
ENV PORT=8080
# 對齊為 CPU 密集且單檔耗時可達數十秒~分鐘:單 worker 多 thread,逾時放寬到 600s
# (與 functions/ 的 align_lyrics callable timeout_sec=600 一致)。
CMD exec gunicorn --bind ":$PORT" --workers 1 --threads 4 --timeout 600 main:app
