package com.js.seek_player

import com.ryanheise.audioservice.AudioServiceActivity

// audio_service / just_audio_background 需要 Activity 繼承 AudioServiceActivity，
// 以提供正確的 FlutterEngine 給背景播放服務。
class MainActivity : AudioServiceActivity()
