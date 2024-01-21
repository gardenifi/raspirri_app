import 'package:new_gardenifi_app/src/features/programs/domain/cycle.dart';

class Program {
  int out;
  String name;
  String days;
  List<Cycle> cycles;
  int tz_offset;

  Program({
    required this.out,
    this.name = '',
    required this.days,
    required this.cycles,
    required this.tz_offset,
  });

  List<String>? listOfDays;

  factory Program.fromJson(Map<String, dynamic> data) {
    final out = data['out'];
    if (out is! int) {
      throw FormatException('Invalid JSON: required "out" field of type [int] in $data');
    }
    final name = data['name'] as String;
    final days = data['days'];
    if (days is! String) {
      throw FormatException(
          'Invalid JSON: required "days" field of type [String] in $data');
    }
    final tz_offset = data['tz_offset'];
    if (tz_offset is! int) {
      throw FormatException(
          'Invalid JSON: required "tzOffset: field of type [int] in $data');
    }
    final cycles = data['cycles'] as List<dynamic>;

    return Program(
      out: out,
      name: name,
      days: days,
      cycles: cycles.map((e) => Cycle.fromJson(e as Map<String, dynamic>)).toList(),
      tz_offset: tz_offset,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'out': out,
      'name': name,
      'days': days,
      'cycles': cycles.map((e) => e.toJson()).toList(),
      'tz_offset': tz_offset,
    };
  }

  @override
  String toString() =>
      'Program(out: $out, name: $name, days: $days, cycles: $cycles, tz_offset: $tz_offset)';
}
