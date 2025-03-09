import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth.dart';
import 'faculty_selection.dart';
import 'language_theme_selection.dart';
import 'auth_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Sekmeye göre gösterilecek ekranları tanımla
    final List<Widget> _screens = [
      const HomeScreen(),
      const FacultySelectionScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              activeIcon: Icon(Icons.calculate),
              label: 'GPA Hesapla',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Ayarlar',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade400,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
          elevation: 8,
        ),
      ),
    );
  }
}

// Geçici ekranlar
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "GPA Calculator",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [const Color(0xFF1A1A1A), const Color(0xFF121212)]
                : [Colors.white, Colors.grey.shade100],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black.withOpacity(0.6) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.school_rounded,
                  size: 100,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Hoş Geldiniz',
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'GPA Calculator uygulamasını kullanarak akademik başarınızı takip edebilirsiniz.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  // GPA Calculator ekranına yönlendir
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FacultySelectionScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.calculate),
                label: const Text('GPA HESAPLA'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Kullanıcı Adı';
  String _userEmail = 'kullanici@email.com';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final authService = CustomAuthProvider.of(context);
    final currentUser = authService.currentUser;

    if (currentUser != null) {
      setState(() {
        _userEmail = currentUser.email ?? 'kullanici@email.com';
        _userName = currentUser.displayName ?? 'Kullanıcı Adı';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [const Color(0xFF1A1A1A), const Color(0xFF121212)]
                : [Colors.white, Colors.grey.shade100],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.shade100,
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _userName,
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  _userEmail,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white60 : Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                // Diğer profil öğeleri buraya gelecek
                _buildProfileButton(
                  context,
                  icon: Icons.assignment,
                  title: "GPA Geçmişi",
                  onTap: () {
                    // GPA geçmişi ekranına git
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bu özellik henüz eklenmedi'))
                    );
                  },
                ),
                // Diğer profil butonları...
              ],
            ),
          ),
        ),
      ),
    );
  }

// _buildProfileButton metodu değişmedi
}

Widget _buildProfileButton(
    BuildContext context, {
      required IconData icon,
      required String title,
      required VoidCallback onTap,
    }) {
  bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black.withOpacity(0.6) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white12 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode ? Colors.white60 : Colors.grey,
              size: 16,
            )
          ],
        ),
      ),
    ),
  );
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Yerel değişkenler
  bool _isDarkMode = false;
  String _language = 'tr';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Tercihleri yükle
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _language = prefs.getString('language') ?? 'tr';
    });
  }

  // Tema tercihini kaydet
  Future<void> _saveThemePreference(bool isDarkMode) async {
    setState(() {
      _isDarkMode = isDarkMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDarkMode);

    // MyApp state'ine eriş ve tema değişikliğini bildir
    // Bu örnekte doğrudan erişim olmadığı için basitleştirilmiş bir yaklaşım kullanıyoruz
    // Gerçek uygulamada bir callback veya state management kullanın
  }

  // Dil tercihini kaydet
  Future<void> _saveLanguagePreference(String language) async {
    setState(() {
      _language = language;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);

    // MyApp state'ine eriş ve dil değişikliğini bildir
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ayarlar",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [const Color(0xFF1A1A1A), const Color(0xFF121212)]
                : [Colors.white, Colors.grey.shade100],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle("Genel Ayarlar", isDarkMode),
            // Tema ayarı
            _buildSettingItem(
              context,
              icon: Icons.dark_mode,
              title: "Uygulama Teması",
              trailing: Switch.adaptive(
                value: _isDarkMode,
                onChanged: (value) {
                  _saveThemePreference(value);
                },
                activeColor: isDarkMode ? Colors.white : Colors.black,
                activeTrackColor: isDarkMode ? Colors.white24 : Colors.black38,
              ),
            ),

            // Dil ayarı
            _buildSettingItem(
              context,
              icon: Icons.language,
              title: "Dil",
              subtitle: _language == 'tr' ? "Türkçe" : "English",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _buildLanguageSelector(),
                  backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                );
              },
            ),

            _buildSectionTitle("Hesap", isDarkMode),

            // Tema ve dil seçim ekranı
            _buildSettingItem(
              context,
              icon: Icons.color_lens,
              title: "Tema ve Dil Seçimi",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageThemeSelectionScreen(isFirstLaunch: false),
                  ),
                );
              },
            ),

            // Çıkış yap
            _buildSettingItem(
              context,
              icon: Icons.logout,
              title: "Çıkış Yap",
              titleColor: Colors.red,
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white60 : Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? subtitle,
        Color? titleColor,
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black.withOpacity(0.6) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white12 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: titleColor ?? (isDarkMode ? Colors.white : Colors.black),
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? (isDarkMode ? Colors.white : Colors.black87),
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: isDarkMode ? Colors.white60 : Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (onTap != null && trailing == null)
              Icon(
                Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.white60 : Colors.grey,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Dil Seçin",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 25),
          _buildLanguageOption(
            context,
            flag: "🇹🇷",
            name: "Türkçe",
            code: "tr",
            isSelected: _language == 'tr',
            onTap: () {
              _saveLanguagePreference('tr');
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
          _buildLanguageOption(
            context,
            flag: "🇬🇧",
            name: "English",
            code: "en",
            isSelected: _language == 'en',
            onTap: () {
              _saveLanguagePreference('en');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, {
        required String flag,
        required String name,
        required String code,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.shade100)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDarkMode ? Colors.white : Colors.black)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 16),
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// Çıkış dialog fonksiyonu
void _showLogoutDialog(BuildContext context) {
  bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Çıkış Yap',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
          style: GoogleFonts.poppins(
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'İptal',
              style: GoogleFonts.poppins(
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Çıkış işlemi
              final authService = CustomAuthProvider.of(context);
              await authService.signOut();

              // Login ekranına yönlendir
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AuthWrapper()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Çıkış Yap',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      );
    },
  );
}