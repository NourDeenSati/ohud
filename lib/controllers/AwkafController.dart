import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Student {
  TextEditingController nameController = TextEditingController();
  TextEditingController partController = TextEditingController();
}

class StudentController extends GetxController {
  var students = <Student>[Student()].obs;

  void addStudentIfLastFilled(int index) {
    var student = students[index];
    if (student.nameController.text.isNotEmpty &&
        student.partController.text.isNotEmpty &&
        index == students.length - 1) {
      students.add(Student());
    }
  }
  void clearAllStudents() {
  students.clear();
  students.add(Student()); // نبدأ بسطر واحد فارغ
}

}
