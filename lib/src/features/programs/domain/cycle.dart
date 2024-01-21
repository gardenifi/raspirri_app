// ignore_for_file: public_member_api_docs, sort_constructors_first
class Cycle {
  String start;
  String min;

  Cycle({
    required this.start,
    this.min = '',
  });

  factory Cycle.fromJson(Map<String, dynamic> data) {
    final start = data['start'];
    if (start is! String) {
      throw FormatException(
          'Invalid JSON: requird "start" field of type String in $data');
    }
    final min = data['min'] as String;
    return Cycle(start: start, min: min);
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'min': min,
    };
  }

  Cycle copyWith({
    String? startTime,
    String? duration,
    bool? cycleRunning,
  }) {
    return Cycle(
      start: startTime ?? start,
      min: duration ?? min,
    );
  }

  @override
  String toString() => 'Cycle(start: $start, min: $min)';

  @override
  bool operator ==(covariant Cycle other) {
    if (identical(this, other)) return true;
  
    return 
      other.start == start &&
      other.min == min;
  }

  @override
  int get hashCode => start.hashCode ^ min.hashCode;
}
