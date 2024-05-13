import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../../app/observers/logger.dart';
import '../../../../../core/ui/extensions/auth_type_extension.dart';

abstract class AuthRemoteDataSource {
  Future<bool> checkSignInStatus();

  /// Register new user
  ///
  /// [authType] can be [AuthType.emailPassword], [AuthType.google], [AuthType.apple]
  ///
  /// [email] and [password] are required if [authType] is [AuthType.emailPassword]
  Future<UserCredential?> signUp({
    required AuthType authType,
    String? email,
    String? password,
  });
  Future<UserCredential?> signIn({
    required AuthType authType,
    String? email,
    String? password,
  });
  Future<void> resetPassword({
    required String email,
  });
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<bool> checkSignInStatus() async {
    try {
      Logger.info("checkSignInStatus");

      final user = firebaseAuth.currentUser;

      Logger.success("checkSignInStatus user: $user");

      if (user == null) {
        return false;
      }

      return true;
    } catch (error) {
      Logger.error('checkSignInStatus error: $error');

      rethrow;
    }
  }

  @override
  Future<UserCredential?> signUp({
    required AuthType authType,
    String? email,
    String? password,
  }) async {
    try {
      Logger.info(
          'signUp params: authType $authType, email $email, password $password');

      UserCredential? userCredential;
      switch (authType) {
        case AuthType.emailPassword:
          if (email != null && password != null) {
            userCredential = await firebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
          }

          break;
        case AuthType.google:
          final googleSignInAccount = await signInWithGoogle();
          if (googleSignInAccount != null) {
            // obtain auth credential
            final googleAuth = await googleSignInAccount.authentication;

            // get oauth credential
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );

            // sign in with credential
            userCredential = await firebaseAuth.signInWithCredential(
              credential,
            );
          }

          break;
        case AuthType.apple:
          final credential = await signInWithApple();

          if (credential != null) {
            // get oauth credential
            final oAuthProvider = OAuthProvider('apple.com');
            final oAuthCredential = oAuthProvider.credential(
              idToken: credential.identityToken,
              accessToken: credential.authorizationCode,
            );

            // sign in with credential
            userCredential = await firebaseAuth.signInWithCredential(
              oAuthCredential,
            );
          }
      }
      Logger.success('signUp userCredential: $userCredential');

      return userCredential;
    } catch (error) {
      Logger.error('signUp error: $error');

      rethrow;
    }
  }

  @override
  Future<UserCredential?> signIn({
    required AuthType authType,
    String? email,
    String? password,
  }) async {
    try {
      Logger.info('signIn params: email $email, password $password');

      UserCredential? userCredential;

      switch (authType) {
        case AuthType.emailPassword:
          if (email == null || password == null) {
            throw Exception('Email and password must not be null');
          }

          userCredential = await firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          break;
        case AuthType.google:
          final googleSignInAccount = await signInWithGoogle();
          if (googleSignInAccount != null) {
            // obtain auth credential
            final googleAuth = await googleSignInAccount.authentication;

            // get oauth credential
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );

            // sign in with credential
            userCredential = await firebaseAuth.signInWithCredential(
              credential,
            );
          }

          break;
        case AuthType.apple:
          final credential = await signInWithApple();

          if (credential != null) {
            // get oauth credential
            final oAuthProvider = OAuthProvider('apple.com');
            final oAuthCredential = oAuthProvider.credential(
              idToken: credential.identityToken,
              accessToken: credential.authorizationCode,
            );

            // sign in with credential
            userCredential = await firebaseAuth.signInWithCredential(
              oAuthCredential,
            );
          }

          break;
      }

      Logger.success('signIn userCredential: $userCredential');

      // check is new user
      if (userCredential?.additionalUserInfo?.isNewUser == true) {
        // delete user from firebase
        await userCredential?.user?.delete();

        // sign out
        await firebaseAuth.signOut();

        // throw not registered exception
        throw FirebaseAuthException(code: "not-registered");
      }

      return userCredential;
    } catch (error) {
      Logger.error('signIn error: $error');

      rethrow;
    }
  }

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      Logger.info('signInWithGoogle');

      // check i already signed in
      GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signInSilently();

      if (googleSignInAccount != null) {
        // if already signed in, sign out
        await googleSignIn.signOut();
      }

      // sign in
      googleSignInAccount = await googleSignIn.signIn();

      Logger.success(
          'signInWithGoogle googleSignInAccount: $googleSignInAccount');

      return googleSignInAccount;
    } catch (error) {
      Logger.error('signInWithGoogle error: $error');

      rethrow;
    }
  }

  Future<AuthorizationCredentialAppleID?> signInWithApple() async {
    try {
      Logger.info('signInWithApple');

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      Logger.success('signInWithApple credential: $credential');

      return credential;
    } on SignInWithAppleAuthorizationException catch (error) {
      Logger.error(
          'signInWithApple SignInWithAppleAuthorizationException error: $error');

      if (error.code == AuthorizationErrorCode.canceled) {
        return null;
      }

      rethrow;
    } catch (error) {
      Logger.error('signInWithApple error: $error');

      rethrow;
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      Logger.info('resetPassword params: email $email');

      // send password reset email
      await firebaseAuth.sendPasswordResetEmail(
        email: email,
      );

      Logger.success('resetPassword success');
    } catch (error) {
      Logger.error('resetPassword error: $error');

      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      Logger.info("signOut");

      await firebaseAuth.signOut();

      Logger.success("signOut success");
    } catch (error) {
      Logger.error('signOut error: $error');

      rethrow;
    }
  }
}
