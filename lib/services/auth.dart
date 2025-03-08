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

      // E-posta doğrulaması kontrolü
      if (!userCredential.user!.emailVerified) {
        await signOut(); // Doğrulanmamış kullanıcıyı oturumdan çıkar
        throw 'Lütfen önce e-posta adresinizi doğrulayın. Doğrulama bağlantısı için e-postanızı kontrol edin.';
      }

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

      // Kullanıcıya doğrulama e-postası gönder
      await userCredential.user!.sendEmailVerification();

      // Doğrulama yapılana kadar oturumu kapat
      await signOut();

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

  // Doğrulama e-postasını yeniden gönder
  Future<void> sendVerificationEmail() async {
    try {
      // Firebase'e geçici olarak giriş yapmak için mevcut kullanıcı bilgileri gerekebilir
      // Bu bilgiler uygulama tarafında güvenli bir şekilde saklanmalıdır
      // Alternatif bir yaklaşım, kullanıcıdan e-posta/şifre alıp geçici giriş yapıp e-posta göndermektir
      User? user = _auth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      } else {
        throw 'Doğrulama e-postası gönderilemedi. Lütfen giriş yapın ve tekrar deneyin.';
      }
    } catch (e) {
      throw 'Doğrulama e-postası gönderilirken hata: $e';
    }
  }

  // E-posta doğrulanmış mı kontrol et
  Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
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

// 'AuthProvider' adını 'CustomAuthProvider' olarak değiştirdik
// Bu Firebase Auth ile adlandırma çakışmasını çözer
class CustomAuthProvider extends InheritedWidget {
  final AuthService auth;

  const CustomAuthProvider({
    Key? key,
    required this.auth,
    required Widget child,
  }) : super(key: key, child: child);

  static AuthService of(BuildContext context) {
    final CustomAuthProvider? provider = context.dependOnInheritedWidgetOfExactType<CustomAuthProvider>();
    if (provider == null) {
      throw FlutterError('CustomAuthProvider bulunamadı');
    }
    return provider.auth;
  }

  @override
  bool updateShouldNotify(CustomAuthProvider oldWidget) {
    return false; // AuthService değişmediği için false
  }
}