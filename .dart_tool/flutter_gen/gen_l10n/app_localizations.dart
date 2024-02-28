import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_el.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('el'),
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'RaspirriV1'**
  String get appTitle;

  /// The full name of the author
  ///
  /// In en, this message translates to:
  /// **'Tom Makrodimos'**
  String get fullName;

  /// No description provided for @welcomeText.
  ///
  /// In en, this message translates to:
  /// **'Welcome\nto automatic irrigation system'**
  String get welcomeText;

  /// No description provided for @okLabel.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get okLabel;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @yesLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesLabel;

  /// No description provided for @addRemoveButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Add/Remove valves'**
  String get addRemoveButtonLabel;

  /// No description provided for @initializeButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Initialize IoT device'**
  String get initializeButtonLabel;

  /// No description provided for @initializeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Initialize'**
  String get initializeDialogTitle;

  /// No description provided for @initializeDialogPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to initialze the IoT device'**
  String get initializeDialogPrompt;

  /// No description provided for @rebootButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reboot IoT device'**
  String get rebootButtonLabel;

  /// No description provided for @rebootDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Reboot IoT device'**
  String get rebootDialogTitle;

  /// No description provided for @rebootDialogPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reboot IoT device? Your programs will not be lost'**
  String get rebootDialogPrompt;

  /// No description provided for @rebootSnackbarContent.
  ///
  /// In en, this message translates to:
  /// **'IoT will reboot now!'**
  String get rebootSnackbarContent;

  /// No description provided for @updateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update server'**
  String get updateTitle;

  /// No description provided for @updateDialogPrompt.
  ///
  /// In en, this message translates to:
  /// **'You will update the server of IoT device. Your programs will not be lost.'**
  String get updateDialogPrompt;

  /// No description provided for @updateSnackbarContent.
  ///
  /// In en, this message translates to:
  /// **'IoT device will udate the server now!'**
  String get updateSnackbarContent;

  /// No description provided for @aboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutLabel;

  /// No description provided for @exitButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitButtonLabel;

  /// No description provided for @exitDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitDialogTitle;

  /// No description provided for @exitDialogPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the app?'**
  String get exitDialogPrompt;

  /// No description provided for @noBluetoothPrompt.
  ///
  /// In en, this message translates to:
  /// **'App require bluetooth to be turned on'**
  String get noBluetoothPrompt;

  /// No description provided for @noBluetoothAction.
  ///
  /// In en, this message translates to:
  /// **'Turn on Bluetooth'**
  String get noBluetoothAction;

  /// No description provided for @goToWifiSetupScreenText.
  ///
  /// In en, this message translates to:
  /// **'Press Continue to go to WiFi setup screen'**
  String get goToWifiSetupScreenText;

  /// No description provided for @continueButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButtonLabel;

  /// No description provided for @searchingDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Searching IoT device...'**
  String get searchingDeviceTitle;

  /// No description provided for @searchingDeviceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please hold your phone near IoT device'**
  String get searchingDeviceSubtitle;

  /// No description provided for @connectingDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connectingDeviceTitle;

  /// No description provided for @connectingDeviceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please hold your phone near IoT device'**
  String get connectingDeviceSubtitle;

  /// No description provided for @bluetoothConnectionPrompt.
  ///
  /// In en, this message translates to:
  /// **'Before continue you must configure the IoT device via bluetooth connection'**
  String get bluetoothConnectionPrompt;

  /// No description provided for @bluetoothConnectionButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Connection'**
  String get bluetoothConnectionButtonLabel;

  /// No description provided for @couldNotConnectBluetoothText.
  ///
  /// In en, this message translates to:
  /// **'Could not connect with IoT device\n'**
  String get couldNotConnectBluetoothText;

  /// No description provided for @tryAgainButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgainButtonLabel;

  /// No description provided for @deviceNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'IoT Device not found \nor connection with ΙοΤ device lost'**
  String get deviceNotFoundTitle;

  /// No description provided for @deviceNotFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make sure IoT device is on and try again'**
  String get deviceNotFoundSubtitle;

  /// No description provided for @pairingSuccesfulText.
  ///
  /// In en, this message translates to:
  /// **'Pairing Succesful'**
  String get pairingSuccesfulText;

  /// No description provided for @selectNetworkLabel.
  ///
  /// In en, this message translates to:
  /// **'Select from the list the desired network and then fill in the password'**
  String get selectNetworkLabel;

  /// No description provided for @selectNetworkHintText.
  ///
  /// In en, this message translates to:
  /// **'Select network'**
  String get selectNetworkHintText;

  /// No description provided for @enterPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter the password of network'**
  String get enterPasswordLabel;

  /// No description provided for @connectToNetworkText.
  ///
  /// In en, this message translates to:
  /// **'Press \'Connect\' to connect the ΙοΤ device to the desired network'**
  String get connectToNetworkText;

  /// No description provided for @connectToNetworkButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connectToNetworkButtonLabel;

  /// No description provided for @deviceConnectedText.
  ///
  /// In en, this message translates to:
  /// **'IoT device connected to internet succesfuly'**
  String get deviceConnectedText;

  /// No description provided for @goToMainScreenText.
  ///
  /// In en, this message translates to:
  /// **'You are ready! Press \'Continue\' to go to main screen'**
  String get goToMainScreenText;

  /// No description provided for @deviceCouldNotConnectText.
  ///
  /// In en, this message translates to:
  /// **'IoT device could not connect to internet'**
  String get deviceCouldNotConnectText;

  /// No description provided for @ifProblemPersistText.
  ///
  /// In en, this message translates to:
  /// **'If problem persist go back and check network ssid and password'**
  String get ifProblemPersistText;

  /// No description provided for @goBackButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBackButtonLabel;

  /// No description provided for @somethingWentWrongText.
  ///
  /// In en, this message translates to:
  /// **'Oups ... something went wrong!'**
  String get somethingWentWrongText;

  /// No description provided for @refreshListLabel.
  ///
  /// In en, this message translates to:
  /// **'Refresh list'**
  String get refreshListLabel;

  /// No description provided for @waitWhileConnectingText.
  ///
  /// In en, this message translates to:
  /// **'Please wait while IoT is connecting to internet'**
  String get waitWhileConnectingText;

  /// No description provided for @waitWhileFetchingNetworksText.
  ///
  /// In en, this message translates to:
  /// **'Please wait while fetching networks'**
  String get waitWhileFetchingNetworksText;

  /// No description provided for @cantConnectToBrokerText.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connect to broker.'**
  String get cantConnectToBrokerText;

  /// No description provided for @makeSureYouAreConnectedText.
  ///
  /// In en, this message translates to:
  /// **'Make sure you are connected to internet and try again'**
  String get makeSureYouAreConnectedText;

  /// No description provided for @exitAppText.
  ///
  /// In en, this message translates to:
  /// **'If problem persist, maybe broker is down.Exit the app and try again later.'**
  String get exitAppText;

  /// No description provided for @deviceDisconnectedFromBrokerText.
  ///
  /// In en, this message translates to:
  /// **'IoT device disconnected from broker!'**
  String get deviceDisconnectedFromBrokerText;

  /// No description provided for @makeSureDeviceIsPoweredOnText.
  ///
  /// In en, this message translates to:
  /// **'Make sure IoT device is powered on'**
  String get makeSureDeviceIsPoweredOnText;

  /// No description provided for @connectedToBrokerSnackbarText.
  ///
  /// In en, this message translates to:
  /// **'Connected to broker'**
  String get connectedToBrokerSnackbarText;

  /// No description provided for @disconnectedFromBrokerText.
  ///
  /// In en, this message translates to:
  /// **'Disconnected from broker'**
  String get disconnectedFromBrokerText;

  /// No description provided for @ifProblemPersistOnDisconnectingFromBrokerText.
  ///
  /// In en, this message translates to:
  /// **'If problem persist exit the app and try open it again.'**
  String get ifProblemPersistOnDisconnectingFromBrokerText;

  /// No description provided for @areYouSureDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSureDialogTitle;

  /// No description provided for @changesHaveNotBeenSavedText.
  ///
  /// In en, this message translates to:
  /// **'There are changes that have not been saved. Are you sure you want to go back?'**
  String get changesHaveNotBeenSavedText;

  /// No description provided for @selectDaysToIrrigateText.
  ///
  /// In en, this message translates to:
  /// **'Select the days you want to irrigate'**
  String get selectDaysToIrrigateText;

  /// No description provided for @editCreateProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit/Create program'**
  String get editCreateProgramTitle;

  /// No description provided for @valveIsOnDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Valve is on!'**
  String get valveIsOnDialogTitle;

  /// No description provided for @valveIsOnDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Please turn off valve before remove it from IoT device!'**
  String get valveIsOnDialogContent;

  /// No description provided for @valveDeletionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Valve deletion'**
  String get valveDeletionDialogTitle;

  /// No description provided for @valveDeletionDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this valve? All programs of this valve will be also deleted.'**
  String get valveDeletionDialogContent;

  /// No description provided for @addValveLabel.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addValveLabel;

  /// No description provided for @removeValveLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeValveLabel;

  /// No description provided for @selectStartTimeText.
  ///
  /// In en, this message translates to:
  /// **'Select start time'**
  String get selectStartTimeText;

  /// No description provided for @addIrrigationCycleLabel.
  ///
  /// In en, this message translates to:
  /// **'Add an irrigation cycle'**
  String get addIrrigationCycleLabel;

  /// No description provided for @deleteProgramButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete program'**
  String get deleteProgramButtonLabel;

  /// No description provided for @programDeletionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Program deletion'**
  String get programDeletionDialogTitle;

  /// No description provided for @programDeletionDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this program?'**
  String get programDeletionDialogContent;

  /// No description provided for @saveButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButtonLabel;

  /// No description provided for @cycleDeletionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Cycle deletion'**
  String get cycleDeletionDialogTitle;

  /// No description provided for @cycleDeletionDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this cycle?'**
  String get cycleDeletionDialogContent;

  /// No description provided for @cycleNumber.
  ///
  /// In en, this message translates to:
  /// **'Cycle {number}'**
  String cycleNumber(int number);

  /// No description provided for @startLabel.
  ///
  /// In en, this message translates to:
  /// **'Start: '**
  String get startLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration: '**
  String get durationLabel;

  /// No description provided for @noValveText.
  ///
  /// In en, this message translates to:
  /// **'No valve has been registered.\n'**
  String get noValveText;

  /// No description provided for @plugValveText.
  ///
  /// In en, this message translates to:
  /// **'Plug one or more valves in IoT device and select the port number from the button below to enable them.'**
  String get plugValveText;

  /// No description provided for @addValvesButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Add valves'**
  String get addValvesButtonLabel;

  /// No description provided for @addRemoveValveBottomSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add/Remove valves'**
  String get addRemoveValveBottomSheetTitle;

  /// No description provided for @doneButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButtonLabel;

  /// No description provided for @selectDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Select duration'**
  String get selectDurationTitle;

  /// No description provided for @valveNumber.
  ///
  /// In en, this message translates to:
  /// **'Valve {number}'**
  String valveNumber(int number);

  /// No description provided for @closesAtText.
  ///
  /// In en, this message translates to:
  /// **'Closes at {endTime}'**
  String closesAtText(String endTime);

  /// No description provided for @nextRunText.
  ///
  /// In en, this message translates to:
  /// **'Next run: '**
  String get nextRunText;

  /// No description provided for @noProgramText.
  ///
  /// In en, this message translates to:
  /// **'No program'**
  String get noProgramText;

  /// No description provided for @programSendSnackbarText.
  ///
  /// In en, this message translates to:
  /// **'Program send to broker'**
  String get programSendSnackbarText;

  /// No description provided for @programCouldNotSendSnackbarText.
  ///
  /// In en, this message translates to:
  /// **'Could not send program to broker. Try again'**
  String get programCouldNotSendSnackbarText;

  /// No description provided for @programDeletedSnackbarText.
  ///
  /// In en, this message translates to:
  /// **'Program deleted'**
  String get programDeletedSnackbarText;

  /// No description provided for @createProgramText.
  ///
  /// In en, this message translates to:
  /// **'Create program'**
  String get createProgramText;

  /// No description provided for @viewEditProgramText.
  ///
  /// In en, this message translates to:
  /// **'View/Edit program'**
  String get viewEditProgramText;

  /// No description provided for @collapseButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Collapse all'**
  String get collapseButtonLabel;

  /// No description provided for @expandButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Expand all'**
  String get expandButtonLabel;

  /// No description provided for @nextRunTodayAtText.
  ///
  /// In en, this message translates to:
  /// **'Today {time}'**
  String nextRunTodayAtText(String time);

  /// No description provided for @nextRunDayAtText.
  ///
  /// In en, this message translates to:
  /// **'Next {day} {time}'**
  String nextRunDayAtText(String time, String day);

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'{day, select, Mon{Mon} Tue{Tue} Wed{Wed} Thu{Thu} Fri{Fri} Sat{Sat} Sun{Sun} other{_}}'**
  String day(String day);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['el', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
