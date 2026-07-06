# ffmpeg_kit_flutter_new:保留帶 native method 的綁定類別。
# release build 的 R8 會混淆 com.antonkarpenko.ffmpegkit.* 類別,導致
# libffmpegkit_abidetect.so 的 JNI_OnLoad 找不到註冊目標而回傳 0,
# 啟動時崩「UnsatisfiedLinkError: Bad JNI version returned from JNI_OnLoad」。
-keep class com.antonkarpenko.ffmpegkit.** { *; }

# 通則:凡宣告 native method 的類別,保留其類名與方法名(JNI 依名稱綁定)。
-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}
