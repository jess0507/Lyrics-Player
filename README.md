# seek_player

## Builder
```
dart run build_runner build --delete-conflicting-outputs
```

## SHA fingerprint（Firebase / Google 登入用）

Firebase Android app（含 Google 登入）需要在 Firebase Console 登記 SHA-1 / SHA-256，
登記後記得重新下載 `google-services.json`。

### Debug（本機開發）
本機未設定 release 簽章時，build 會回退使用 debug keystore：
```
keytool -list -v -alias androiddebugkey \
  -keystore ~/.android/debug.keystore \
  -storepass android -keypass android
```

目前這台機器的 debug 指紋：
- SHA-1：`4E:2C:63:B1:36:BA:CB:FE:13:A5:5F:C1:93:57:F2:76:91:91:C9:C3`
- SHA-256：`A3:E9:99:77:6F:30:23:1C:3D:27:49:32:BF:2C:BB:28:54:2A:37:8E:95:E3:EC:AE:AB:E9:66:34:BD:23:CB:CC`

> debug keystore 每台機器不同，每位開發者需各自登記自己的 SHA。

### Release（正式簽章）
從 release keystore 取得（路徑 / 別名以 `android/key.properties` 為準）：
```
keytool -list -v -alias <keyAlias> -keystore <storeFile>
```

### 一次列出所有 variant 的指紋
```
cd android && ./gradlew signingReport
```

