import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Auth state değişikliklerini dinlemek için stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Mevcut kullanıcıyı al
  User? get currentUser => _auth.currentUser;

  // Email ve şifre ile giriş
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Firebase hata kodlarını yönet
      switch (e.code) {
        case 'user-not-found':
          throw 'Bu e-posta adresiyle ilişkili kullanıcı bulunamadı.';
        case 'wrong-password':
          throw 'Şifre yanlış.';
        case 'invalid-email':
          throw 'E-posta adresi geçerli değil.';
        case 'user-disabled':
          throw 'Bu kullanıcı hesabı devre dışı bırakıldı.';
        default:
          throw 'Giriş yapılamadı: ${e.message}';
      }
    } catch (e) {
      throw 'Beklenmeyen bir hata oluştu: $e';
    }
  }

  // Email ve şifre ile yeni hesap oluştur
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Firebase hata kodlarını yönet
      switch (e.code) {
        case 'email-already-in-use':
          throw 'Bu e-posta adresi zaten kullanımda.';
        case 'invalid-email':
          throw 'E-posta adresi geçerli değil.';
        case 'weak-password':
          throw 'Şifre yeterince güçlü değil.';
        case 'operation-not-allowed':
          throw 'E-posta/şifre hesapları etkin değil.';
        default:
          throw 'Kayıt yapılamadı: ${e.message}';
      }
    } catch (e) {
      throw 'Beklenmeyen bir hata oluştu: $e';
    }
  }

  // Çıkış yap
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Şifre sıfırlama e-postası gönder
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw 'E-posta adresi geçerli değil.';
        case 'user-not-found':
          throw 'Bu e-posta adresiyle ilişkili kullanıcı bulunamadı.';
        default:
          throw 'Şifre sıfırlama e-postası gönderilemedi: ${e.message}';
      }
    } catch (e) {
      throw 'Beklenmeyen bir hata oluştu: $e';
    }
  }

  // Anonim giriş
  Future<UserCredential> signInAnonymously() async {
    try {
      final UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw 'Anonim giriş yapılamadı: ${e.message}';
    }
  }
}

// AuthProvider sınıfı - InheritedWidget kullanarak tüm ağaçta auth servisini sağlar
class AuthProvider extends InheritedWidget {
  final AuthService auth;

  const AuthProvider({
    Key? key,
    required this.auth,
    required Widget child,
  }) : super(key: key, child: child);

  static AuthService of(BuildContext context) {
    final AuthProvider? provider = context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    if (provider == null) {
      throw FlutterError('AuthProvider bulunamadı');
    }
    return provider.auth;
  }

  @override
  bool updateShouldNotify(AuthProvider oldWidget) {
    return false; // AuthService değişmediği için false
  }
}

// Şifre resetleme dialog widget'ı
void showPasswordResetDialog(BuildContext context, AuthService authService) {
  final TextEditingController emailController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Şifre Sıfırlama'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('İptal'),
              ),
              TextButton(
                onPressed: isLoading ? null : () async {
                  setState(() {
                    isLoading = true;
                    errorMessage = '';
                  });

                  try {
                    await authService.sendPasswordResetEmail(emailController.text.trim());
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.'),
                      ),
                    );
                  } catch (e) {
                    setState(() {
                      errorMessage = e.toString();
                      isLoading = false;
                    });
                  }
                },
                child: Text('Gönder'),
              ),
            ],
          );
        },
      );
    },
  );
}