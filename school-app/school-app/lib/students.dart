import 'dart:io';

import 'package:school_app/library.dart' as lib;
import 'package:school_app/school.dart';

enum Gender { male, female }

class Students extends School {
  Students() : super();

  menu() {
    outerloop:
    while (true) {
      print('\nMANAGE STUDENTS\n=========================');
      print(
          '1 => View Students\n2 => Add Student\n3 => Edit Student\n4 => Delete Student\n5 => Back\n6 => Exit');

      int option = lib.getOption();

      switch (option) {
        case 1:
          viewStudents();
          break;
        case 2:
          addStudents();
          break;
        case 3:
          editStudent();
          break;
        case 4:
          deleteStudent();
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

  addStudents() {
    print('\nADD STUDENT\n--------------------------');
    print('Enter firstname');
    String? fname = stdin.readLineSync();
    if (fname == '') {
      print('You did not enter first name.\nTry again...');
      return;
    }

    print('Enter lastname');
    String? lname = stdin.readLineSync();
    if (lname == '') {
      print('You did not enter last name.\nTry again...');
      return;
    }

    print('Select gender');
    int index = 1;
    for (Gender g in Gender.values) {
      // Diplay gender from the enum
      print('[$index] => ${g.name}');
      index++;
    }
    int gender = lib.getOption(); // Get user option and validate
    if (gender != 1 && gender != 2) {
      print('Select gender from the provided options.\nTry again...');
      return;
    }

    // Select class
    print('Select the class to admit student\n');
    int i = 1;
    List<int> allGrades = []; // Put all classes in a list to validate later
    print('#. ID  CLASS');
    for (var row in allClasses) {
      // Display all saved classes for the user to choose
      print("$i. ${row['id']}   Grade ${row['name']}");
      allGrades.add(row['id']);
      i++;
    }
    int grade = lib.getOption(); // Get user option and validate
    if (!allGrades.contains(grade)) {
      print('Select class from the provided options.\nTry again...');
      return;
    }

    final now = DateTime.now(); // Current time
    Map<String, dynamic> student = {
      // Put student data in a Map
      'admissionNum':'${lastAdmissionNo + 1}/${now.year}', // Admission Number generated by the system
      'firstname': fname,
      'lastname': lname,
      'gender': (gender == 1) ? Gender.male.name : Gender.female.name
    };

    // Get class details from user's option
    Map selectedClass =
        (allClasses as List).where((item) => item['id'] == grade).toList()[0];
    if (selectedClass.containsKey('students')) {
      (selectedClass['students'] as List).add(student);
    } else {
      selectedClass['students'] = [student];
    }

    setLastAdmissionNo = lastAdmissionNo + 1; // Update last admission number
    saveClassData(); // Save file in the list
    print("$fname $lname has been added to Grade ${selectedClass['name']}");
  }

  viewStudents() {
    /* 
    * Wanted to create an awesome looking table.
    * I went ahead and made a custom table. 
    */

    // int col0 = 1 hard coded first column length
    int col1 = 12; // length determined by the length of heading
    int col2 = 12;
    int col3 = 6;
    String headerString = ''; // build up from a loop
    String space = ' ';
    String divider = '| ';

    if (allClasses.length > 0) {
      // atleast 1 class must exist
      for (Map clas in allClasses) {
        // class must contain students list and must have atleast 1 student
        if (clas.containsKey('students') && clas['students'].length > 0) {
          List std = clas['students'];
          for (Map student in std) {
            String fullName = '${student['firstname']} ${student['lastname']}';
            col1 = (student['admissionNum'].length > col1)
                ? student['admissionNum'].length
                : col1; // Set the new value of col1
            col2 = (fullName.length > col2) ? fullName.length : col2;
            col3 = (student['gender'].length > col3)
                ? student['gender'].length
                : col3;
          }
        }
      }
    }

    List<Map> header = [
      // Header row
      {"name": "#", "size": 1},
      {"name": "ADMISSION NO", "size": 12},
      {"name": "STUDENT NAME", "size": 12},
      {"name": "GENDER", "size": 6}
    ];

    int indx = 0;
    col2 = col2 + 1;
    col3 = col3 + 2;
    for (Map h in header) {
      // set header row by populating headerString
      switch (indx) {
        case 0:
          headerString += '${h['name']}${space * 1}$divider';
          break;
        case 1:
          int multiplier = (h['size'] >= col1) ? 1 : (col1 - h['size']) as int;
          headerString += '${h['name']}${space * multiplier}$divider';
          break;
        case 2:
          int multiplier = (h['size'] >= col2) ? 1 : (col2 - h['size']) as int;
          headerString += '${h['name']}${space * multiplier}$divider';
          break;
        case 3:
          int multiplier = (h['size'] >= col3) ? 1 : (col3 - h['size']) as int;
          headerString += '${h['name']}${space * multiplier}$divider';
          break;
        default:
          headerString += '${h['name']}${space * 1}$divider';
      }
      indx++;
    }
    /* print('_' * (headerString.length));
    print(headerString);
    print('_' * (headerString.length)); */

    if (allClasses.length > 0) {
      int ind = 1;
      for (Map clas in allClasses) {
        print("\nGRADE ${(clas['name']).toUpperCase()}");
        print('=' * (headerString.length));
        //print('_' * (headerString.length));
        print(headerString);
        print('.' * (headerString.length));
        if (clas.containsKey('students') && clas['students'].length > 0) {
          List std = clas['students'];
          for (Map student in std) {
            String fullName = '${student['firstname']} ${student['lastname']}';
            int r1m = (student['admissionNum'].length >= col1)
                ? 1
                : (col1 - student['admissionNum'].length) as int;
            int r2m = (fullName.length >= col2) ? 1 : (col2 - fullName.length);
            int r3m = (student['gender'].length >= col3)
                ? 1
                : (col3 - student['gender'].length) as int;
            print(
                "$ind${space * 1}$divider${student['admissionNum']}${space * (r1m + 1)}$divider$fullName${space * r2m}$divider${student['gender']}${space * r3m}$divider");
            print('.' * (headerString.length));
            ind++;
          }
        }
      }
    }
  }

  editStudent() {
    print('Enter admission Number for the student you want to update\n');
    stdout.write('Admission No: ');
    String adm = stdin.readLineSync()!;

    if (adm == '') {
      print('Make sure you provide admission number.');
      return;
    }

    Map<String, dynamic>? student;
    for (final classGroup in allClasses) {
      if (classGroup['students'] != null) {
        for (final studentInfo in classGroup['students']) {
          if (studentInfo['admissionNum'] == adm) {
            student = studentInfo;
            break;
          }
        }
      }
      if (student != null) break;
    }

    if (student != null) {
      print('Student found: ${student['firstname']} ${student['lastname']}');
      print('\nEnter Firstname.');
      stdout.write('Firstname(If no change press enter key):');
      String? fname = stdin.readLineSync();
      fname = (fname == '') ? student['firstname'] : fname;
      print('\nEnter Lastname.');
      stdout.write('Lastname(If no change press enter key):');
      String? lname = stdin.readLineSync();
      lname = (lname == '') ? student['lastname'] : lname;
      print('\nSelect Gender.');
      int index = 1;
      for (Gender g in Gender.values) {
        // Diplay gender from the enum
        print('[$index] => ${g.name}');
        index++;
      }
      int gender = lib.getOption('Gender(If no change press enter key)'); // Get user option and validate
      if (gender != 1 && gender != 2 && gender != 0) {
        print('Select gender from the provided options.\nTry again...');
        return;
      }

      String newGender = (gender == 0) ? student['gender'] : (gender == 1) ? Gender.male.name : Gender.female.name;

      student['firstname'] = fname;
      student['lastname'] = lname;
      student['gender'] = newGender;
      
      saveClassData(); // Save file in the list
      print("$fname $lname details have been updated successfully");
    } else {
      print('No student found with admission number $adm.');
    }
  }

  deleteStudent() {
    print('Enter admission Number for the student you want to update\n');
    stdout.write('Admission No: ');
    String adm = stdin.readLineSync()!;

    if (adm == '') {
      print('Make sure you provide admission number.');
      return;
    }

    Map<String, dynamic>? student;
    for (final classGroup in allClasses) {
      if (classGroup['students'] != null) {
        for (final studentInfo in classGroup['students']) {
          if (studentInfo['admissionNum'] == adm) {
            student = studentInfo;
            (classGroup['students'] as List).removeWhere((test) => test['admissionNum'] == adm);
            break;
          }
        }
      }
      if (student != null) break;
    }

    if (student != null) {
      print('Student found: ${student['firstname']} ${student['lastname']}');
      print('All Student data has been deleted');
    } else {
      print('No student found with admission number $adm.');
    }
  }
}
