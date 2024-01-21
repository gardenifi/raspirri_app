import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/utils.dart';

import 'src/root_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // A variable that hold true if device has been initialized before
  bool? isRaspiInitialized = await checkInitializationStatus();
  runApp(ProviderScope(
    child: RootApp(deviceHasBeenInitialized: isRaspiInitialized),
  ));
}
