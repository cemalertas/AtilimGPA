// curriculum_model.dart
// Model classes for curriculum data

class Lesson {
  final String courseCode;
  final String courseName;
  final int theoretical;
  final int practical;
  final double ects;

  Lesson({
    required this.courseCode,
    required this.courseName,
    required this.theoretical,
    required this.practical,
    required this.ects,
  });

  factory Lesson.fromMap(Map<String, String> map) {
    // Handle potential parsing errors and missing values
    return Lesson(
      courseCode: map['Ders Kodu'] ?? '',
      courseName: map['Ders Adı'] ?? '',
      theoretical: int.tryParse(map['Teorik'] ?? '0') ?? 0,
      practical: int.tryParse(map['Uygulama'] ?? '0') ?? 0,
      ects: double.tryParse(map['Akts'] ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'theoretical': theoretical,
      'practical': practical,
      'ects': ects,
    };
  }

  @override
  String toString() {
    return 'Lesson(courseCode: $courseCode, courseName: $courseName, theoretical: $theoretical, practical: $practical, ects: $ects)';
  }
}

class Semester {
  final int year;
  final String term; // "Fall" or "Spring"
  final List<Lesson> lessons;

  Semester({
    required this.year,
    required this.term,
    required this.lessons,
  });

  // Helper to get a display name like "1. Dönem" or "2. Dönem"
  String get displayName {
    final semesterNumber = year * 2 - (term == 'Fall' ? 1 : 0);
    return '$semesterNumber. Dönem';
  }

  // Get total ECTS for the semester
  double get totalEcts {
    return lessons.fold(0.0, (sum, lesson) => sum + lesson.ects);
  }

  // Get total course hours
  int get totalHours {
    return lessons.fold(0, (sum, lesson) => sum + lesson.theoretical + lesson.practical);
  }

  @override
  String toString() {
    return 'Semester(displayName: $displayName, lessons: ${lessons.length})';
  }
}

class Curriculum {
  final String departmentCode;
  final String departmentName;
  final List<Semester> semesters;

  Curriculum({
    required this.departmentCode,
    required this.departmentName,
    required this.semesters,
  });

  // Get total ECTS for the entire curriculum
  double get totalEcts {
    return semesters.fold(0.0, (sum, semester) => sum + semester.totalEcts);
  }

  // Get total course count
  int get totalCourseCount {
    return semesters.fold(0, (sum, semester) => sum + semester.lessons.length);
  }

  @override
  String toString() {
    return 'Curriculum(departmentCode: $departmentCode, departmentName: $departmentName, semesters: ${semesters.length})';
  }
}