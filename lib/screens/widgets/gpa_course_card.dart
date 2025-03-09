import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GPACourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isEditMode;
  final String? selectedGrade;
  final List<String> gradeOptions;
  final Map<String, Color> gradeColors;
  final Map<String, double> gradeValues;
  final Function(String, String?) onGradeChanged;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const GPACourseCard({
    Key? key,
    required this.course,
    required this.isEditMode,
    required this.selectedGrade,
    required this.gradeOptions,
    required this.gradeColors,
    required this.gradeValues,
    required this.onGradeChanged,
    required this.onEdit,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String courseName = course['name'];
    String courseCode = course['code'] ?? '';
    double courseCredits = (course['credits'] as num).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: selectedGrade != null
                      ? [
                    Colors.grey.shade900,
                    Color.lerp(Colors.grey.shade900, gradeColors[selectedGrade], 0.3) ?? Colors.grey.shade900,
                  ]
                      : [
                    Colors.grey.shade900,
                    Colors.black,
                  ],
                ),
              ),
            ),

            // Top accent line based on grade
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                color: selectedGrade != null
                    ? gradeColors[selectedGrade]
                    : Colors.grey.shade700,
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side with course info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Course code chip
                            if (courseCode.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey.shade700),
                                ),
                                child: Text(
                                  courseCode,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),

                            // Course name
                            Text(
                              courseName,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),

                            // Credits
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.book,
                                    size: 14,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${courseCredits.toStringAsFixed(1)} AKTS",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right side with grade or edit buttons
                      isEditMode
                          ? _buildEditButtons()
                          : _buildGradeSelector(courseName),
                    ],
                  ),

                  // Grade value information (if selected and not in edit mode)
                  if (selectedGrade != null && !isEditMode)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: gradeColors[selectedGrade]!.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: gradeColors[selectedGrade]!.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.grade,
                            size: 16,
                            color: gradeColors[selectedGrade],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Not: ${gradeValues[selectedGrade]!.toStringAsFixed(1)}",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: gradeColors[selectedGrade],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // White glass effect on the right side for selected grades
            if (selectedGrade != null && !isEditMode)
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                width: 40,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        gradeColors[selectedGrade]!.withOpacity(0.2),
                        gradeColors[selectedGrade]!.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButtons() {
    return Row(
      children: [
        // Edit button
        Container(
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: onEdit,
            icon: Icon(
              Icons.edit,
              color: Colors.blue.shade300,
              size: 20,
            ),
            splashRadius: 20,
            tooltip: 'Düzenle',
          ),
        ),
        const SizedBox(width: 8),
        // Delete button
        Container(
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.delete,
              color: Colors.red.shade300,
              size: 20,
            ),
            splashRadius: 20,
            tooltip: 'Sil',
          ),
        ),
      ],
    );
  }

  Widget _buildGradeSelector(String courseName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedGrade != null
              ? gradeColors[selectedGrade]!.withOpacity(0.5)
              : Colors.grey.shade700,
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedGrade,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              "Not Seç",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              Icons.arrow_drop_down,
              color: selectedGrade != null
                  ? gradeColors[selectedGrade]
                  : Colors.grey.shade400,
            ),
          ),
          elevation: 1,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: selectedGrade != null
                ? gradeColors[selectedGrade]
                : Colors.white,
          ),
          dropdownColor: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
          items: gradeOptions.map((grade) {
            return DropdownMenuItem(
              value: grade,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: gradeColors[grade],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      grade,
                      style: GoogleFonts.poppins(
                        color: gradeColors[grade],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            onGradeChanged(courseName, value);
          },
        ),
      ),
    );
  }
}