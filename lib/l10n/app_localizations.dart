import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'kxs'**
  String get appTitle;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navPods.
  ///
  /// In en, this message translates to:
  /// **'Pods'**
  String get navPods;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @navNodes.
  ///
  /// In en, this message translates to:
  /// **'Nodes'**
  String get navNodes;

  /// No description provided for @dashboardClusterOverview.
  ///
  /// In en, this message translates to:
  /// **'Cluster Overview'**
  String get dashboardClusterOverview;

  /// No description provided for @dashboardServicesTodo.
  ///
  /// In en, this message translates to:
  /// **'Services View (ToDo)'**
  String get dashboardServicesTodo;

  /// No description provided for @podDetailsYaml.
  ///
  /// In en, this message translates to:
  /// **'YAML'**
  String get podDetailsYaml;

  /// No description provided for @podDetailsLogs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get podDetailsLogs;

  /// No description provided for @aiAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis'**
  String get aiAnalysisTitle;

  /// No description provided for @aiOptimizationTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Optimization'**
  String get aiOptimizationTitle;

  /// No description provided for @btnAnalyzeLogs.
  ///
  /// In en, this message translates to:
  /// **'Analyze Logs'**
  String get btnAnalyzeLogs;

  /// No description provided for @btnOptimizeYaml.
  ///
  /// In en, this message translates to:
  /// **'Optimize YAML'**
  String get btnOptimizeYaml;

  /// No description provided for @btnConfigApiKey.
  ///
  /// In en, this message translates to:
  /// **'Config API Key'**
  String get btnConfigApiKey;

  /// No description provided for @dialogConfigOpenAi.
  ///
  /// In en, this message translates to:
  /// **'Configure OpenAI'**
  String get dialogConfigOpenAi;

  /// No description provided for @labelApiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get labelApiKey;

  /// No description provided for @btnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnCancel;

  /// No description provided for @btnSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get btnSave;

  /// No description provided for @aiProviderComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Support for other AI providers coming soon'**
  String get aiProviderComingSoon;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select a cluster to connect'**
  String get dashboardSubtitle;

  /// No description provided for @noKubeconfigs.
  ///
  /// In en, this message translates to:
  /// **'No kubeconfig files found'**
  String get noKubeconfigs;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get languageChinese;

  /// No description provided for @importKubeconfig.
  ///
  /// In en, this message translates to:
  /// **'Import Kubeconfig'**
  String get importKubeconfig;

  /// No description provided for @importFromFile.
  ///
  /// In en, this message translates to:
  /// **'Import from File'**
  String get importFromFile;

  /// No description provided for @editKubeconfig.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editKubeconfig;

  /// No description provided for @deleteKubeconfig.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteKubeconfig;

  /// No description provided for @copyKubeconfig.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyKubeconfig;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this kubeconfig?'**
  String get deleteConfirmMessage;

  /// No description provided for @kubeconfigName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get kubeconfigName;

  /// No description provided for @kubeconfigContext.
  ///
  /// In en, this message translates to:
  /// **'Context'**
  String get kubeconfigContext;

  /// No description provided for @kubeconfigCluster.
  ///
  /// In en, this message translates to:
  /// **'Cluster'**
  String get kubeconfigCluster;

  /// No description provided for @kubeconfigUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get kubeconfigUser;

  /// No description provided for @kubeconfigNamespace.
  ///
  /// In en, this message translates to:
  /// **'Namespace'**
  String get kubeconfigNamespace;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @labelBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get labelBaseUrl;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
