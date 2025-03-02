import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpatwo/screens/department_selection.dart';
import 'package:gpatwo/services/auth.dart';
import 'package:gpatwo/screens/register_screen.dart';

import 'faculty_selection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Auth servisini al
    final authService = AuthProvider.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Arka Plan
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFAFAFA), Color(0xFFECECEC)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Başlık
                    Text(
                      "GPA Calculator",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email Alanı
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email, color: Colors.black45),
                        hintText: "E-posta",
                        hintStyle: GoogleFonts.poppins(color: Colors.black45),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Şifre Alanı
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock, color: Colors.black45),
                        hintText: "Şifre",
                        hintStyle: GoogleFonts.poppins(color: Colors.black45),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Hata mesajı gösterimi
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Şifremi Unuttum
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Şifre sıfırlama dialog'unu göster
                          showPasswordResetDialog(context, authService);
                        },
                        child: Text(
                          "Şifremi Unuttum?",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Giriş Butonu
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: () => _signIn(authService, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 4,
                      ),
                      child: Text(
                        "Giriş Yap",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Modernleştirilmiş Kayıt Ol Butonu
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to RegisterScreen
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterScreen())
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 2,
                        shadowColor: Colors.black.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "Kayıt Ol",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Alternatif Giriş (Anonim)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _signInAnonymously(authService, context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.fingerprint, size: 24, color: Colors.black45),
                                const SizedBox(width: 8),
                                Text(
                                  "Misafir Girişi",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Email/Password ile giriş
  Future<void> _signIn(AuthService authService, BuildContext context) async {
    // Alanların boş olup olmadığını kontrol et
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'E-posta ve şifre gereklidir';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Giriş başarılı, ana ekrana yönlendir
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FacultySelectionScreen(),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Anonim giriş
  Future<void> _signInAnonymously(AuthService authService, BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await authService.signInAnonymously();

      // Giriş başarılı, ana ekrana yönlendir
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FacultySelectionScreen(),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Şifre sıfırlama dialog'u (eksik metodun içeriği eklendi)
  void showPasswordResetDialog(BuildContext context, AuthService authService) {
    final TextEditingController resetEmailController = TextEditingController();
    String resetErrorMessage = '';
    bool isResetting = false;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Şifre Sıfırlama",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Şifrenizi sıfırlamak için e-posta adresinizi girin.",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: resetEmailController,
                      decoration: InputDecoration(
                        hintText: "E-posta adresinizi girin",
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.black45),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    if (resetErrorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          resetErrorMessage,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // İptal Butonu
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black54,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            "İptal",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Gönder Butonu
                        ElevatedButton(
                          onPressed: isResetting
                              ? null
                              : () async {
                            if (resetEmailController.text.isEmpty) {
                              setState(() {
                                resetErrorMessage = "E-posta adresi gereklidir";
                              });
                              return;
                            }

                            setState(() {
                              isResetting = true;
                              resetErrorMessage = '';
                            });

                            try {
                              await authService.sendPasswordResetEmail(
                                resetEmailController.text.trim(),
                              );
                              Navigator.of(context).pop();

                              // Başarılı bildirim
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi",
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: Colors.black,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.all(10),
                                ),
                              );
                            } catch (e) {
                              setState(() {
                                resetErrorMessage = e.toString();
                                isResetting = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: isResetting
                              ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            "Gönder",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}