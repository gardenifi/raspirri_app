import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'RaspirriV1';

  @override
  String get fullName => 'Θωμάς Μακροδήμος';

  @override
  String get welcomeText => 'Καλώς ήρθατε\nστο αυτόματο σύστημα ποτίσματος';

  @override
  String get okLabel => 'Oκ';

  @override
  String get cancelLabel => 'Ακύρωση';

  @override
  String get yesLabel => 'Ναι';

  @override
  String get addRemoveButtonLabel => 'Διαχείριση βανών';

  @override
  String get initializeButtonLabel => 'Αρχικοποίηση IoT συσκευής';

  @override
  String get initializeDialogTitle => 'Αρχικοποίηση';

  @override
  String get initializeDialogPrompt => 'Είστε σίγουρος ότι θέλετε να αρχικοποιήσετε την IoT συσκευή;';

  @override
  String get rebootButtonLabel => 'Επανεκκίνηση IoT συσκευής';

  @override
  String get rebootDialogTitle => 'Επανεκκίνηση';

  @override
  String get rebootDialogPrompt => 'Είστε σίγουρος ότι θέλετε να επανεκκινήσετε την IoT συσκευή; Τα προγράμματα των βανών δεν θα χαθούν.';

  @override
  String get rebootSnackbarContent => 'Η IoT συσκευή Θα επανεκκινήση τώρα!';

  @override
  String get updateTitle => 'Ενημέρωση σέρβερ';

  @override
  String get updateDialogPrompt => 'Θα γίνει ενημέρωση του σέρβερ της IoT συσκευής. Τα προγράμματα των βανών δεν θα χαθούν.';

  @override
  String get updateSnackbarContent => 'Ο σέρβερ της IoT συσκευής θα ενημερωθεί τώρα!';

  @override
  String get aboutLabel => 'Σχετικά';

  @override
  String get exitButtonLabel => 'Έξοδος';

  @override
  String get exitDialogTitle => 'Έξοδος';

  @override
  String get exitDialogPrompt => 'Είστε σίγουρος ότι θέλετε να κλείσετε την εφαρμογή;';

  @override
  String get noBluetoothPrompt => 'Για την λειτουργία της εφαρμογής είναι απαραίτητη η ενεργοποίηση του bluetooth';

  @override
  String get noBluetoothAction => 'Ενεργοποίηση Bluetooth';

  @override
  String get goToWifiSetupScreenText => 'Πατήστε \'Συνέχεια\' για να μεταβείτε στην οθόνη ρύθμισης WiFi';

  @override
  String get continueButtonLabel => 'Συνέχεια';

  @override
  String get searchingDeviceTitle => 'Αναζήτηση συσκευής IoT...';

  @override
  String get searchingDeviceSubtitle => 'Κρατήστε το τηλέφωνό σας κοντά στη συσκευή IoT';

  @override
  String get connectingDeviceTitle => 'Σύνδεση...';

  @override
  String get connectingDeviceSubtitle => 'Κρατήστε το τηλέφωνό σας κοντά στη συσκευή IoT';

  @override
  String get bluetoothConnectionPrompt => 'Πριν συνεχίσετε πρέπει να γίνει ρύθμιση της συσκευής ΙοΤ μέσω σύνδεσης Bluetooth';

  @override
  String get bluetoothConnectionButtonLabel => 'Σύνδεση Bluettooth';

  @override
  String get couldNotConnectBluetoothText => 'Δεν ήταν δυνατή η σύνδεση με την ΙοΤ συσκευή\n';

  @override
  String get tryAgainButtonLabel => 'Προσπαθήστε ξανά';

  @override
  String get deviceNotFoundTitle => 'Η ΙοΤ συσκευή δεν βρέθηκε\nή η σύνδεση διακόπηκε';

  @override
  String get deviceNotFoundSubtitle => 'Βεβαιωθήτε ότι η ΙοΤ συσκευή είναι ενεργοποιημένη και προσπαθήστε ξανά';

  @override
  String get pairingSuccesfulText => 'Επιτυχής σύνδεση!';

  @override
  String get selectNetworkLabel => 'Επιλέξτε από την λίστα το επιθυμητό δίκτυο και εισάγετε τον κωδικό';

  @override
  String get selectNetworkHintText => 'Επιλέξτε δίκτυο';

  @override
  String get enterPasswordLabel => 'Εισάγετε τον κωδικό του δικτύου';

  @override
  String get connectToNetworkText => 'Πατήστε \'Σύνδεση\' για να συνδέσετε την συσκευή ΙοΤ στο δίκτυο';

  @override
  String get connectToNetworkButtonLabel => 'Σύνδεση';

  @override
  String get deviceConnectedText => 'Η συσκευή ΙοΤ συνδέθηκε στο ίντερνετ επιτυχώς!';

  @override
  String get goToMainScreenText => 'Είστε έτοιμος! Πατήστε \'Συνέχεια\' για να μεταβείτε στην κύρια οθόνη';

  @override
  String get deviceCouldNotConnectText => 'Η συσκευή IoT δεν μπόρεσε να συνδεθεί στο διαδύκτιο. Δοκιμάστε ξανά';

  @override
  String get ifProblemPersistText => 'Αν το πρόβλημα συνεχίζει, πάτε πίσω και ελέγξτε το ssid και τον κωδικό δικτύου';

  @override
  String get goBackButtonLabel => 'Πίσω';

  @override
  String get somethingWentWrongText => 'Ουπς... κάτι δεν πήγε καλά!';

  @override
  String get refreshListLabel => 'Ανανέωση λίστας';

  @override
  String get waitWhileConnectingText => 'Παρακαλώ περιμένετε όσο η συσκευή ΙοΤ συνδέεται στο διαδύκτιο';

  @override
  String get waitWhileFetchingNetworksText => 'Παρακαλώ περιμένετε όσο γίνεται ανάκτηση των δικτύων';

  @override
  String get cantConnectToBrokerText => 'Αδυναμία σύνδεσης στον διακομιστή';

  @override
  String get makeSureYouAreConnectedText => 'Βεβαιωθείτε ότι είστε συνδεδεμένοι στο διαδίκτυο και προσπαθήστε ξανά';

  @override
  String get exitAppText => 'Αν το πρόβλημα συνεχίζει πιθανόν να υπάρχει πρόβλημα στον διακομιστή. Κλείστε την εφαρμογή και δοκιμάστε αργότερα.';

  @override
  String get deviceDisconnectedFromBrokerText => 'Η συσκευή ΙοΤ αποσυνδέθηκε από τον διακομιστή';

  @override
  String get makeSureDeviceIsPoweredOnText => 'Βεβαιωθείται ότι η συσκευή ΙοΤ είναι ενεργοποιημένη';

  @override
  String get connectedToBrokerSnackbarText => 'Συνδεθήκατε στον διακομιστή';

  @override
  String get disconnectedFromBrokerText => 'Αποσυνδεθείκατε απο τον διακομιστή';

  @override
  String get ifProblemPersistOnDisconnectingFromBrokerText => 'Αν το πρόβλημα συνεχίζει κλείστε την εφαρμογή και ανοίξτε την ξανά';

  @override
  String get areYouSureDialogTitle => 'Είστε σίγουροι;';

  @override
  String get changesHaveNotBeenSavedText => 'Υπάρχουν αλλαγές που δεν έχουν αποθηκευτεί. Είστε σίγουροι ότι θέλετε να επιστρέψετε;';

  @override
  String get selectDaysToIrrigateText => 'Επιλέξτε τις ημέρες που θέλετε να ποτίσετε';

  @override
  String get editCreateProgramTitle => 'Επεξεργασία/Δημιουργία προγράμματος';

  @override
  String get valveIsOnDialogTitle => 'Η βάνα είναι ανοιχτή!';

  @override
  String get valveIsOnDialogContent => 'Παρακαλώ κλείστε τη βάνα πριν την αφαιρέσετε από τη συσκευή IoT!';

  @override
  String get valveDeletionDialogTitle => 'Διαγραφή βάνας';

  @override
  String get valveDeletionDialogContent => 'Είστε σίγουροι ότι θέλετε να αφαιρέσετε αυτήν τη βάνα; Όλα τα προγράμματα αυτής της βάνας θα διαγραφούν.';

  @override
  String get addValveLabel => 'Προσθήκη';

  @override
  String get removeValveLabel => 'Αφαίρεση';

  @override
  String get selectStartTimeText => 'Επιλογή ώρας έναρξης';

  @override
  String get addIrrigationCycleLabel => 'Προσθήκη κύκλου ποτίσματος';

  @override
  String get deleteProgramButtonLabel => 'Διαγραφή προγράμματος';

  @override
  String get programDeletionDialogTitle => 'Διαγραφή προγράμματος';

  @override
  String get programDeletionDialogContent => 'Είστε βέβαιοι ότι θέλετε να διαγράψετε αυτό το πρόγραμμα;';

  @override
  String get saveButtonLabel => 'Αποθήκευση';

  @override
  String get cycleDeletionDialogTitle => 'Διαγραφή κύκλου';

  @override
  String get cycleDeletionDialogContent => 'Είστε σίγουροι ότι θέλετε να διαγράψετε αυτό το κύκλο ποτίσματος;';

  @override
  String cycleNumber(int number) {
    return 'Κύκλος $number';
  }

  @override
  String get startLabel => 'Έναρξη: ';

  @override
  String get durationLabel => 'Διάρκεια: ';

  @override
  String get noValveText => 'Δεν έχει προστεθεί βάνα.\n';

  @override
  String get plugValveText => 'Συνδέστε μία ή περισσότερες βάνες στην συσκευή IoT και προσθέστε την αντίστοιχη είσοδο πατώντας το παρακάτω κουμπί';

  @override
  String get addValvesButtonLabel => 'Προσθήκη βάνας';

  @override
  String get addRemoveValveBottomSheetTitle => 'Προσθήκη/Αφαίρεση βανών';

  @override
  String get doneButtonLabel => 'Τέλος';

  @override
  String get selectDurationTitle => 'Επιλογή διάρκειας';

  @override
  String valveNumber(int number) {
    return 'Βάνα $number';
  }

  @override
  String closesAtText(String endTime) {
    return 'Κλείνει $endTime';
  }

  @override
  String get nextRunText => 'Επόμενο άνοιγμα: ';

  @override
  String get noProgramText => 'Δεν υπάρχει πρόγραμμα';

  @override
  String get programSendSnackbarText => 'Το πρόγραμμα στάλθηκε στον διακομιστή';

  @override
  String get programCouldNotSendSnackbarText => 'Αποτυχία αποστολής προγράμματος στον διακομιστή. Προσπαθείστε ξανά';

  @override
  String get programDeletedSnackbarText => 'Το πρόγραμμα διαγράφηκε';

  @override
  String get createProgramText => 'Δημιουργία προγράμματος';

  @override
  String get viewEditProgramText => 'Προβολή/Επεξεργασία προγράμματος';

  @override
  String get collapseButtonLabel => 'Σύμπτυξη όλων';

  @override
  String get expandButtonLabel => 'Ανάπτυξη όλων';

  @override
  String nextRunTodayAtText(String time) {
    return 'Σήμερα $time';
  }

  @override
  String nextRunDayAtText(String time, String day) {
    return '$day $time';
  }

  @override
  String day(String day) {
    String _temp0 = intl.Intl.selectLogic(
      day,
      {
        'Mon': 'Δευ',
        'Tue': 'Τρι',
        'Wed': 'Τετ',
        'Thu': 'Πεμ',
        'Fri': 'Παρ',
        'Sat': 'Σαβ',
        'Sun': 'Κυρ',
        'other': '_',
      },
    );
    return '$_temp0';
  }
}
