import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Provider used to access the AppLocalizations object for the current locale
final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  // 1. initialize from the initial locale. If locale does not exist in supported languages, return [Locale('en')] or system's second preferred language if set.
  try {
    ref.state = lookupAppLocalizations(PlatformDispatcher.instance.locale);
  } on FlutterError {
    log('Locale error caught');
    ref.state = lookupAppLocalizations(const Locale('en'));
  }
  // 2. create an observer to update the state
  final observer = _LocaleObserver((locales) {
    try {
    ref.state = lookupAppLocalizations(PlatformDispatcher.instance.locale);
  } on FlutterError {
    log('Locale error caught');
    ref.state = lookupAppLocalizations(const Locale('en'));
  }
  });
  // 3. register the observer and dispose it when no longer needed
  final binding = WidgetsBinding.instance;
  binding.addObserver(observer);
  ref.onDispose(() => binding.removeObserver(observer));
  // 4. return the state
  return ref.state;
});

class _LocaleObserver extends WidgetsBindingObserver {
  _LocaleObserver(this._didChangeLocales);

  final void Function(List<Locale>? locales) _didChangeLocales;

  @override
  void didChangeLocales(List<Locale>? locales) {
    _didChangeLocales(locales);
    super.didChangeLocales(locales);
  }
}
