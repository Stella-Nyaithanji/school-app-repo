import 'dart:io';
import 'package:school_app/library.dart' as lib;
import 'package:school_app/school.dart';

class MyClass extends School {
  
  MyClass(): super();

  // Menu
  menu() {
    outerloop:
    while (true) {
      print('\nMANAGE CLASSES\n=========================');
      print(
          '1 => View Classes\n2 => Create Class\n3 => Edit class\n4 => Delete Class\n5 => Back\n6 => Exit');
      int option = lib.getOption();

      switch (option) {
        case 1:
          print(
              '\n______________________\nAll Classes\n______________________');
          viewClasses();
          break;
        case 2:
          createClass();
          break;
        case 3:
          editClass();
          break;
        case 4:
          deleteClass();
          break;
        case 5:
          break outerloop;
        case 6:
          exit(0);
        default:
          print('Only the provided options are allowed!');
      }
    }
  }

   // get last id in the list
  int _lastId() {
    if (allClasses.isNotEmpty) {
      Map lastItem = allClasses[allClasses.length - 1];
      return lastItem['id'];
    } else {
      return 0;
    }
  }

  // view all classes
  void viewClasses() {
    int index = 1;
    print('#. ID  CLASS');
    for (var row in allClasses) {
      print("$index. ${row['id']}   Grade ${row['name']}");
      index++;
    }
  }

  // Create a new class and add to the database(file)
  void createClass() {
    print('Enter name of the class');
    String className = stdin.readLineSync()!;

    if (className != '') {
      Map<String, dynamic> newClass = {"id": _lastId() + 1, "name": className};

      allClasses.add(newClass);
      saveClassData();
      print('Grade $className added successfully.');
    } else {
      print('\nYou did not provide a name');
    }
  }

  // Edit a class
  void editClass() {
    print('Enter class ID for the class you want to edit.\n');
    viewClasses();
    stdout.write('\nClass ID: ');

    String classId = stdin.readLineSync()!;
    int? option = int.tryParse(classId);
    if (option != null) {
      try {
        var item = allClasses.firstWhere((item) => item['id'] == option);
        print('Enter the new name for the class');
        String? name = stdin.readLineSync();
        if (name != '') {
          item['name'] = name;
          saveClassData();
          print('Grade $name has been updated successfully.');
        } else {
          print('\nYou did not provide a name');
        }
      } catch (e) {
        print('Class does not exist');
      }
    } else {
      print('Only the provided options are allowed!');
    }
  }

  // Delete a class
  void deleteClass() {
    print('Enter class ID for the class you want to delete.\n');
    viewClasses();
    stdout.write('\nClass ID: ');

    String classId = stdin.readLineSync()!;
    int? option = int.tryParse(classId);
    if (option != null) {
      try {
        var item = allClasses.firstWhere((item) => item['id'] == option);
        allClasses.removeWhere((item) => item['id'] == option);
        saveClassData();
        print("Grade ${item['name']} has been deleted");
      } catch (e) {
        print('Class does not exist');
      }
    } else {
      print('Only the provided options are allowed!');
    }
  }

}
