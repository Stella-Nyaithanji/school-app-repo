import 'dart:convert';
import 'dart:io';

class School {
  final String _filePath = 'school.json';
  List _allClasses = [];
  int _lastAdmissionNo = 0;

  // Default Constructor School
  // Initializes _allClasses List
  School() {
    try {
      var data = readFileContent();
      Map<String, dynamic> schoolData = jsonDecode(data);

      _allClasses = schoolData['classes'];
      _lastAdmissionNo = schoolData['lastAdmissionNo'];

    } catch (e) {
      print('An error occured:\n$e');
    }
  }

  // gets _allClasses.
  get allClasses => _allClasses;

  // gets Last admission Number
  get lastAdmissionNo => _lastAdmissionNo;

  // Sets last admission Number
  set setLastAdmissionNo(int admissionNumber) => _lastAdmissionNo = admissionNumber;

  // Reads data from the file and instantiates instance variables.
  readFileContent() {
    try {
      File schoolFile = File(_filePath);
      if (!schoolFile.existsSync()) {
        // File does not exist. Creating a new file...
        schoolFile.writeAsStringSync(jsonEncode(
          {
            'lastAdmissionNo': 0,
            'classes': []
          }
        ));
      }
      return schoolFile.readAsStringSync();
    } catch (e) {
      print('An error occured:\n$e');
    }
  }

  // Saves all data 
  void saveClassData() {
    File schoolFile = File(_filePath);
    var content = readFileContent();
    var jsonData = jsonDecode(content);
    jsonData['classes'] = _allClasses;
    jsonData['lastAdmissionNo'] = _lastAdmissionNo;
    final updated = jsonEncode(jsonData);
    schoolFile.writeAsStringSync(updated);
  }

}