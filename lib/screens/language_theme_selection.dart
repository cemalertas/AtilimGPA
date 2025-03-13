import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_navigation.dart';
import '../main.dart'; // Global fonksiyonlar için

class LanguageThemeSelectionScreen extends StatefulWidget {
  final bool isFirstLaunch;

  const LanguageThemeSelectionScreen({
    Key? key,
    this.isFirstLaunch = true,
  }) : super(key: key);

  @override
  State<LanguageThemeSelectionScreen> createState() => _LanguageThemeSelectionScreenState();
}

class _LanguageThemeSelectionScreenState extends State<LanguageThemeSelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isDarkMode = false;
  String _selectedLanguage = 'tr'; // Default dil Türkçe
  bool _isLoading = false;

  final List<Map<String, dynamic>> languages = [
    {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
    _loadPreferences();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Mevcut tercihleri yükle
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'tr';
    });
  }

  // Tercihleri kaydet
  Future<void> _savePreferences() async {
    setState(() {
      _isLoading = true;
    });

    // SharedPreferences'a kaydet
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
    await prefs.setString('language', _selectedLanguage);

    // Global fonksiyonlar aracılığıyla ana uygulamayı güncelle
    if (globalUpdateTheme != null) {
      globalUpdateTheme!(_isDarkMode);
    }

    if (globalUpdateLanguage != null) {
      globalUpdateLanguage!(_selectedLanguage);
    }

    if (!mounted) return;

    // Ana ekrana yönlendir
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MainNavigationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isDarkMode
                ? [const Color(0xFF1A1A1A), const Color(0xFF303030)]
                : [const Color(0xFFFAFAFA), const Color(0xFFECECEC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),

                // Başlık
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.5),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeOutQuad,
                  )),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Text(
                      widget.isFirstLaunch ? "Hoş Geldiniz!" : "Ayarlar",
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeOutQuad,
                  )),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Text(
                      widget.isFirstLaunch
                          ? "Uygulamayı kullanmaya başlamadan önce tercihleri ayarlayın."
                          : "Tema ve dil tercihlerinizi değiştirin.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: _isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Tema seçimi
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(0.2, 0.7, curve: Curves.easeOutQuad),
                  )),
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.2, 0.7),
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tema",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: _isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tema kartları
                        Row(
                          children: [
                            Expanded(
                              child: _buildThemeCard(
                                title: "Açık Tema",
                                icon: Icons.light_mode,
                                isSelected: !_isDarkMode,
                                onTap: () {
                                  setState(() {
                                    _isDarkMode = false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildThemeCard(
                                title: "Koyu Tema",
                                icon: Icons.dark_mode,
                                isSelected: _isDarkMode,
                                onTap: () {
                                  setState(() {
                                    _isDarkMode = true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Dil seçimi
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(0.3, 0.8, curve: Curves.easeOutQuad),
                  )),
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.3, 0.8),
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dil / Language",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: _isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Dil kartları
                        Row(
                          children: languages.map((language) {
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: language == languages.last ? 0 : 16,
                                ),
                                child: _buildLanguageCard(
                                  code: language['code'],
                                  name: language['name'],
                                  flag: language['flag'],
                                  isSelected: _selectedLanguage == language['code'],
                                  onTap: () {
                                    setState(() {
                                      _selectedLanguage = language['code'];
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Devam butonu
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(0.4, 0.9, curve: Curves.easeOutQuad),
                  )),
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.4, 0.9),
                    )),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _savePreferences,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isDarkMode ? Colors.white : Colors.black,
                          foregroundColor: _isDarkMode ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 6,
                          shadowColor: _isDarkMode
                              ? Colors.white.withOpacity(0.2)
                              : Colors.black.withOpacity(0.4),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                          widget.isFirstLaunch ? 'BAŞLA' : 'KAYDET',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Tema kartı widget'ı
  Widget _buildThemeCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? (_isDarkMode ? Colors.white12 : Colors.black.withOpacity(0.05))
              : (_isDarkMode ? Colors.black26 : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (_isDarkMode ? Colors.white : Colors.black)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isDarkMode
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: _isDarkMode ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dil kartı widget'ı
  Widget _buildLanguageCard({
    required String code,
    required String name,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (_isDarkMode ? Colors.white12 : Colors.black.withOpacity(0.05))
              : (_isDarkMode ? Colors.black26 : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (_isDarkMode ? Colors.white : Colors.black)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isDarkMode
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}