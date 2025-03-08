// department_data.dart
// Contains all department data for Atilim University

class DepartmentData {
  static const String baseUrl = 'https://www.atilim.edu.tr';

  // Map of department codes to their curriculum URLs
  static final Map<String, String> departmentUrls = {
    // Mühendislik Fakültesi
    'compe': '$baseUrl/tr/compe/page/1598/mufredat', // Bilgisayar Mühendisliği
    'eee': '$baseUrl/tr/eee/page/2205/mufredat', // Elektrik-Elektronik Mühendisliği
    'ise': '$baseUrl/tr/ise/page/2198/mufredat', // Bilişim Sistemleri Mühendisliği
    'ce': '$baseUrl/tr/ce/page/2240/mufredat', // İnşaat Mühendisliği
    'ie': '$baseUrl/tr/ie/page/2212/mufredat', // Endüstri Mühendisliği
    'se': '$baseUrl/tr/se/page/2284/mufredat', // Yazılım Mühendisliği
    'me': '$baseUrl/tr/me/page/2256/mufredat', // Makine Mühendisliği
    'mechatronics': '$baseUrl/tr/mechatronics/page/2263/mufredat', // Mekatronik Mühendisliği
    'che': '$baseUrl/tr/che/page/2249/mufredat', // Kimya Mühendisliği
    'energy': '$baseUrl/tr/energy/page/2218/mufredat', // Enerji Sistemleri Mühendisliği
    'ase': '$baseUrl/tr/ase/page/5062/mufredat', // Havacılık ve Uzay Mühendisliği
    'mate': '$baseUrl/tr/mate/page/2270/mufredat', // Metalurji ve Malzeme Mühendisliği
    'ae': '$baseUrl/tr/ae/page/2277/mufredat', // Otomotiv Mühendisliği

    // Sağlık Bilimleri Fakültesi
    'beslenme-ve-diyetetik': '$baseUrl/tr/beslenme-ve-diyetetik/page/3936/mufredat', // Beslenme ve Diyetetik
    'cocuk-gelisimi': '$baseUrl/tr/cocuk-gelisimi/page/5309/mufredat', // Çocuk Gelişimi
    'fizyoterapi-ve-rehabilitasyon': '$baseUrl/tr/fizyoterapi-ve-rehabilitasyon/page/2365/mufredat', // Fizyoterapi ve Rehabilitasyon
    'hemsirelik': '$baseUrl/tr/hemsirelik/page/6131/mufredat', // Hemşirelik
    'odyoloji': '$baseUrl/tr/odyoloji/page/5341/mufredat', // Odyoloji

    // Sivil Havacılık Yüksekokulu
    'shui': '$baseUrl/tr/shui/page/2314/mufredat', // Havacılık Yönetimi
    'plt': '$baseUrl/tr/plt/page/2294/mufredat', // Pilotaj
    'ueeb': '$baseUrl/tr/ueeb/page/2300/mufredat', // Uçak Elektrik ve Elektroniği
    'ugmb': '$baseUrl/tr/ugmb/page/2306/mufredat', // Uçak Gövde ve Motor Bakımı

    // İşletme Fakültesi
    'management': '$baseUrl/tr/management/page/2156/mufredat', // İşletme
    'econ': '$baseUrl/tr/econ/page/2137/mufredat', // İktisat
    'pr': '$baseUrl/tr/pr/page/2130/mufredat', // Halkla İlişkiler ve Reklamcılık
    'maliye': '$baseUrl/tr/maliye/page/2163/mufredat', // Maliye
    'pol': '$baseUrl/tr/pol/page/2170/mufredat', // Siyaset Bilimi ve Kamu Yönetimi
    'tm': '$baseUrl/tr/tm/page/2177/mufredat', // Turizm İşletmeciliği
    'loj': '$baseUrl/tr/loj/page/2191/mufredat', // Uluslararası Ticaret ve Lojistik
    'int': '$baseUrl/tr/int/page/2184/mufredat', // Uluslararası İlişkiler

    // Güzel Sanatlar Tasarım ve Mimarlık Fakültesi
    'grf': '$baseUrl/tr/grf/page/2099/mufredat', // Grafik Tasarım
    'ent': '$baseUrl/tr/ent/page/2093/mufredat', // Endüstriyel Tasarım
    'ict': '$baseUrl/tr/ict/page/2113/mufredat', // İç Mimarlık ve Çevre Tasarımı
    'mim': '$baseUrl/tr/mim/page/2117/mufredat', // Mimarlık
    'mod': '$baseUrl/tr/mod/page/2125/mufredat', // Tekstil ve Moda Tasarımı

    // Hukuk Fakültesi
    'law': '$baseUrl/tr/law/page/2440/mufredat', // Hukuk

    // Fen-Edebiyat Fakültesi
    'enlit': '$baseUrl/tr/enlit/page/1656/mufredat', // İngiliz Dili ve Edebiyatı
    'mtb': '$baseUrl/tr/mtb/page/1758/mufredat', // İngilizce Mütercim ve Tercümanlık
    'math': '$baseUrl/tr/math/page/1704/mufredat', // Matematik
    'psy': '$baseUrl/tr/psy/page/1890/mufredat', // Psikoloji

    // Tıp Fakültesi
    'tip': '$baseUrl/tr/tip/page/4661/mufredat', // Tıp
  };

  // Map of faculties to their departments
  static final Map<String, Map<String, String>> departmentsByFaculty = {
    'Mühendislik Fakültesi': {
      'compe': 'Bilgisayar Mühendisliği',
      'eee': 'Elektrik-Elektronik Mühendisliği',
      'ise': 'Bilişim Sistemleri Mühendisliği',
      'ce': 'İnşaat Mühendisliği',
      'ie': 'Endüstri Mühendisliği',
      'se': 'Yazılım Mühendisliği',
      'me': 'Makine Mühendisliği',
      'mechatronics': 'Mekatronik Mühendisliği',
      'che': 'Kimya Mühendisliği',
      'energy': 'Enerji Sistemleri Mühendisliği',
      'ase': 'Havacılık ve Uzay Mühendisliği',
      'mate': 'Metalurji ve Malzeme Mühendisliği',
      'ae': 'Otomotiv Mühendisliği',
    },
    'Sağlık Bilimleri Fakültesi': {
      'beslenme-ve-diyetetik': 'Beslenme ve Diyetetik',
      'cocuk-gelisimi': 'Çocuk Gelişimi',
      'fizyoterapi-ve-rehabilitasyon': 'Fizyoterapi ve Rehabilitasyon',
      'hemsirelik': 'Hemşirelik',
      'odyoloji': 'Odyoloji',
    },
    'Sivil Havacılık Yüksekokulu': {
      'shui': 'Havacılık Yönetimi',
      'plt': 'Pilotaj',
      'ueeb': 'Uçak Elektrik ve Elektroniği',
      'ugmb': 'Uçak Gövde ve Motor Bakımı',
    },
    'İşletme Fakültesi': {
      'management': 'İşletme',
      'econ': 'İktisat',
      'pr': 'Halkla İlişkiler ve Reklamcılık',
      'maliye': 'Maliye',
      'pol': 'Siyaset Bilimi ve Kamu Yönetimi',
      'tm': 'Turizm İşletmeciliği',
      'loj': 'Uluslararası Ticaret ve Lojistik',
      'int': 'Uluslararası İlişkiler',
    },
    'Güzel Sanatlar Tasarım ve Mimarlık Fakültesi': {
      'grf': 'Grafik Tasarım',
      'ent': 'Endüstriyel Tasarım',
      'ict': 'İç Mimarlık ve Çevre Tasarımı',
      'mim': 'Mimarlık',
      'mod': 'Tekstil ve Moda Tasarımı',
    },
    'Hukuk Fakültesi': {
      'law': 'Hukuk',
    },
    'Fen-Edebiyat Fakültesi': {
      'enlit': 'İngiliz Dili ve Edebiyatı',
      'mtb': 'İngilizce Mütercim ve Tercümanlık',
      'math': 'Matematik',
      'psy': 'Psikoloji',
    },
    'Tıp Fakültesi': {
      'tip': 'Tıp',
    },
  };

  // Get all available department codes
  static List<String> getAllDepartmentCodes() {
    return departmentUrls.keys.toList();
  }

  // Get department URL by code
  static String? getDepartmentUrl(String departmentCode) {
    return departmentUrls[departmentCode];
  }

  // Get faculty name by department code
  static String? getFacultyByDepartmentCode(String departmentCode) {
    for (var faculty in departmentsByFaculty.keys) {
      if (departmentsByFaculty[faculty]!.containsKey(departmentCode)) {
        return faculty;
      }
    }
    return null;
  }

  // Get department name by code
  static String? getDepartmentName(String departmentCode) {
    for (var faculty in departmentsByFaculty.keys) {
      if (departmentsByFaculty[faculty]!.containsKey(departmentCode)) {
        return departmentsByFaculty[faculty]![departmentCode];
      }
    }
    return null;
  }

  // Get all faculties
  static List<String> getAllFaculties() {
    return departmentsByFaculty.keys.toList();
  }

  // Get departments by faculty
  static Map<String, String>? getDepartmentsInFaculty(String faculty) {
    return departmentsByFaculty[faculty];
  }
}