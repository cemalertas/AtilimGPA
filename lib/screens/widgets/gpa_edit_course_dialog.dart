import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GPAEditCourseDialog extends StatefulWidget {
  final Map<String, dynamic> course;
  final Function(Map<String, dynamic>) onSave;

  const GPAEditCourseDialog({
    Key? key,
    required this.course,
    required this.onSave,
  }) : super(key: key);

  @override
  State<GPAEditCourseDialog> createState() => _GPAEditCourseDialogState();
}

class _GPAEditCourseDialogState extends State<GPAEditCourseDialog> {
  late TextEditingController nameController;
  late TextEditingController codeController;
  late TextEditingController creditsController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.course['name'] as String);
    codeController = TextEditingController(text: widget.course['code'] as String? ?? '');
    creditsController = TextEditingController(text: (widget.course['credits'] as num).toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    creditsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade800),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dersi Düzenle',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white70,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Form fields
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade700),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Course Name
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Ders Adı',
                      hintText: 'Örn: Veri Yapıları',
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                      ),
                      prefixIcon: Icon(
                        Icons.book_rounded,
                        color: Colors.blue.shade300,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade600),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade600),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Course Code
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: 'Ders Kodu',
                      hintText: 'Örn: CMPE101',
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                      ),
                      prefixIcon: Icon(
                        Icons.code,
                        color: Colors.purple.shade300,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade600),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade600),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.purple.shade300, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ECTS Credits
                  TextField(
                    controller: creditsController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'AKTS Kredisi',
                      hintText: 'Örn: 6.0',
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                      ),
                      prefixIcon: Icon(
                        Icons.credit_card_rounded,
                        color: Colors.amber.shade300,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade600),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade600),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.amber.shade300, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 18,
                    ),
                    label: Text(
                      'İptal',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Save button
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Update values
                      if (nameController.text.isNotEmpty &&
                          creditsController.text.isNotEmpty) {

                        final updatedCourse = {
                          'name': nameController.text,
                          'code': codeController.text,
                          'credits': double.tryParse(creditsController.text) ?? 0.0,
                        };

                        widget.onSave(updatedCourse);
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.check_rounded,
                      size: 18,
                    ),
                    label: Text(
                      'Kaydet',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}