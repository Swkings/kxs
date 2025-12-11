// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'kxs';

  @override
  String get navOverview => '概览';

  @override
  String get navPods => '容器组';

  @override
  String get navServices => '服务';

  @override
  String get navNodes => '节点';

  @override
  String get dashboardClusterOverview => '集群概览';

  @override
  String get dashboardServicesTodo => '服务视图 (待办)';

  @override
  String get podDetailsYaml => 'YAML';

  @override
  String get podDetailsLogs => '日志';

  @override
  String get aiAnalysisTitle => 'AI 分析';

  @override
  String get aiOptimizationTitle => 'AI 优化';

  @override
  String get btnAnalyzeLogs => '分析日志';

  @override
  String get btnOptimizeYaml => '优化 YAML';

  @override
  String get btnConfigApiKey => '配置 API Key';

  @override
  String get dialogConfigOpenAi => '配置 OpenAI';

  @override
  String get labelApiKey => 'API 密钥';

  @override
  String get btnCancel => '取消';

  @override
  String get btnSave => '保存';

  @override
  String get aiProviderComingSoon => '其他 AI 提供商即将支持';

  @override
  String get dashboardTitle => '仪表板';

  @override
  String get dashboardSubtitle => '选择一个集群连接';

  @override
  String get noKubeconfigs => '未找到 kubeconfig 文件';

  @override
  String get themeLight => '浅色主题';

  @override
  String get themeDark => '深色主题';

  @override
  String get language => '语言';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '简体中文';

  @override
  String get importKubeconfig => '导入 Kubeconfig';

  @override
  String get importFromFile => '从文件导入';

  @override
  String get editKubeconfig => '编辑';

  @override
  String get deleteKubeconfig => '删除';

  @override
  String get copyKubeconfig => '复制';

  @override
  String get confirmDelete => '确认删除';

  @override
  String get deleteConfirmMessage => '确定要删除此 kubeconfig 吗？';

  @override
  String get kubeconfigName => '名称';

  @override
  String get kubeconfigContext => '上下文';

  @override
  String get kubeconfigCluster => '集群';

  @override
  String get kubeconfigUser => '用户';

  @override
  String get kubeconfigNamespace => '命名空间';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get labelBaseUrl => '基础 URL';
}
