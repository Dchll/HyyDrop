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
}
