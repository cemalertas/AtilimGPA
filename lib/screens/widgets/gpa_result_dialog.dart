import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class GPAResultDialog extends StatelessWidget {
  final double gpa;

  const GPAResultDialog({
    Key? key,
    required this.gpa,
  }) : super(key: key);

  // Determine GPA color based on value
  Color _getGpaColor() {
    if (gpa >= 3.5) return Colors.green.shade700;
    if (gpa >= 3.0) return Colors.green.shade500;
    if (gpa >= 2.5) return Colors.green.shade300;
    if (gpa >= 2.0) return Colors.yellow.shade700;
    if (gpa >= 1.5) return Colors.orange.shade400;
    if (gpa >= 1.0) return Colors.orange.shade600;
    return Colors.red.shade700;
  }

  // Get message based on GPA
  String _getGPAMessage() {
    if (gpa >= 3.5) return "Harika! Mükemmel bir performans gösterdiniz!";
    if (gpa >= 3.0) return "Çok iyi! Çalışmalarınız meyvesini veriyor!";
    if (gpa >= 2.5) return "İyi! Biraz daha çalışmayla daha da yükselebilir!";
    if (gpa >= 2.0) return "Ortalama. Dikkatli olmalısınız!";
    if (gpa >= 1.5) return "Geçtiniz, ancak daha fazla çaba göstermelisiniz!";
    if (gpa >= 1.0) return "Sınırda geçtiniz. Daha çok çalışmalısınız!";
    return "Başarısız oldunuz. Daha fazla destek almalısınız!";
  }

  @override
  Widget build(BuildContext context) {
    final Color gpaColor = _getGpaColor();

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with GPA result
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: gpaColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: gpaColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "GPA SONUCU",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            gpa.toStringAsFixed(2),
                            style: GoogleFonts.montserrat(
                              fontSize: 56,
                              fontWeight: FontWeight.w700,
                              color: gpaColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: gpaColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: gpaColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "PUAN",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: gpaColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Message section
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            gpa >= 2.0
                                ? Icons.emoji_events
                                : Icons.info_outline,
                            color: gpaColor,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _getGPAMessage(),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Progress bar visualization
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Performans",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                "${((gpa / 4.0) * 100).toStringAsFixed(0)}%",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: gpaColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              // Background
                              Container(
                                height: 8,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              // Progress
                              Container(
                                height: 8,
                                width: (MediaQuery.of(context).size.width * 0.9 - 48) *
                                    (gpa / 4.0), // Account for padding and get full width at 4.0
                                decoration: BoxDecoration(
                                  color: gpaColor,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: gpaColor.withOpacity(0.4),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade800,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            "KAPAT",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            "TAMAM",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}