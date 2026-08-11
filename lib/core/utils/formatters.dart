// Utility functions for formatting display text
class Formatters {
  Formatters._();

  // Converts "Dhaka International University" -> "DIU"
  // Takes the first letter of every word, uppercased, joined together
  static String universityInitials(String universityName) {
    return universityName
        .trim()
        .split(RegExp(r'\s+')) // split on any whitespace
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase())
        .join();
  }

  // Builds the full batch display label: "CSE-108 | DIU"
  static String batchDisplayLabel({
    required String deptName,
    required String batchName,
    required String universityName,
  }) {
    final initials = universityInitials(universityName);
    return '$deptName-$batchName | $initials';
  }
}