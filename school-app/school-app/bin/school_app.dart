import 'dart:io';
import 'package:school_app/exams.dart';
import 'package:school_app/my_class.dart';
import 'package:school_app/library.dart' as lib;
import 'package:school_app/students.dart';

void main() {

  while (true) {
    print('\n**************************');
    print('SCHOOL MANAGEMENT SYTEM');
    print('**************************');
    print(
        '1 => Manage Classes\n2 => Manage Students\n3 => Manage Exams\n4 => exit');
    int option = lib.getOption();

    switch (option) {
      case 1:
        MyClass myClass = MyClass();
        myClass.menu();
        break;
      case 2:
        Students students = Students();
        students.menu();
        break;
      case 3:
        Exams exams = Exams();
        exams.menu();
        break;
      case 4:
        print('Exiting program...');
        exit(0);
      default:
        print('\nOnly the provided options are allowed!');
    }
  }
}