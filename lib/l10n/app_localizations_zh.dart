// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'HyyDrop';

  @override
  String get runtimeDiagnostics => '运行诊断';

  @override
  String get appAndDeviceInfo => '应用与设备信息';

  @override
  String get themeModeSectionTitle => '主题模式';

  @override
  String get languageSectionTitle => '语言';

  @override
  String get themeModeSystem => '跟随系统';

  @override
  String get themeModeLight => '浅色';

  @override
  String get themeModeDark => '深色';

  @override
  String get localeSystem => '自动';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeSimplifiedChinese => '简中';

  @override
  String get localeTraditionalChinese => '繁中';

  @override
  String get packageDetails => '应用包信息';

  @override
  String get deviceDetails => '设备信息';

  @override
  String fieldsCount(int count) {
    return '$count 项字段';
  }

  @override
  String get application => '应用信息';

  @override
  String get packageInfoPlusTitle => '应用包信息';

  @override
  String get deviceInfoPlusSubtitle => '设备信息 · 当前平台实时快照';

  @override
  String get versionShortLabel => '版本';

  @override
  String get deviceShortLabel => '设备';

  @override
  String get physicalShortLabel => '真机';

  @override
  String get yesLabel => '是';

  @override
  String get noLabel => '否';

  @override
  String get packageMetricLabel => '应用包';

  @override
  String get deviceMetricLabel => '设备';

  @override
  String get languageMetricLabel => '语言';

  @override
  String get loadingDiagnostics => '正在收集应用与设备信息...';

  @override
  String get unableLoadDiagnostics => '无法加载诊断信息';

  @override
  String get retry => '重试';

  @override
  String get overviewTab => '概览';

  @override
  String get packageTab => '应用包';

  @override
  String get deviceTab => '设备';

  @override
  String get themeTab => '主题';

  @override
  String get appNameField => '应用名称';

  @override
  String get packageNameField => '包名';

  @override
  String get versionField => '版本号';

  @override
  String get buildNumberField => '构建号';

  @override
  String get buildSignatureField => '签名摘要';

  @override
  String get installerStoreField => '安装来源';

  @override
  String get installTimeField => '安装时间';

  @override
  String get updateTimeField => '更新时间';

  @override
  String get unavailable => '不可用';

  @override
  String get platformWeb => 'Web';

  @override
  String get platformAndroid => '安卓';

  @override
  String get platformIos => 'iOS';

  @override
  String get platformMacos => 'macOS';

  @override
  String get platformWindows => 'Windows';

  @override
  String get platformLinux => 'Linux';

  @override
  String get platformFuchsia => 'Fuchsia';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsExploreTitle => '更多页面';

  @override
  String get settingsExploreSubtitle => '打开独立详情页';

  @override
  String get settingsAboutTitle => '关于';

  @override
  String get settingsAboutSubtitle => '项目与字体信息';

  @override
  String get settingsAboutBody => '这里会标注当前构建中使用的界面和技术信息。';

  @override
  String get settingsAboutFontSectionTitle => '默认字体';

  @override
  String get settingsAboutFontNotice =>
      '当前应用已将 `assets/fonts/MiSans VF.ttf` 中的 MiSans VF 设置为全局默认字体。';

  @override
  String get settingsAboutFontSample =>
      'MiSans VF 示例：HyyDrop 传输体验 / Transfer Experience';

  @override
  String get packageInfoPageTitle => '包信息';

  @override
  String get packageInfoPageSubtitle => '查看当前应用构建的完整包元数据。';

  @override
  String get deviceInfoPageTitle => '设备信息';

  @override
  String get deviceInfoPageSubtitle => '查看当前设备的完整运行时快照。';

  @override
  String get homePageHeadline => '通知与局域网传输';

  @override
  String get homePageSubtitle => '从这里进入通知编辑器或设备会话，首页视觉与通知编辑器保持同一套浅色卡片语言。';

  @override
  String get dailySentenceTitle => '每日一句';

  @override
  String get dailySentenceHint => '轻点卡片即可刷新内容。';

  @override
  String get dailySentenceFallback => '暂时没有可展示的内容';

  @override
  String get loadingLabel => '加载中...';

  @override
  String get openDevicesAction => '打开设备列表';

  @override
  String get devicesTitle => '附近设备';

  @override
  String get devicesSubtitle => '局域网会话、在线设备与传输动态';

  @override
  String get onlineLabel => '在线';

  @override
  String get offlineLabel => '离线';

  @override
  String get listeningPortLabel => '端口';

  @override
  String get inboxLabel => '收件箱';

  @override
  String get serverReadyLabel => '传输服务已就绪';

  @override
  String get serverStartingLabel => '传输服务启动中...';

  @override
  String get emptyPeersBody => '附近设备暂时还没有响应，点击雷达按钮重新探测。';

  @override
  String get emptyChatTitle => '选择一台设备';

  @override
  String get emptyChatBody => '附近设备和最近传输会话会显示在这里。';

  @override
  String get transferIdleTitle => '还没有传输记录';

  @override
  String get transferIdleBody => '当前会话已经可以发起文件传输，输入文件路径即可开始第一条任务。';

  @override
  String get chatIdleTitle => '开始这段会话';

  @override
  String get chatIdleBody => '进入这个设备会话后会建立 TCP 聊天连接，先发一条文字或一个文件试试。';

  @override
  String get chatIdleLabel => '聊天空闲';

  @override
  String get chatConnectingLabel => '聊天连接中';

  @override
  String get chatConnectedLabel => '聊天已连接';

  @override
  String get chatFailedLabel => '聊天连接失败';

  @override
  String get chatInputHint => '发送一条文字消息...';

  @override
  String get sendTextAction => '发送';

  @override
  String get messageSendFailed => '文字消息发送失败。';

  @override
  String get sendFileAction => '发送文件';

  @override
  String get enterPathTitle => '发送文件';

  @override
  String get filePathLabel => '本地文件路径';

  @override
  String get filePathHint => '/Users/you/Desktop/demo.zip';

  @override
  String get cancelAction => '取消';

  @override
  String get pathRequiredMessage => '请输入有效的本地文件路径。';

  @override
  String get sendQueuedMessage => '传输任务已加入队列。';

  @override
  String get statusQueued => '排队中';

  @override
  String get statusConnecting => '连接中';

  @override
  String get statusSending => '发送中';

  @override
  String get statusReceiving => '接收中';

  @override
  String get statusDone => '已完成';

  @override
  String get statusFailed => '已失败';

  @override
  String get speedShortLabel => '速度';

  @override
  String get etaShortLabel => '剩余';

  @override
  String get liveUpdateOpenComposerAction => '发送通知';

  @override
  String get liveUpdatePageTitle => '通知编辑器';

  @override
  String get liveUpdatePageSubtitle =>
      '自定义 Live Update 内容并直接发送到 Android 原生通知桥接层。';

  @override
  String get liveUpdateStyleSectionTitle => '通知样式';

  @override
  String get liveUpdateStyleBigText => 'BigTextStyle';

  @override
  String get liveUpdateStyleCall => 'CallStyle';

  @override
  String get liveUpdateStyleProgress => 'ProgressStyle';

  @override
  String get liveUpdateStyleMetric => 'MetricStyle';

  @override
  String get liveUpdateStyleBigTextHint => '适合长正文的展开文本通知。';

  @override
  String get liveUpdateStyleCallHint => '适合来电、通话中、筛查中的通话卡片样式。';

  @override
  String get liveUpdateStyleProgressHint => '进度条样式，不支持的 Android 版本会自动降级。';

  @override
  String get liveUpdateStyleMetricHint => '指标卡片样式，不支持的 Android 版本会自动降级。';

  @override
  String get liveUpdateTitleLabel => '标题';

  @override
  String get liveUpdateBodyLabel => '正文';

  @override
  String get liveUpdateSubTextLabel => '副标题';

  @override
  String get liveUpdateCallPersonLabel => '来电人';

  @override
  String get liveUpdateCallBodyLabel => '通话说明';

  @override
  String get liveUpdateCallVerificationLabel => '校验文本';

  @override
  String get liveUpdateCallTypeSectionTitle => '通话类型';

  @override
  String get liveUpdateCallTypeIncoming => '来电';

  @override
  String get liveUpdateCallTypeOngoing => '通话中';

  @override
  String get liveUpdateCallTypeScreening => '筛查中';

  @override
  String get liveUpdateCallVideoLabel => '视频通话';

  @override
  String get liveUpdateCallBodyFallback => '通话进行中';

  @override
  String get liveUpdateMetricBodyLabel => '摘要';

  @override
  String get liveUpdateMetricPrimaryTitle => '主指标';

  @override
  String get liveUpdateMetricSecondaryTitle => '次指标';

  @override
  String get liveUpdateMetricTertiaryTitle => '第三指标';

  @override
  String get liveUpdateMetricLabelField => '指标名称';

  @override
  String get liveUpdateMetricValueField => '指标值';

  @override
  String get liveUpdateMetricBodyFallback => '指标更新';

  @override
  String get liveUpdateMetricPairIncomplete => '可选指标必须同时填写名称和值。';

  @override
  String get liveUpdateShortCriticalTextLabel => '短文本';

  @override
  String get liveUpdateProgressLabel => '进度';

  @override
  String get liveUpdateProgressHint => '输入 0 到 100 的整数';

  @override
  String liveUpdateFieldRequired(Object fieldLabel) {
    return '请输入$fieldLabel';
  }

  @override
  String get liveUpdateProgressRequired => '请输入进度值';

  @override
  String get liveUpdateProgressInvalid => '进度必须是 0 到 100 的整数';

  @override
  String get liveUpdateSendAction => '发送 Live Update';

  @override
  String get liveUpdateToastSuccess => '通知已更新';

  @override
  String get liveUpdateShortTextRefreshLabel => '短文本刷新时间';

  @override
  String get liveUpdateShortTextRefreshHint => '通过滑动条设置短文本轮播间隔，范围 1 到 10 秒。';

  @override
  String liveUpdateShortTextRefreshValue(Object seconds) {
    return '$seconds 秒';
  }

  @override
  String get liveUpdateShortTextPreviewTitle => '短文本预览';

  @override
  String get liveUpdateShortTextPreviewEmpty => '输入短文本后，这里会预览它将如何被断句并轮换显示。';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get appTitle => 'HyyDrop';

  @override
  String get runtimeDiagnostics => '运行诊断';

  @override
  String get appAndDeviceInfo => '应用与设备信息';

  @override
  String get themeModeSectionTitle => '主题模式';

  @override
  String get languageSectionTitle => '语言';

  @override
  String get themeModeSystem => '跟随系统';

  @override
  String get themeModeLight => '浅色';

  @override
  String get themeModeDark => '深色';

  @override
  String get localeSystem => '自动';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeSimplifiedChinese => '简中';

  @override
  String get localeTraditionalChinese => '繁中';

  @override
  String get packageDetails => '应用包信息';

  @override
  String get deviceDetails => '设备信息';

  @override
  String fieldsCount(int count) {
    return '$count 项字段';
  }

  @override
  String get application => '应用信息';

  @override
  String get packageInfoPlusTitle => '应用包信息';

  @override
  String get deviceInfoPlusSubtitle => '设备信息 · 当前平台实时快照';

  @override
  String get versionShortLabel => '版本';

  @override
  String get deviceShortLabel => '设备';

  @override
  String get physicalShortLabel => '真机';

  @override
  String get yesLabel => '是';

  @override
  String get noLabel => '否';

  @override
  String get packageMetricLabel => '应用包';

  @override
  String get deviceMetricLabel => '设备';

  @override
  String get languageMetricLabel => '语言';

  @override
  String get loadingDiagnostics => '正在收集应用与设备信息...';

  @override
  String get unableLoadDiagnostics => '无法加载诊断信息';

  @override
  String get retry => '重试';

  @override
  String get overviewTab => '概览';

  @override
  String get packageTab => '应用包';

  @override
  String get deviceTab => '设备';

  @override
  String get themeTab => '主题';

  @override
  String get appNameField => '应用名称';

  @override
  String get packageNameField => '包名';

  @override
  String get versionField => '版本号';

  @override
  String get buildNumberField => '构建号';

  @override
  String get buildSignatureField => '签名摘要';

  @override
  String get installerStoreField => '安装来源';

  @override
  String get installTimeField => '安装时间';

  @override
  String get updateTimeField => '更新时间';

  @override
  String get unavailable => '不可用';

  @override
  String get platformWeb => 'Web';

  @override
  String get platformAndroid => '安卓';

  @override
  String get platformIos => 'iOS';

  @override
  String get platformMacos => 'macOS';

  @override
  String get platformWindows => 'Windows';

  @override
  String get platformLinux => 'Linux';

  @override
  String get platformFuchsia => 'Fuchsia';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsExploreTitle => '更多页面';

  @override
  String get settingsExploreSubtitle => '打开独立详情页';

  @override
  String get settingsAboutTitle => '关于';

  @override
  String get settingsAboutSubtitle => '项目与字体信息';

  @override
  String get settingsAboutBody => '这里会标注当前构建中使用的界面和技术信息。';

  @override
  String get settingsAboutFontSectionTitle => '默认字体';

  @override
  String get settingsAboutFontNotice =>
      '当前应用已将 `assets/fonts/MiSans VF.ttf` 中的 MiSans VF 设置为全局默认字体。';

  @override
  String get settingsAboutFontSample =>
      'MiSans VF 示例：HyyDrop 传输体验 / Transfer Experience';

  @override
  String get packageInfoPageTitle => '包信息';

  @override
  String get packageInfoPageSubtitle => '查看当前应用构建的完整包元数据。';

  @override
  String get deviceInfoPageTitle => '设备信息';

  @override
  String get deviceInfoPageSubtitle => '查看当前设备的完整运行时快照。';

  @override
  String get homePageHeadline => '通知与局域网传输';

  @override
  String get homePageSubtitle => '从这里进入通知编辑器或设备会话，首页视觉与通知编辑器保持同一套浅色卡片语言。';

  @override
  String get dailySentenceTitle => '每日一句';

  @override
  String get dailySentenceHint => '轻点卡片即可刷新内容。';

  @override
  String get dailySentenceFallback => '暂时没有可展示的内容';

  @override
  String get loadingLabel => '加载中...';

  @override
  String get openDevicesAction => '打开设备列表';

  @override
  String get devicesTitle => '附近设备';

  @override
  String get devicesSubtitle => '局域网会话、在线设备与传输动态';

  @override
  String get onlineLabel => '在线';

  @override
  String get offlineLabel => '离线';

  @override
  String get listeningPortLabel => '端口';

  @override
  String get inboxLabel => '收件箱';

  @override
  String get serverReadyLabel => '传输服务已就绪';

  @override
  String get serverStartingLabel => '传输服务启动中...';

  @override
  String get emptyPeersBody => '附近设备暂时还没有响应，点击雷达按钮重新探测。';

  @override
  String get emptyChatTitle => '选择一台设备';

  @override
  String get emptyChatBody => '附近设备和最近传输会话会显示在这里。';

  @override
  String get transferIdleTitle => '还没有传输记录';

  @override
  String get transferIdleBody => '当前会话已经可以发起文件传输，输入文件路径即可开始第一条任务。';

  @override
  String get chatIdleTitle => '开始这段会话';

  @override
  String get chatIdleBody => '进入这个设备会话后会建立 TCP 聊天连接，先发一条文字或一个文件试试。';

  @override
  String get chatIdleLabel => '聊天空闲';

  @override
  String get chatConnectingLabel => '聊天连接中';

  @override
  String get chatConnectedLabel => '聊天已连接';

  @override
  String get chatFailedLabel => '聊天连接失败';

  @override
  String get chatInputHint => '发送一条文字消息...';

  @override
  String get sendTextAction => '发送';

  @override
  String get messageSendFailed => '文字消息发送失败。';

  @override
  String get sendFileAction => '发送文件';

  @override
  String get enterPathTitle => '发送文件';

  @override
  String get filePathLabel => '本地文件路径';

  @override
  String get filePathHint => '/Users/you/Desktop/demo.zip';

  @override
  String get cancelAction => '取消';

  @override
  String get pathRequiredMessage => '请输入有效的本地文件路径。';

  @override
  String get sendQueuedMessage => '传输任务已加入队列。';

  @override
  String get statusQueued => '排队中';

  @override
  String get statusConnecting => '连接中';

  @override
  String get statusSending => '发送中';

  @override
  String get statusReceiving => '接收中';

  @override
  String get statusDone => '已完成';

  @override
  String get statusFailed => '已失败';

  @override
  String get speedShortLabel => '速度';

  @override
  String get etaShortLabel => '剩余';

  @override
  String get liveUpdateOpenComposerAction => '发送通知';

  @override
  String get liveUpdatePageTitle => '通知编辑器';

  @override
  String get liveUpdatePageSubtitle =>
      '自定义 Live Update 内容并直接发送到 Android 原生通知桥接层。';

  @override
  String get liveUpdateStyleSectionTitle => '通知样式';

  @override
  String get liveUpdateStyleBigText => 'BigTextStyle';

  @override
  String get liveUpdateStyleCall => 'CallStyle';

  @override
  String get liveUpdateStyleProgress => 'ProgressStyle';

  @override
  String get liveUpdateStyleMetric => 'MetricStyle';

  @override
  String get liveUpdateStyleBigTextHint => '适合长正文的展开文本通知。';

  @override
  String get liveUpdateStyleCallHint => '适合来电、通话中、筛查中的通话卡片样式。';

  @override
  String get liveUpdateStyleProgressHint => '进度条样式，不支持的 Android 版本会自动降级。';

  @override
  String get liveUpdateStyleMetricHint => '指标卡片样式，不支持的 Android 版本会自动降级。';

  @override
  String get liveUpdateTitleLabel => '标题';

  @override
  String get liveUpdateBodyLabel => '正文';

  @override
  String get liveUpdateSubTextLabel => '副标题';

  @override
  String get liveUpdateCallPersonLabel => '来电人';

  @override
  String get liveUpdateCallBodyLabel => '通话说明';

  @override
  String get liveUpdateCallVerificationLabel => '校验文本';

  @override
  String get liveUpdateCallTypeSectionTitle => '通话类型';

  @override
  String get liveUpdateCallTypeIncoming => '来电';

  @override
  String get liveUpdateCallTypeOngoing => '通话中';

  @override
  String get liveUpdateCallTypeScreening => '筛查中';

  @override
  String get liveUpdateCallVideoLabel => '视频通话';

  @override
  String get liveUpdateCallBodyFallback => '通话进行中';

  @override
  String get liveUpdateMetricBodyLabel => '摘要';

  @override
  String get liveUpdateMetricPrimaryTitle => '主指标';

  @override
  String get liveUpdateMetricSecondaryTitle => '次指标';

  @override
  String get liveUpdateMetricTertiaryTitle => '第三指标';

  @override
  String get liveUpdateMetricLabelField => '指标名称';

  @override
  String get liveUpdateMetricValueField => '指标值';

  @override
  String get liveUpdateMetricBodyFallback => '指标更新';

  @override
  String get liveUpdateMetricPairIncomplete => '可选指标必须同时填写名称和值。';

  @override
  String get liveUpdateShortCriticalTextLabel => '短文本';

  @override
  String get liveUpdateProgressLabel => '进度';

  @override
  String get liveUpdateProgressHint => '输入 0 到 100 的整数';

  @override
  String liveUpdateFieldRequired(Object fieldLabel) {
    return '请输入$fieldLabel';
  }

  @override
  String get liveUpdateProgressRequired => '请输入进度值';

  @override
  String get liveUpdateProgressInvalid => '进度必须是 0 到 100 的整数';

  @override
  String get liveUpdateSendAction => '发送 Live Update';

  @override
  String get liveUpdateToastSuccess => '通知已更新';

  @override
  String get liveUpdateShortTextRefreshLabel => '短文本刷新时间';

  @override
  String get liveUpdateShortTextRefreshHint => '通过滑动条设置短文本轮播间隔，范围 1 到 10 秒。';

  @override
  String liveUpdateShortTextRefreshValue(Object seconds) {
    return '$seconds 秒';
  }

  @override
  String get liveUpdateShortTextPreviewTitle => '短文本预览';

  @override
  String get liveUpdateShortTextPreviewEmpty => '输入短文本后，这里会预览它将如何被断句并轮换显示。';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'HyyDrop';

  @override
  String get runtimeDiagnostics => '執行診斷';

  @override
  String get appAndDeviceInfo => '應用與裝置資訊';

  @override
  String get themeModeSectionTitle => '主題模式';

  @override
  String get languageSectionTitle => '語言';

  @override
  String get themeModeSystem => '跟隨系統';

  @override
  String get themeModeLight => '淺色';

  @override
  String get themeModeDark => '深色';

  @override
  String get localeSystem => '自動';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeSimplifiedChinese => '簡中';

  @override
  String get localeTraditionalChinese => '繁中';

  @override
  String get packageDetails => '應用套件資訊';

  @override
  String get deviceDetails => '裝置資訊';

  @override
  String fieldsCount(int count) {
    return '$count 項欄位';
  }

  @override
  String get application => '應用資訊';

  @override
  String get packageInfoPlusTitle => '應用套件資訊';

  @override
  String get deviceInfoPlusSubtitle => '裝置資訊 · 目前平台即時快照';

  @override
  String get versionShortLabel => '版本';

  @override
  String get deviceShortLabel => '裝置';

  @override
  String get physicalShortLabel => '實機';

  @override
  String get yesLabel => '是';

  @override
  String get noLabel => '否';

  @override
  String get packageMetricLabel => '應用套件';

  @override
  String get deviceMetricLabel => '裝置';

  @override
  String get languageMetricLabel => '語言';

  @override
  String get loadingDiagnostics => '正在收集應用與裝置資訊...';

  @override
  String get unableLoadDiagnostics => '無法載入診斷資訊';

  @override
  String get retry => '重試';

  @override
  String get overviewTab => '總覽';

  @override
  String get packageTab => '應用套件';

  @override
  String get deviceTab => '裝置';

  @override
  String get themeTab => '主題';

  @override
  String get appNameField => '應用名稱';

  @override
  String get packageNameField => '套件名稱';

  @override
  String get versionField => '版本號';

  @override
  String get buildNumberField => '建置號';

  @override
  String get buildSignatureField => '簽章摘要';

  @override
  String get installerStoreField => '安裝來源';

  @override
  String get installTimeField => '安裝時間';

  @override
  String get updateTimeField => '更新時間';

  @override
  String get unavailable => '不可用';

  @override
  String get platformWeb => 'Web';

  @override
  String get platformAndroid => 'Android';

  @override
  String get platformIos => 'iOS';

  @override
  String get platformMacos => 'macOS';

  @override
  String get platformWindows => 'Windows';

  @override
  String get platformLinux => 'Linux';

  @override
  String get platformFuchsia => 'Fuchsia';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsExploreTitle => '更多頁面';

  @override
  String get settingsExploreSubtitle => '打開獨立詳情頁';

  @override
  String get settingsAboutTitle => '關於';

  @override
  String get settingsAboutSubtitle => '專案與字體資訊';

  @override
  String get settingsAboutBody => '這裡會標示目前建置中使用的介面與技術資訊。';

  @override
  String get settingsAboutFontSectionTitle => '預設字體';

  @override
  String get settingsAboutFontNotice =>
      '目前應用已將 `assets/fonts/MiSans VF.ttf` 中的 MiSans VF 設為全域預設字體。';

  @override
  String get settingsAboutFontSample =>
      'MiSans VF 範例：HyyDrop 傳輸體驗 / Transfer Experience';

  @override
  String get packageInfoPageTitle => '套件資訊';

  @override
  String get packageInfoPageSubtitle => '查看目前應用建置的完整套件中繼資料。';

  @override
  String get deviceInfoPageTitle => '裝置資訊';

  @override
  String get deviceInfoPageSubtitle => '查看目前裝置的完整執行期快照。';

  @override
  String get homePageHeadline => '通知與區域網傳輸';

  @override
  String get homePageSubtitle => '從這裡進入通知編輯器或裝置會話，首頁視覺與通知編輯器保持同一套淺色卡片語言。';

  @override
  String get dailySentenceTitle => '每日一句';

  @override
  String get dailySentenceHint => '輕點卡片即可重新整理內容。';

  @override
  String get dailySentenceFallback => '暫時沒有可顯示的內容';

  @override
  String get loadingLabel => '載入中...';

  @override
  String get openDevicesAction => '打開裝置列表';

  @override
  String get devicesTitle => '附近裝置';

  @override
  String get devicesSubtitle => '區域網路會話、在線裝置與傳輸動態';

  @override
  String get onlineLabel => '在線';

  @override
  String get offlineLabel => '離線';

  @override
  String get listeningPortLabel => '連接埠';

  @override
  String get inboxLabel => '收件匣';

  @override
  String get serverReadyLabel => '傳輸服務已就緒';

  @override
  String get serverStartingLabel => '傳輸服務啟動中...';

  @override
  String get emptyPeersBody => '附近裝置暫時沒有回應，點擊雷達按鈕重新探測。';

  @override
  String get emptyChatTitle => '選擇一台裝置';

  @override
  String get emptyChatBody => '附近裝置和最近傳輸會話會顯示在這裡。';

  @override
  String get transferIdleTitle => '還沒有傳輸紀錄';

  @override
  String get transferIdleBody => '目前會話已可發起檔案傳輸，輸入檔案路徑即可開始第一個任務。';

  @override
  String get chatIdleTitle => '開始這段會話';

  @override
  String get chatIdleBody => '進入這個裝置會話後會建立 TCP 聊天連線，先傳一條文字或一個檔案試試。';

  @override
  String get chatIdleLabel => '聊天閒置';

  @override
  String get chatConnectingLabel => '聊天連線中';

  @override
  String get chatConnectedLabel => '聊天已連線';

  @override
  String get chatFailedLabel => '聊天連線失敗';

  @override
  String get chatInputHint => '傳送一條文字訊息...';

  @override
  String get sendTextAction => '傳送';

  @override
  String get messageSendFailed => '文字訊息傳送失敗。';

  @override
  String get sendFileAction => '傳送檔案';

  @override
  String get enterPathTitle => '傳送檔案';

  @override
  String get filePathLabel => '本機檔案路徑';

  @override
  String get filePathHint => '/Users/you/Desktop/demo.zip';

  @override
  String get cancelAction => '取消';

  @override
  String get pathRequiredMessage => '請輸入有效的本機檔案路徑。';

  @override
  String get sendQueuedMessage => '傳輸任務已加入佇列。';

  @override
  String get statusQueued => '排隊中';

  @override
  String get statusConnecting => '連線中';

  @override
  String get statusSending => '傳送中';

  @override
  String get statusReceiving => '接收中';

  @override
  String get statusDone => '已完成';

  @override
  String get statusFailed => '已失敗';

  @override
  String get speedShortLabel => '速度';

  @override
  String get etaShortLabel => '剩餘';

  @override
  String get liveUpdateOpenComposerAction => '發送通知';

  @override
  String get liveUpdatePageTitle => '通知編輯器';

  @override
  String get liveUpdatePageSubtitle =>
      '自訂 Live Update 內容並直接送到 Android 原生通知橋接層。';

  @override
  String get liveUpdateStyleSectionTitle => '通知樣式';

  @override
  String get liveUpdateStyleBigText => 'BigTextStyle';

  @override
  String get liveUpdateStyleCall => 'CallStyle';

  @override
  String get liveUpdateStyleProgress => 'ProgressStyle';

  @override
  String get liveUpdateStyleMetric => 'MetricStyle';

  @override
  String get liveUpdateStyleBigTextHint => '適合長正文的展開文字通知。';

  @override
  String get liveUpdateStyleCallHint => '適合來電、通話中、篩查中的通話卡片樣式。';

  @override
  String get liveUpdateStyleProgressHint => '進度條樣式，不支援的 Android 版本會自動降級。';

  @override
  String get liveUpdateStyleMetricHint => '指標卡片樣式，不支援的 Android 版本會自動降級。';

  @override
  String get liveUpdateTitleLabel => '標題';

  @override
  String get liveUpdateBodyLabel => '正文';

  @override
  String get liveUpdateSubTextLabel => '副標題';

  @override
  String get liveUpdateCallPersonLabel => '來電人';

  @override
  String get liveUpdateCallBodyLabel => '通話說明';

  @override
  String get liveUpdateCallVerificationLabel => '校驗文字';

  @override
  String get liveUpdateCallTypeSectionTitle => '通話類型';

  @override
  String get liveUpdateCallTypeIncoming => '來電';

  @override
  String get liveUpdateCallTypeOngoing => '通話中';

  @override
  String get liveUpdateCallTypeScreening => '篩查中';

  @override
  String get liveUpdateCallVideoLabel => '視訊通話';

  @override
  String get liveUpdateCallBodyFallback => '通話進行中';

  @override
  String get liveUpdateMetricBodyLabel => '摘要';

  @override
  String get liveUpdateMetricPrimaryTitle => '主指標';

  @override
  String get liveUpdateMetricSecondaryTitle => '次指標';

  @override
  String get liveUpdateMetricTertiaryTitle => '第三指標';

  @override
  String get liveUpdateMetricLabelField => '指標名稱';

  @override
  String get liveUpdateMetricValueField => '指標值';

  @override
  String get liveUpdateMetricBodyFallback => '指標更新';

  @override
  String get liveUpdateMetricPairIncomplete => '可選指標必須同時填寫名稱和值。';

  @override
  String get liveUpdateShortCriticalTextLabel => '短文字';

  @override
  String get liveUpdateProgressLabel => '進度';

  @override
  String get liveUpdateProgressHint => '輸入 0 到 100 的整數';

  @override
  String liveUpdateFieldRequired(Object fieldLabel) {
    return '請輸入$fieldLabel';
  }

  @override
  String get liveUpdateProgressRequired => '請輸入進度值';

  @override
  String get liveUpdateProgressInvalid => '進度必須是 0 到 100 的整數';

  @override
  String get liveUpdateSendAction => '發送 Live Update';

  @override
  String get liveUpdateToastSuccess => '通知已更新';

  @override
  String get liveUpdateShortTextRefreshLabel => '短文字刷新時間';

  @override
  String get liveUpdateShortTextRefreshHint => '透過滑動條設定短文字輪播間隔，範圍 1 到 10 秒。';

  @override
  String liveUpdateShortTextRefreshValue(Object seconds) {
    return '$seconds 秒';
  }

  @override
  String get liveUpdateShortTextPreviewTitle => '短文字預覽';

  @override
  String get liveUpdateShortTextPreviewEmpty => '輸入短文字後，這裡會預覽它將如何被斷句並輪換顯示。';
}
