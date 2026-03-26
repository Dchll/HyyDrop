# HYY Drop

中文:
HYY Drop 是一个基于 Flutter 的局域网传输应用，集成了附近设备发现、会话聊天、文件传输，以及面向 Android Live Update 的通知编辑器。

English:
HYY Drop is a Flutter app for LAN file transfer, nearby device sessions, and an Android Live Update notification editor.

## Features | 功能特性

- Nearby peer discovery and device session list | 附近设备发现与会话列表
- Peer-to-peer text chat | 点对点文本聊天
- Local file transfer with progress, speed, ETA, and status updates | 带进度、速度、剩余时间和状态更新的本地文件传输
- Android notification editor for sending custom live notification payloads | 用于发送自定义 Android 实时通知内容的通知编辑器
- Short text segmentation preview and adjustable rotation interval | 短文本断句预览与可调轮播间隔
- Settings center with theme mode and language switching | 支持主题模式和语言切换的设置中心
- Dedicated package info, device info, and about pages | 独立的包信息、设备信息、关于页面
- Global MiSans default font | 全局 MiSans 默认字体

## Main Screens | 主要页面

- `DevicesPage`
  EN: Main workspace for nearby devices, chat, transfer activity, and notification/settings entry points
  ZH: 附近设备、聊天、传输动态，以及通知编辑器和设置入口的主工作台
- `LiveUpdatePage`
  EN: Notification editor used to send Android-side live notification updates through the native bridge
  ZH: 通过原生桥发送 Android 实时通知更新的通知编辑页
- `SettingsPage`
  EN: Diagnostics and settings hub with theme mode, locale selection, and detail page navigation
  ZH: 包含主题模式、语言切换和详情页入口的设置中心
- `SettingsPackageInfoPage`
  EN: Runtime package metadata viewer
  ZH: 运行时包信息页面
- `SettingsDeviceInfoPage`
  EN: Runtime device metadata viewer
  ZH: 运行时设备信息页面
- `SettingsAboutPage`
  EN: About page with project attribution and MiSans font notice
  ZH: 包含项目信息与 MiSans 字体声明的关于页面

## Tech Stack | 技术栈

- Flutter
- Material 3
- Riverpod with code generation
- AutoRoute
- Hive
- Talker
- Flutter localization with ARB files

## Localization | 本地化

Supported languages | 当前支持语言:

- Simplified Chinese | 简体中文
- Traditional Chinese | 繁体中文
- English | 英语

## Theme | 主题

- Light and dark themes are supported | 支持浅色与深色主题
- OLED-friendly dark surfaces are preserved in the shared theme | 深色主题保留了适合 OLED 的暗色表面策略
- `assets/fonts/MiSans VF.ttf` is configured as the global default font | `assets/fonts/MiSans VF.ttf` 已配置为全局默认字体

## Project Structure | 项目结构

```text
lib/
  core/
    locale/
    logging/
    network/
    router/
    storage/
    theme/
  features/
    app/
    devices/
    live_update/
    settings/
  l10n/
```

## Getting Started | 开始使用

1. Install Flutter and make sure `flutter doctor` is ready for your target platform.
   安装 Flutter，并确认 `flutter doctor` 对目标平台检查通过。
2. Fetch dependencies:
   拉取依赖:

```bash
flutter pub get
```

3. Run the app:
   运行应用:

```bash
flutter run
```

## Common Development Commands | 常用开发命令

Format Dart files | 格式化 Dart 文件:

```bash
dart format .
```

Regenerate code after route or provider annotation changes | 路由或 Provider 注解变更后重新生成代码:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Regenerate localization output after ARB changes | 修改 ARB 后重新生成本地化代码:

```bash
flutter gen-l10n
```

Static analysis | 静态分析:

```bash
flutter analyze
```

Run tests | 运行测试:

```bash
flutter test
```

## Notes | 说明

- Android notification testing depends on the native bridge under `android/app/src/main/kotlin/`.
  Android 通知测试依赖 `android/app/src/main/kotlin/` 下的原生桥接代码。
- Route definitions live in `lib/core/router/app_router.dart`.
  路由定义位于 `lib/core/router/app_router.dart`。
- Generated files such as AutoRoute, Riverpod, and localization outputs should not be edited manually.
  AutoRoute、Riverpod 和本地化生成文件不应手动修改。
