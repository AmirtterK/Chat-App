import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  GoogleSignIn signedIn = GoogleSignIn();
  signInWithGoogle() async {
    await signedIn.disconnect().catchError((_) {
      return null;
    });
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication auth = await user!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
 