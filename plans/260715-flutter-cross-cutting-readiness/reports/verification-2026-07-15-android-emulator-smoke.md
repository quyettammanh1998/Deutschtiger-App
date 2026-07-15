# Android emulator smoke verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `adb -s emulator-5554 shell getprop sys.boot_completed` | Emulator is fully booted | `1` | ✅ |
| `adb -s emulator-5554 shell pm path android` | Android package manager is responsive before install | `package:/system/framework/framework-res.apk` | ✅ |
| `curl -sf http://127.0.0.1:8080/api/v1/health` | Local backend is healthy before Flutter command | Backend OK | ✅ |
| `flutter run -d emulator-5554 --debug` | Debug APK builds, installs, and starts on Android | Built, installed in 2,824 ms, and synced to `sdk gphone64 x86 64` | ✅ |
| `adb -s emulator-5554 shell pidof com.deutschtiger.app` | App process is live after launch | PID `5048` | ✅ |
| `adb -s emulator-5554 shell dumpsys window` | App activity owns the focused window | `com.deutschtiger.app/.MainActivity` | ✅ |
| Native 1080×2400 screenshot | Portrait welcome screen has no visible clipping or overlap | Vietnamese welcome screen rendered cleanly | ✅ |

This smoke test does not validate TalkBack, iOS/VoiceOver, login, native
providers, visual parity, or critical integration journeys. Those Phase 4
requirements remain open.
