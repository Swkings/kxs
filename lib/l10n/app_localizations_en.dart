// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'kxs';

  @override
  String get navOverview => 'Overview';

  @override
  String get navPods => 'Pods';

  @override
  String get navServices => 'Services';

  @override
  String get navNodes => 'Nodes';

  @override
  String get dashboardClusterOverview => 'Cluster Overview';

  @override
  String get dashboardServicesTodo => 'Services View (ToDo)';

  @override
  String get podDetailsYaml => 'YAML';

  @override
  String get podDetailsLogs => 'Logs';

  @override
  String get aiAnalysisTitle => 'AI Analysis';

  @override
  String get aiOptimizationTitle => 'AI Optimization';

  @override
  String get btnAnalyzeLogs => 'Analyze Logs';

  @override
  String get btnOptimizeYaml => 'Optimize YAML';

  @override
  String get btnConfigApiKey => 'Config API Key';

  @override
  String get dialogConfigOpenAi => 'Configure OpenAI';

  @override
  String get labelApiKey => 'API Key';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnSave => 'Save';

  @override
  String get aiProviderComingSoon =>
      'Support for other AI providers coming soon';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardSubtitle => 'Select a cluster to connect';

  @override
  String get noKubeconfigs => 'No kubeconfig files found';

  @override
  String get themeLight => 'Light Theme';

  @override
  String get themeDark => 'Dark Theme';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '简体中文';

  @override
  String get importKubeconfig => 'Import Kubeconfig';

  @override
  String get importFromFile => 'Import from File';

  @override
  String get editKubeconfig => 'Edit';

  @override
  String get deleteKubeconfig => 'Delete';

  @override
  String get copyKubeconfig => 'Copy';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteConfirmMessage =>
      'Are you sure you want to delete this kubeconfig?';

  @override
  String get kubeconfigName => 'Name';

  @override
  String get kubeconfigContext => 'Context';

  @override
  String get kubeconfigCluster => 'Cluster';

  @override
  String get kubeconfigUser => 'User';

  @override
  String get kubeconfigNamespace => 'Namespace';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get labelBaseUrl => 'Base URL';
}
