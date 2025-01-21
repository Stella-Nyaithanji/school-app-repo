import 'package:school_app/school.dart';
import 'package:school_app/library.dart' as lib;
import 'dart:io';
import 'dart:math';

class Exams extends School {
  Exams() : super();

  menu() {
    outerloop:
    while (true) {
      print('\nMANAGE EXAMS\n=========================');
      print(
          '1 => View Exams\n2 => Add Exam\n3 => Edit Exam\n4 => Delete Exam\n5 => Key Marks\n6 => Back\n7 => Exit');

      int option = lib.getOption();

      switch (option) {
        case 1:
          viewExams();
          break;
        case 2:
          addExam();
          break;
        case 3:
          editExam();
          break;
        case 4:
          deleteExam();
          break;
        case 5:
          keyMarks();
          break;
        case 6:
          break outerloop;
        case 7:
          exit(0);
        default:
          print('Only the provided options are allowed!');
      }
    }
  }

  viewExams() {
    // Select class
    Map? selectedClass = getClass('Select a class to view exams');

    if (selectedClass != null) {
      print("\nSelected class is: Grade ${selectedClass['name']}");

      if (!selectedClass.containsKey('exams')) {
        print('There are no exams in Grade ${selectedClass['name']}');
        return;
      }

      int counter = 1;
      print('Available Exams\n______________________________\n');
      print('# | ID | EXAM-NAME\n...............................');
      for (var exam in selectedClass['exams']) {
        print("$counter | ${exam['examId']} |  ${exam['name']}");
        counter++;
      }

      print("\nEnter exam ID to view results");
      int option = lib.getOption('Exam ID: ');

      List selectedExam = (selectedClass['exams'] as List)
          .where((item) => item['examId'] == option)
          .toList();
      if (selectedExam.isEmpty) {
        print('Exam with this ID does not exist');
        return;
      }

      int col1 = 12; // length determined by the length of heading
      int col2 = 12;
      int col3 = 3;
      int col4 = 3;
      int col5 = 3;
      int col6 = 5;
      String headerString = ''; // build up from a loop
      String space = ' ';
      String divider = '| ';
      List<Map> header = [
        {"name": "#", "size": 1},
        {"name": "ADMISSION NO", "size": 12},
        {"name": "STUDENT NAME", "size": 12},
        {"name": "MAT", "size": 3},
        {"name": "ENG", "size": 3},
        {"name": "SCI", "size": 3},
        {"name": "TOTAL", "size": 5}
      ];

      for (Map student in selectedClass['students']) {
        String fullName = '${student['firstname']} ${student['lastname']}';
        col1 = (student['admissionNum'].length > col1)
            ? student['admissionNum'].length
            : col1;
        col2 = (fullName.length > col2) ? fullName.length : col2;
      }

      int indx = 0;
      col2 = col2 + 1;
      for (Map h in header) {
        // set Table header row by populating headerString
        switch (indx) {
          case 0:
            headerString += '${h['name']}${space * 1}$divider';
            break;
          case 1:
            int multiplier =
                (h['size'] >= col1) ? 1 : (col1 - h['size']) as int;
            headerString += '${h['name']}${space * multiplier}$divider';
            break;
          case 2:
            int multiplier =
                (h['size'] >= col2) ? 1 : (col2 - h['size']) as int;
            headerString += '${h['name']}${space * multiplier}$divider';
            break;
          case 3:
            headerString += '${h['name']}${space * 1}$divider';
            break;
          case 4:
            headerString += '${h['name']}${space * 1}$divider';
            break;
          case 5:
            headerString += '${h['name']}${space * 1}$divider';
            break;
          case 6:
            headerString += '${h['name']}${space * 1}$divider';
            break;
          default:
            headerString += '${h['name']}${space * 1}$divider';
        }
        indx++;
      }

      print("\n${selectedExam[0]['name'].toUpperCase()} RESULTS");
      print('=' * (headerString.length));
      print('\n$headerString');
      print('.' * (headerString.length));
      int ind = 1;
      for (Map student in selectedClass['students']) {
        String fullName = '${student['firstname']} ${student['lastname']}';
        int r1m = (student['admissionNum'].length >= col1)
            ? 1
            : (col1 - student['admissionNum'].length) as int;
        int r2m = (fullName.length >= col2) ? 1 : (col2 - fullName.length);

        num math = marks(selectedClass['id'], selectedExam[0]['examId'],
            student['admissionNum'], 'Mathematics');
        num eng = marks(selectedClass['id'], selectedExam[0]['examId'],
            student['admissionNum'], 'English');
        num sci = marks(selectedClass['id'], selectedExam[0]['examId'],
            student['admissionNum'], 'Science');
        double total = calculateAverage([math, eng, sci]);

        int mathLen = math.toString().length;
        int m = (mathLen == 1) ? 3 : 2;

        int engLen = eng.toString().length;
        int e = (engLen == 1) ? 3 : 2;

        int sciLen = sci.toString().length;
        int s = (sciLen == 1) ? 3 : 2;
        print(
            "$ind${space * 1}$divider${student['admissionNum']}${space * (r1m + 1)}$divider$fullName${space * r2m}$divider$math${space * m}$divider$eng${space * e}$divider$sci${space * s}$divider$total${space * 5}");
        print('.' * (headerString.length));
        ind++;
      }
    }
  }

  editExam() {
    // Select class
    Map? selectedClass = getClass('Select a class to view exams');

    if (selectedClass != null) {
      print("\nSelected class is: Grade ${selectedClass['name']}");

      if (!selectedClass.containsKey('exams')) {
        print('There are no exams in Grade ${selectedClass['name']}');
        return;
      }

      int counter = 1;
      print('Available Exams\n______________________________\n');
      print('# | ID | EXAM-NAME\n...............................');
      for (var exam in selectedClass['exams']) {
        print("$counter | ${exam['examId']} |  ${exam['name']}");
        counter++;
      }

      print("\nEnter exam ID for the exam you want to edit");
      int option = lib.getOption('Exam ID: ');

      List selectedExam = (selectedClass['exams'] as List)
          .where((item) => item['examId'] == option)
          .toList();
      if (selectedExam.isEmpty) {
        print('Exam with this ID does not exist');
        return;
      }

      print('What name do you want to give this exam?');
      String? examName = stdin.readLineSync();
      if (examName == '') {
        print('You did not provide exam name.\nTry again...');
        return;
      }

      selectedExam[0]['name'] = examName;
      saveClassData();
      print('$examName has been updated.');
    }
  }

  deleteExam() {
    // Select class
    Map? selectedClass = getClass('Select a class to view exams');

    if (selectedClass != null) {
      print("\nSelected class is: Grade ${selectedClass['name']}");

      if (!selectedClass.containsKey('exams')) {
        print('There are no exams in Grade ${selectedClass['name']}');
        return;
      }

      int counter = 1;
      print('Available Exams\n______________________________\n');
      print('# | ID | EXAM-NAME\n...............................');
      for (var exam in selectedClass['exams']) {
        print("$counter | ${exam['examId']} |  ${exam['name']}");
        counter++;
      }

      print("\nEnter exam ID for the exam you want to edit");
      int option = lib.getOption('Exam ID: ');

      List selectedExam = (selectedClass['exams'] as List)
          .where((item) => item['examId'] == option)
          .toList();
      if (selectedExam.isEmpty) {
        print('Exam with this ID does not exist');
        return;
      }

      (selectedClass['exams'] as List)
          .removeWhere((item) => item['examId'] == option);
      print("${selectedExam[0]['name']} has been deleted.");
    }
  }

  keyMarks() {
    // Select class
    Map? selectedClass = getClass('Select a class to view exams');

    if (selectedClass != null) {
      print("\nSelected class is: Grade ${selectedClass['name']}");

      if (!selectedClass.containsKey('exams')) {
        print('There are no exams in Grade ${selectedClass['name']}');
        return;
      }

      int counter = 1;
      print('Available Exams\n______________________________\n');
      print('# | ID | EXAM-NAME\n...............................');
      for (var exam in selectedClass['exams']) {
        print("$counter | ${exam['examId']} |  ${exam['name']}");
        counter++;
      }

      print("\nEnter exam ID for the exam you want to key marks");
      int option = lib.getOption('Exam ID: ');

      List selectedExam = (selectedClass['exams'] as List)
          .where((item) => item['examId'] == option)
          .toList();
      if (selectedExam.isEmpty) {
        print('Exam with this ID does not exist');
        return;
      }

      while (true) {
        print("Selected Exam: ${selectedExam[0]['name']}");
        List<String> subjects = ['Mathematics', 'English', 'Science'];
        print("\nSelect subject");
        for (String sub in subjects) {
          print("[${sub.substring(0, 1)}] $sub");
        }
        String input = stdin.readLineSync()!.toUpperCase();
        if ((input == '') || (input != 'M' && input != 'E' && input != 'S')) {
          print('Invalid choice. Use the provided options.\n');
        } else {
          String selectedSubject =
              subjects.where((sub) => sub.substring(0, 1) == input).first;
          Map score = (selectedExam[0]['analysis'] as List)
              .where((item) => item['subject'] == selectedSubject)
              .first;
          print('\n${selectedSubject.toUpperCase()} MARKS');
          for (Map item in score['marks']) {
            while(true) {
              print(
                "\n${item['name']}\nADM: ${item['admissionNum']}\nRecorded Marks: ${item['marks']}");
            print("Enter marks to update. If no change press enter");
            stdout.write("Marks: ");
            int? marks = int.tryParse(stdin.readLineSync()!);

            if (marks != null) {
              if (marks < 0 || marks > 100) {
                print('\nError!\n** Marks should be between 0 and 100.**\nTry again...');

              } else {
                print(
                    "${item['name']} $selectedSubject marks updated from ${item['marks']} to $marks.");
                item['marks'] = marks;
                saveClassData();
                break;
              }
            } else {
              break;
            }
            }
          }
          break;
        }
      }
    }
  }

  double calculateAverage(List<num> numbers) {
    if (numbers.isEmpty) {
      return 0; // Return 0 if the list is empty to avoid division by zero
    }

    num sum = numbers.reduce((a, b) => a + b);
    double aver = sum / numbers.length.toDouble();
    return double.parse(aver.toStringAsFixed(2));
  }

  num marks(int classId, int examId, String admissionNum, String subject) {
    List selectedClass =
        allClasses.where((item) => item['id'] == classId).toList();
    if (selectedClass.isEmpty) {
      return 0;
    }

    List selectedExam = selectedClass[0]['exams']
        .where((item) => item['examId'] == examId)
        .toList();
    if (selectedExam.isEmpty) {
      return 0;
    }

    List result = selectedExam[0]['analysis']
        .where((item) => item['subject'] == subject)
        .toList();
    List marks = result[0]['marks']
        .where((item) => item['admissionNum'] == admissionNum)
        .toList();

    return marks[0]['marks'];
  }

  addExam() {
    print('\nADD EXAM\n--------------------------');
    print('What name do you want to give this exam?');
    String? examName = stdin.readLineSync();
    if (examName == '') {
      print('You did not provide exam name.\nTry again...');
      return;
    }

    // Select class
    Map? selectedClass = getClass('Which class is this exam designed for?');

    if (selectedClass != null) {
      List<String> subjects = ['Mathematics', 'English', 'Science'];
      List<Map> analysis = [];
      for (String subject in subjects) {
        List studentList = [];
        for (Map student in selectedClass['students']) {
          String fullName = '${student['firstname']} ${student['lastname']}';
          studentList.add({
            "admissionNum": student['admissionNum'],
            "name": fullName,
            "marks": 0
          });
        }
        analysis.add({'subject': subject, 'marks': studentList});
      }

      String newExamName = 'Grade ${selectedClass['name']} $examName exam';

      // Check if there is exam key in the selected exam
      if (selectedClass.containsKey('exams')) {
        // add exam to exam list
        List exams = selectedClass['exams'] as List;

        // get the last exam id
        int lastExamId = exams.last['examId'];

        exams.add({
          "examId": lastExamId + 1,
          "name": newExamName,
          "analysis": analysis
        });
      } else {
        // create a list and add exam
        selectedClass['exams'] = [
          {"examId": 1, "name": newExamName, "analysis": analysis}
        ];
      }

      saveClassData(); // Save file in the list
      print('$newExamName has been created');
    }
  }

  Map? getClass(String message) {
    // Select class
    print('\n$message\n');
    int i = 1;
    List<int> allGrades = []; // Put all classes in a list to validate later
    print('#. ID  CLASS');
    for (var row in allClasses) {
      // Display all saved classes for the user to choose
      print("$i. ${row['id']}   Grade ${row['name']}");
      allGrades.add(row['id']);
      i++;
    }
    int grade = lib.getOption('Class ID'); // Get user option and validate

    if (!allGrades.contains(grade)) {
      print('Select class ID from the provided options.\nTry again...');
      return null;
    }

    // Get class details from user's option
    Map selectedClass =
        (allClasses as List).where((item) => item['id'] == grade).toList()[0];

    if (selectedClass['students'].length == 0) {
      print(
          'Make sure that Grade ${selectedClass['name']} has admitted students\n');
      return null;
    } else {
      return selectedClass;
    }
  }
}
