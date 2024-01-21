import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class RefreshNetworksButton extends ConsumerWidget {
  const RefreshNetworksButton({
    super.key,
    required this.callback,
  });

  final Function() callback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = ref.read(appLocalizationsProvider);
    return TextButton.icon(
      label: Text(loc.refreshListLabel),
      // Refresh the provider and rebuild widget
      onPressed: callback,
      icon: const Icon(
        Icons.refresh,
        color: Colors.green,
      ),
    );
  }
}
