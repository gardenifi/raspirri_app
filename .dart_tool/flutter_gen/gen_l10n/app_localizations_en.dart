import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'RaspirriV1';

  @override
  String get fullName => 'Tom Makrodimos';

  @override
  String get welcomeText => 'Welcome\nto automatic irrigation system';

  @override
  String get okLabel => 'Ok';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get yesLabel => 'Yes';

  @override
  String get addRemoveButtonLabel => 'Add/Remove valves';

  @override
  String get initializeButtonLabel => 'Initialize IoT device';

  @override
  String get initializeDialogTitle => 'Initialize';

  @override
  String get initializeDialogPrompt => 'Are you sure you want to initialze the IoT device';

  @override
  String get rebootButtonLabel => 'Reboot IoT device';

  @override
  String get rebootDialogTitle => 'Reboot IoT device';

  @override
  String get rebootDialogPrompt => 'Are you sure you want to reboot IoT device? Your programs will not be lost';

  @override
  String get rebootSnackbarContent => 'IoT will reboot now!';

  @override
  String get updateTitle => 'Update server';

  @override
  String get updateDialogPrompt => 'You will update the server of IoT device. Your programs will not be lost.';

  @override
  String get updateSnackbarContent => 'IoT device will udate the server now!';

  @override
  String get aboutLabel => 'About';

  @override
  String get exitButtonLabel => 'Exit';

  @override
  String get exitDialogTitle => 'Exit';

  @override
  String get exitDialogPrompt => 'Are you sure you want to exit the app?';

  @override
  String get noBluetoothPrompt => 'App require bluetooth to be turned on';

  @override
  String get noBluetoothAction => 'Turn on Bluetooth';

  @override
  String get goToWifiSetupScreenText => 'Press Continue to go to WiFi setup screen';

  @override
  String get continueButtonLabel => 'Continue';

  @override
  String get searchingDeviceTitle => 'Searching IoT device...';

  @override
  String get searchingDeviceSubtitle => 'Please hold your phone near IoT device';

  @override
  String get connectingDeviceTitle => 'Connecting...';

  @override
  String get connectingDeviceSubtitle => 'Please hold your phone near IoT device';

  @override
  String get bluetoothConnectionPrompt => 'Before continue you must configure the IoT device via bluetooth connection';

  @override
  String get bluetoothConnectionButtonLabel => 'Bluetooth Connection';

  @override
  String get couldNotConnectBluetoothText => 'Could not connect with IoT device\n';

  @override
  String get tryAgainButtonLabel => 'Try again';

  @override
  String get deviceNotFoundTitle => 'IoT Device not found \nor connection with ΙοΤ device lost';

  @override
  String get deviceNotFoundSubtitle => 'Make sure IoT device is on and try again';

  @override
  String get pairingSuccesfulText => 'Pairing Succesful';

  @override
  String get selectNetworkLabel => 'Select from the list the desired network and then fill in the password';

  @override
  String get selectNetworkHintText => 'Select network';

  @override
  String get enterPasswordLabel => 'Enter the password of network';

  @override
  String get connectToNetworkText => 'Press \'Connect\' to connect the ΙοΤ device to the desired network';

  @override
  String get connectToNetworkButtonLabel => 'Connect';

  @override
  String get deviceConnectedText => 'IoT device connected to internet succesfuly';

  @override
  String get goToMainScreenText => 'You are ready! Press \'Continue\' to go to main screen';

  @override
  String get deviceCouldNotConnectText => 'IoT device could not connect to internet';

  @override
  String get ifProblemPersistText => 'If problem persist go back and check network ssid and password';

  @override
  String get goBackButtonLabel => 'Go back';

  @override
  String get somethingWentWrongText => 'Oups ... something went wrong!';

  @override
  String get refreshListLabel => 'Refresh list';

  @override
  String get waitWhileConnectingText => 'Please wait while IoT is connecting to internet';

  @override
  String get waitWhileFetchingNetworksText => 'Please wait while fetching networks';

  @override
  String get cantConnectToBrokerText => 'Can\'t connect to broker.';

  @override
  String get makeSureYouAreConnectedText => 'Make sure you are connected to internet and try again';

  @override
  String get exitAppText => 'If problem persist, maybe broker is down.Exit the app and try again later.';

  @override
  String get deviceDisconnectedFromBrokerText => 'IoT device disconnected from broker!';

  @override
  String get makeSureDeviceIsPoweredOnText => 'Make sure IoT device is powered on';

  @override
  String get connectedToBrokerSnackbarText => 'Connected to broker';

  @override
  String get disconnectedFromBrokerText => 'Disconnected from broker';

  @override
  String get ifProblemPersistOnDisconnectingFromBrokerText => 'If problem persist exit the app and try open it again.';

  @override
  String get areYouSureDialogTitle => 'Are you sure?';

  @override
  String get changesHaveNotBeenSavedText => 'There are changes that have not been saved. Are you sure you want to go back?';

  @override
  String get selectDaysToIrrigateText => 'Select the days you want to irrigate';

  @override
  String get editCreateProgramTitle => 'Edit/Create program';

  @override
  String get valveIsOnDialogTitle => 'Valve is on!';

  @override
  String get valveIsOnDialogContent => 'Please turn off valve before remove it from IoT device!';

  @override
  String get valveDeletionDialogTitle => 'Valve deletion';

  @override
  String get valveDeletionDialogContent => 'Are you sure you want to remove this valve? All programs of this valve will be also deleted.';

  @override
  String get addValveLabel => 'Add';

  @override
  String get removeValveLabel => 'Remove';

  @override
  String get selectStartTimeText => 'Select start time';

  @override
  String get addIrrigationCycleLabel => 'Add an irrigation cycle';

  @override
  String get deleteProgramButtonLabel => 'Delete program';

  @override
  String get programDeletionDialogTitle => 'Program deletion';

  @override
  String get programDeletionDialogContent => 'Are you sure you want to delete this program?';

  @override
  String get saveButtonLabel => 'Save';

  @override
  String get cycleDeletionDialogTitle => 'Cycle deletion';

  @override
  String get cycleDeletionDialogContent => 'Are you sure you want to delete this cycle?';

  @override
  String cycleNumber(int number) {
    return 'Cycle $number';
  }

  @override
  String get startLabel => 'Start: ';

  @override
  String get durationLabel => 'Duration: ';

  @override
  String get noValveText => 'No valve has been registered.\n';

  @override
  String get plugValveText => 'Plug one or more valves in IoT device and select the port number from the button below to enable them.';

  @override
  String get addValvesButtonLabel => 'Add valves';

  @override
  String get addRemoveValveBottomSheetTitle => 'Add/Remove valves';

  @override
  String get doneButtonLabel => 'Done';

  @override
  String get selectDurationTitle => 'Select duration';

  @override
  String valveNumber(int number) {
    return 'Valve $number';
  }

  @override
  String closesAtText(String endTime) {
    return 'Closes at $endTime';
  }

  @override
  String get nextRunText => 'Next run: ';

  @override
  String get noProgramText => 'No program';

  @override
  String get programSendSnackbarText => 'Program send to broker';

  @override
  String get programCouldNotSendSnackbarText => 'Could not send program to broker. Try again';

  @override
  String get programDeletedSnackbarText => 'Program deleted';

  @override
  String get createProgramText => 'Create program';

  @override
  String get viewEditProgramText => 'View/Edit program';

  @override
  String get collapseButtonLabel => 'Collapse all';

  @override
  String get expandButtonLabel => 'Expand all';

  @override
  String nextRunTodayAtText(String time) {
    return 'Today $time';
  }

  @override
  String nextRunDayAtText(String time, String day) {
    return 'Next $day $time';
  }

  @override
  String day(String day) {
    String _temp0 = intl.Intl.selectLogic(
      day,
      {
        'Mon': 'Mon',
        'Tue': 'Tue',
        'Wed': 'Wed',
        'Thu': 'Thu',
        'Fri': 'Fri',
        'Sat': 'Sat',
        'Sun': 'Sun',
        'other': '_',
      },
    );
    return '$_temp0';
  }
}
