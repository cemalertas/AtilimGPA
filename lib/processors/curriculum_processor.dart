// curriculum_processor.dart
// Utility to process raw curriculum data into structured model

import '../models/curriculum_model.dart';
import '../data/department_data.dart';

class CurriculumProcessor {
  /// Processes raw curriculum data into a structured Curriculum object
  static Curriculum processCurriculumData(List<Map<String, dynamic>> rawData, String departmentCode) {
    // Get department name from department code
    final departmentName = DepartmentData.getDepartmentName(departmentCode) ?? 'Unknown Department';

    // Process each semester (table)
    List<Semester> semesters = [];

    for (int i = 0; i < rawData.length; i++) {
      final tableData = rawData[i];
      final semesterData = tableData['data'] as List<Map<String, String>>;

      // Skip the last row which contains totals
      final filteredData = semesterData.where((row) =>
      row['Ders Kodu'] != 'Toplam' && row['Ders Kodu'] != null && row['Ders Kodu']!.isNotEmpty
      ).toList();

      // Parse semester information
      final semesterInfo = tableData['semester'] as String; // Format: "Year X - Fall/Spring"
      final year = int.parse(semesterInfo.split(' ')[1]);
      final term = semesterInfo.split(' - ')[1]; // "Fall" or "Spring"

      // Convert raw data to Lesson objects
      final lessons = filteredData.map((row) => Lesson.fromMap(row)).toList();

      // Create semester
      final semester = Semester(
        year: year,
        term: term,
        lessons: lessons,
      );

      semesters.add(semester);
    }

    // Create and return the full curriculum
    return Curriculum(
      departmentCode: departmentCode,
      departmentName: departmentName,
      semesters: semesters,
    );
  }

  /// Gets a list of all courses across all semesters
  static List<Lesson> getAllCourses(Curriculum curriculum) {
    final List<Lesson> allCourses = [];

    for (var semester in curriculum.semesters) {
      allCourses.addAll(semester.lessons);
    }

    return allCourses;
  }

  /// Gets a map of semester display names to their corresponding lessons
  static Map<String, List<Lesson>> getSemesterMap(Curriculum curriculum) {
    final Map<String, List<Lesson>> semesterMap = {};

    for (var semester in curriculum.semesters) {
      semesterMap[semester.displayName] = semester.lessons;
    }

    return semesterMap;
  }

  /// Finds a course by its course code
  static Lesson? findCourseByCode(Curriculum curriculum, String courseCode) {
    for (var semester in curriculum.semesters) {
      for (var lesson in semester.lessons) {
        if (lesson.courseCode.toLowerCase() == courseCode.toLowerCase()) {
          return lesson;
        }
      }
    }
    return null;
  }

  /// Gets all courses in a specific semester
  static List<Lesson>? getCoursesInSemester(Curriculum curriculum, int semesterNumber) {
    if (semesterNumber < 1 || semesterNumber > curriculum.semesters.length) {
      return null;
    }

    // Semesters are 1-indexed for users, but 0-indexed in the list
    return curriculum.semesters[semesterNumber - 1].lessons;
  }
}