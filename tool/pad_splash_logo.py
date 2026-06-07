#!/usr/bin/env python3
"""把 logo 縮小並加透明 padding，避免 Android 12+ 圓形遮罩裁切。

用法: python3 tool/pad_splash_logo.py <來源.png> <輸出.png> [scale]
  scale: logo 內容佔畫布比例，預設 0.62
純標準函式庫（zlib + struct），不需 Pillow。僅支援 8-bit RGBA、非交錯 PNG。
"""
import struct
import sys
import zlib


def read_png(path):
    data = open(path, "rb").read()
    assert data[:8] == b"\x89PNG\r\n\x1a\n", "not a PNG"
    pos = 8
    width = height = bit_depth = color_type = None
    idat = bytearray()
    while pos < len(data):
        length = struct.unpack(">I", data[pos:pos + 4])[0]
        tag = data[pos + 4:pos + 8]
        chunk = data[pos + 8:pos + 8 + length]
        if tag == b"IHDR":
            width, height, bit_depth, color_type = struct.unpack(">IIBB", chunk[:10])
        elif tag == b"IDAT":
            idat += chunk
        elif tag == b"IEND":
            break
        pos += 12 + length
    assert bit_depth == 8 and color_type == 6, f"need 8-bit RGBA, got depth={bit_depth} type={color_type}"
    raw = zlib.decompress(bytes(idat))
    bpp = 4
    stride = width * bpp
    out = bytearray(width * height * bpp)
    prev = bytearray(stride)
    p = 0
    for y in range(height):
        f = raw[p]; p += 1
        line = bytearray(raw[p:p + stride]); p += stride
        if f == 1:  # Sub
            for i in range(bpp, stride):
                line[i] = (line[i] + line[i - bpp]) & 0xFF
        elif f == 2:  # Up
            for i in range(stride):
                line[i] = (line[i] + prev[i]) & 0xFF
        elif f == 3:  # Average
            for i in range(stride):
                a = line[i - bpp] if i >= bpp else 0
                line[i] = (line[i] + ((a + prev[i]) >> 1)) & 0xFF
        elif f == 4:  # Paeth
            for i in range(stride):
                a = line[i - bpp] if i >= bpp else 0
                b = prev[i]
                c = prev[i - bpp] if i >= bpp else 0
                pp = a + b - c
                pa, pb, pc = abs(pp - a), abs(pp - b), abs(pp - c)
                pr = a if (pa <= pb and pa <= pc) else (b if pb <= pc else c)
                line[i] = (line[i] + pr) & 0xFF
        out[y * stride:(y + 1) * stride] = line
        prev = line
    return width, height, out


def bilinear(src, sw, sh, dw, dh):
    dst = bytearray(dw * dh * 4)
    for dy in range(dh):
        sy = (dy + 0.5) * sh / dh - 0.5
        y0 = int(sy) if sy >= 0 else -1
        fy = sy - y0
        y0c = min(max(y0, 0), sh - 1)
        y1c = min(max(y0 + 1, 0), sh - 1)
        for dx in range(dw):
            sx = (dx + 0.5) * sw / dw - 0.5
            x0 = int(sx) if sx >= 0 else -1
            fx = sx - x0
            x0c = min(max(x0, 0), sw - 1)
            x1c = min(max(x0 + 1, 0), sw - 1)
            di = (dy * dw + dx) * 4
            for c in range(4):
                p00 = src[(y0c * sw + x0c) * 4 + c]
                p10 = src[(y0c * sw + x1c) * 4 + c]
                p01 = src[(y1c * sw + x0c) * 4 + c]
                p11 = src[(y1c * sw + x1c) * 4 + c]
                top = p00 + (p10 - p00) * fx
                bot = p01 + (p11 - p01) * fx
                dst[di + c] = int(round(top + (bot - top) * fy))
    return dst


def write_png(path, w, h, rgba):
    raw = bytearray()
    stride = w * 4
    for y in range(h):
        raw.append(0)
        raw += rgba[y * stride:(y + 1) * stride]

    def chunk(tag, d):
        return struct.pack(">I", len(d)) + tag + d + struct.pack(">I", zlib.crc32(tag + d) & 0xFFFFFFFF)

    with open(path, "wb") as f:
        f.write(b"\x89PNG\r\n\x1a\n")
        f.write(chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)))
        f.write(chunk(b"IDAT", zlib.compress(bytes(raw), 9)))
        f.write(chunk(b"IEND", b""))


def main():
    src_path, out_path = sys.argv[1], sys.argv[2]
    scale = float(sys.argv[3]) if len(sys.argv) > 3 else 0.62
    w, h, src = read_png(src_path)
    canvas = max(w, h)
    inner = int(round(canvas * scale))
    scaled = bilinear(src, w, h, inner, inner)
    out = bytearray(canvas * canvas * 4)  # 透明畫布
    off = (canvas - inner) // 2
    for y in range(inner):
        dst_i = ((y + off) * canvas + off) * 4
        src_i = y * inner * 4
        out[dst_i:dst_i + inner * 4] = scaled[src_i:src_i + inner * 4]
    write_png(out_path, canvas, canvas, out)
    print(f"wrote {out_path} ({canvas}x{canvas}, logo {int(scale*100)}%)")


if __name__ == "__main__":
    main()
