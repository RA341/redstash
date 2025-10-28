import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
    // Number of method calls to be displayed
    methodCount: 2,
    // Number of method calls if stacktrace is provided
    errorMethodCount: 8,
    // Width of the output
    lineLength: 120,
    colors: true,
    printEmojis: true,
    // Should each log print contain a timestamp
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);