// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gardenifi_app/src/common_widgets/alert_dialogs.dart';
import 'package:new_gardenifi_app/src/common_widgets/snackbar.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/about_dialog.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/show_add_remov_bottomsheet.dart';
import 'package:new_gardenifi_app/src/localization/app_localizations_provider.dart';

class MoreMenuButton extends ConsumerWidget {
  const MoreMenuButton({
    super.key,
    this.addRemoveValves = false,
    this.initialize = false,
    this.reboot = false,
    this.update = false,
  });

  final bool? addRemoveValves;
  final bool? initialize;
  final bool? reboot;
  final bool? update;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = ref.read(appLocalizationsProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MenuAnchor(
        alignmentOffset: const Offset(-130, 0),
        menuChildren: [
          // Add-Remove Valves
          if (addRemoveValves == true)
            MenuItemButton(
              leadingIcon: Image.asset(
                'assets/icons/valve.png',
                width: 25,
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text(loc.addRemoveButtonLabel),
              onPressed: () {
                ShowAddRemoveBottomSheet.showBottomSheet(context, ref);
              },
            ),

          // Initialize Device
          if (initialize == true)
            MenuItemButton(
              leadingIcon: const Icon(Icons.home_repair_service),
              child: Text(loc.initializeButtonLabel),
              onPressed: () async {
                var res = await showAlertDialog(
                    cancelActionText: loc.cancelLabel,
                    defaultActionText: loc.okLabel,
                    context: context,
                    title: loc.initializeDialogTitle,
                    content: loc.initializeDialogPrompt);
                if (res == true) {
                  Navigator.of(context).popAndPushNamed('welcomeScreen');
                }
              },
            ),

          // Reboot device
          if (reboot == true)
            MenuItemButton(
              leadingIcon: const Icon(Icons.restart_alt),
              onPressed: () async {
                var res = await showAlertDialog(
                    context: context,
                    title: loc.rebootDialogTitle,
                    defaultActionText: loc.okLabel,
                    content: loc.rebootDialogPrompt,
                    cancelActionText: loc.cancelLabel);
                if (res == true) {
                  showSnackbar(context, loc.rebootSnackbarContent);
                  ref.read(mqttControllerProvider.notifier).rebootDevice();
                }
              },
              child: Text(loc.rebootButtonLabel),
            ),

          // Update device
          if (update == true)
            MenuItemButton(
              leadingIcon: const Icon(Icons.system_update_alt),
              onPressed: () async {
                var res = await showAlertDialog(
                    context: context,
                    title: loc.updateTitle,
                    defaultActionText: loc.okLabel,
                    content: loc.updateDialogPrompt,
                    cancelActionText: loc.cancelLabel);
                if (res == true) {
                  showSnackbar(context, loc.updateSnackbarContent);
                  ref.read(mqttControllerProvider.notifier).updateSever();
                }
              },
              child: Text(loc.updateTitle),
            ),
          const Divider(
            endIndent: 30,
            indent: 30,
          ),

          // About
          MenuItemButton(
            leadingIcon: const Icon(Icons.info_outline),
            child: Text(loc.aboutLabel),
            onPressed: () => aboutDialog(context: context, ref: ref),
          ),

          // Exit
          MenuItemButton(
            leadingIcon: const Icon(Icons.exit_to_app),
            child: Text(loc.exitButtonLabel),
            onPressed: () async {
              var res = await showAlertDialog(
                  context: context,
                  title: loc.exitDialogTitle,
                  defaultActionText: loc.okLabel,
                  content: loc.exitDialogPrompt,
                  cancelActionText: loc.cancelLabel);
              if (res == true) {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }
            },
          ),
        ],
        builder: (context, controller, child) => IconButton(
          iconSize: 25,
          color: Colors.black54,
          icon: const Icon(Icons.menu),
          onPressed: () => controller.open(),
        ),
      ),
    );
  }
}
