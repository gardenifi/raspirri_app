import 'package:flutter/material.dart';
import 'package:new_gardenifi_app/src/common_widgets/gardenifi_logo.dart';
import 'package:new_gardenifi_app/src/common_widgets/menu_button.dart';

class ScreenUpperPortrait extends StatelessWidget {
  const ScreenUpperPortrait({
    super.key,
    required this.radius,
    required this.showMenuButton,
    required this.showLogo,
    this.showAddRemoveMenu = false,
    this.showInitializeMenu = false,
    this.showRebootMenu = false,
    this.showUpdateMenu = false,
    this.messageWidget,
  });

  final double radius;
  final Widget? messageWidget;
  final bool showMenuButton;
  final bool? showAddRemoveMenu;
  final bool? showInitializeMenu;
  final bool? showRebootMenu;
  final bool? showUpdateMenu;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius,
      child: Stack(children: [
        Positioned(
          left: -radius / 1.5,
          top: -10,
          child: Container(
            width: radius,
            height: radius,
            decoration: const ShapeDecoration(
              color: Color(0x840C9823),
              shape: OvalBorder(),
            ),
          ),
        ),
        Positioned(
          left: -50,
          top: -radius / 2,
          child: Container(
            width: radius,
            height: radius,
            decoration: const ShapeDecoration(
              color: Color(0x840C9823),
              shape: OvalBorder(),
            ),
          ),
        ),
        if (showMenuButton)
          Positioned(
            right: 10,
            top: 30,
            child: MoreMenuButton(
              addRemoveValves: showAddRemoveMenu,
              initialize: showInitializeMenu,
              reboot: showRebootMenu,
              update: showUpdateMenu,
            ),
          ),
        if (messageWidget != null) messageWidget!,
        if (showLogo)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: GardenifiLogo(
                height: radius,
                divider: 4,
              ),
            ),
          )
      ]),
    );
  }
}
