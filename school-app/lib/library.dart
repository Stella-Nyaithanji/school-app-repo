import 'dart:io';

int getOption([String message = 'User Input']) {
  stdout.write('\n$message: ');
  String input = stdin.readLineSync()!;
  int? option = int.tryParse(input);
  return (option != null) ? option : 0;
}
