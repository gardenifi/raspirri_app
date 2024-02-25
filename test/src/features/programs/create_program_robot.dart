import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:new_gardenifi_app/src/features/mqtt/presentation/mqtt_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/cycle.dart';
import 'package:new_gardenifi_app/src/features/programs/domain/program.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/program_controller.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/create_program_screen.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/screens/programs_screen.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/button_add_cycle.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/button_delete_program.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/button_save_program.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/day_button.dart';
import 'package:new_gardenifi_app/src/features/programs/presentation/widgets/days_of_week_widget.dart';

import '../../mocks.dart';
import '../../provider_container.dart';

class CreateProgramRobot {
  CreateProgramRobot(this.tester);
  final WidgetTester tester;
  late ProviderContainer container;

  Future<void> pumpCreateProgramScreen({
    List<Program> config = const [],
    List<DaysOfWeek> days = const [],
    List<DaysOfWeek> selectedDays = const [],
    List<Cycle> cycles = const [],
    bool hasChanged = false,
    bool pumpAndSettle = true,
  }) async {
    // Load 'Roboto' font for testing instead default 'Ahem'
    final roboto = rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);

    await fontLoader.load();

    await tester.pumpWidget(ProviderScope(
        overrides: [
          configTopicProvider.overrideWith((ref) => config),
          daysOfProgramProvider.overrideWith((ref) => days),
          cyclesOfProgramProvider.overrideWith((ref) => cycles),
          hasProgramChangedProvider.overrideWith((ref) => hasChanged)
        ],
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto'),
          home: CreateProgramScreen(valve: 1, name: 'valve1'),
        )));

    final context = tester.element(find.byType(CreateProgramScreen));
    container = ProviderScope.containerOf(context);

    if (pumpAndSettle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }

  Future<void> tapEditNameIconButton() async {
    await tester.tap(find.widgetWithIcon(IconButton, Icons.edit));
    await tester.pumpAndSettle();
  }

  Future<void> enterTextToTextField() async {
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);
    await tester.enterText(textFieldFinder, 'test-name');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
  }

  Future<void> tapDayButton(String day) async {
    final dayButtonFinder = find.widgetWithText(ElevatedButton, day);
    await tester.tap(dayButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapBackButton() async {
    final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));

    await widgetsAppState.didPopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
  }

  Future<void> tapAddCyclebutton() async {
    await tester.tap(find.byType(AddCycleButton));
    await tester.pumpAndSettle();
  }

  Future<void> confirmSelectTime() async {
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  Future<void> confirmDuration() async {
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();
  }

  Future<void> tapStartTimeButton() async {
    final offset = tester.getCenter(find.byType(FilledButton).first);
    await tester.tapAt(offset);
    await tester.pumpAndSettle();
  }

  Future<void> tapDurationButton() async {
    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
  }

  Future<void> tapDeleteCycleButton() async {
    await tester.tap(find.widgetWithIcon(IconButton, Icons.delete));
    await tester.pumpAndSettle();
  }

  Future<void> confirmDeleteCycle() async {
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
  }

  Future<void> tapSaveButton() async {
    expectFindSaveProgramButton();
    await tester.tap(find.byType(SaveProgramButton));
    await tester.pumpAndSettle();
  }

  Future<void> tapDeleteProgramButton() async {
    await tester.tap(find.widgetWithText(TextButton, 'Delete program'));
    await tester.pumpAndSettle();
  }

  void expectConfigTopicProviderUpdated() {
    final config = container.read(configTopicProvider);
    expect(config.length, 1);
  }

  void expectSendSceduleToBrokerCalled() {
    final schedule = container.read(configTopicProvider);
    expect(container.read(programProvider).sendSchedule(schedule), -1);
  }

  void expectFindProgramScreen() {
    expect(find.byType(ProgramsScreen), findsOneWidget);
  }

  void expectFindCreateProgramScreen() {
    expect(find.byType(CreateProgramScreen), findsOneWidget);
  }

  void expectNotFindCreateProgramScreen() {
    expect(find.byType(CreateProgramScreen), findsNothing);
  }

  void expectFindDaysOfWeekWidget() {
    expect(find.byType(DaysOfWeekWidget), findsOneWidget);
  }

  void expectFindSaveProgramButton() {
    expect(find.byType(SaveProgramButton), findsOneWidget);
  }

  void expectNotFindSaveProgramButton() {
    expect(find.byType(SaveProgramButton), findsNothing);
  }

  void expectFindDeleteProgramButton() {
    expect(find.byType(DeleteProgramButtonWidget), findsOneWidget);
  }

  void expectNotFindDeleteProgramButton() {
    expect(find.byType(DeleteProgramButtonWidget), findsNothing);
  }

  void expectFindEditNameIconButton() {
    expect(find.widgetWithIcon(IconButton, Icons.edit), findsOneWidget);
  }

  void expectFindTextField() {
    expect(find.byType(TextField), findsOneWidget);
  }

  void expectNotFindTextField() {
    expect(find.byType(TextField), findsNothing);
  }

  void expectHasProgramChangedProviderUpdated() {
    expect(container.read(hasProgramChangedProvider), true);
  }

  void expectFindSevenDayButtons() {
    expect(find.byType(DayButton), findsNWidgets(7));
  }

  void expectDayButtonColor(String day, Color? color) {
    final dayButton =
        tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Mon'));
    final states = <MaterialState>{};
    final bgColor = dayButton.style?.backgroundColor?.resolve(states);
    expect(bgColor, color);
  }

  void expectDaysOfProgramProviderUpdated(List<DaysOfWeek> value) {
    expect(container.read(daysOfProgramProvider), value);
  }

  void expectFindAddCycleButton() {
    expect(find.byType(AddCycleButton), findsOneWidget);
  }

  void expectFindTimePicker() {
    expect(find.text('Select time'), findsOneWidget);
  }

  void expectCyclesProviderUpdated() {
    final cycles = container.read(cyclesOfProgramProvider.notifier).state;
    expect(cycles.length, 1);
    expect(cycles[0].start, isNotEmpty);
    expect(cycles[0].min, '1');
  }

  void expectFindDurationPicker() {
    expect(find.text('Select duration'), findsOneWidget);
  }

  void expectFindOneCycleWidget() {
    expect(find.byType(Card), findsOneWidget);
  }

  void expectFindDeleteIconButton() {
    expect(find.widgetWithIcon(IconButton, Icons.delete), findsOneWidget);
  }

  void expectFindAlertDialog() {
    expect(find.text('Yes'), findsOneWidget);
  }

  void expectCyclesProviderHasOneCycle() {
    final cycles = container.read(cyclesOfProgramProvider.notifier).state;
    expect(cycles.length, 1);
  }

  void expectCyclesProviderBeEmpty() {
    final cycles = container.read(cyclesOfProgramProvider.notifier).state;
    expect(cycles, []);
  }

}
