import 'dart:typed_data';

extension TimerDurationExt<T extends num> on T {
  static const int daysPerWeek = 7;

  static const int nanosecondsPerMicrosecond = 1000;

  Duration get weeks => days * daysPerWeek;

  Duration get days => milliseconds * Duration.millisecondsPerDay;

  Duration get hours => milliseconds * Duration.millisecondsPerHour;

  Duration get minutes => milliseconds * Duration.millisecondsPerMinute;

  Duration get seconds => milliseconds * Duration.millisecondsPerSecond;

  Duration get milliseconds => Duration(
      microseconds: (this * Duration.microsecondsPerMillisecond).toInt());

  Duration get microseconds =>
      milliseconds ~/ Duration.microsecondsPerMillisecond;

  Duration get nanoseconds => microseconds ~/ nanosecondsPerMicrosecond;
}

extension IntToBytesExt<T extends int> on T {
  Uint8List toBytes([Endian endian = Endian.big]) {
    final data = ByteData(8);
    data.setInt64(0, this, endian);
    return data.buffer.asUint8List();
  }
}

extension DoubleToBytesExt<T extends double> on T {
  Uint8List toBytes([Endian endian = Endian.big]) {
    final data = ByteData(8);
    data.setFloat64(0, this, endian);
    return data.buffer.asUint8List();
  }
}
