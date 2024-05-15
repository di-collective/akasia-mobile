import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../../app/config/env_config.dart';
import '../../../../../app/observers/logger.dart';
import '../../../../../core/network/http/app_http_client.dart';
import '../../../../../core/ui/extensions/auth_type_extension.dart';
import '../local/auth_local_datasource.dart';

abstract class AuthRemoteDataSource {
  /// Register new user
  ///
  /// [authType] can be [AuthType.emailPassword], [AuthType.google], [AuthType.apple]
  ///
  /// [email] and [password] are required if [authType] is [AuthType.emailPassword]
  ///
  /// return: [UserCredential] if success, [null] if cancelled
  Future<UserCredential?> signUp({
    required AuthType authType,
    String? name,
    String? email,
    String? password,
  });

  /// Sign in user
  ///
  /// [authType] can be [AuthType.emailPassword], [AuthType.google], [AuthType.apple]
  ///
  /// [email] and [password] are required if [authType] is [AuthType.emailPassword]
  ///
  /// return: [UserCredential] if success, [null] if cancelled
  Future<UserCredential?> signIn({
    required AuthType authType,
    String? email,
    String? password,
  });
  Future<void> resetPassword({
    required String email,
  });
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  });
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final AppHttpClient appHttpClient;
  final AuthLocalDataSource authLocalDataSource;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.appHttpClient,
    required this.authLocalDataSource,
  });

  @override
  Future<UserCredential?> signUp({
    required AuthType authType,
    String? name,
    String? email,
    String? password,
  }) async {
    UserCredential? userCredential;

    try {
      Logger.info(
          'signUp params: authType $authType, email $email, password $password');

      String? displayName;
      switch (authType) {
        case AuthType.emailPassword:
          if (email != null && password != null) {
            userCredential = await firebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );

            displayName = name;
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

            displayName = googleSignIn.currentUser?.displayName;
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

            displayName = credential.givenName;
          }
      }
      Logger.success('signUp userCredential: $userCredential');

      // check is new user
      if (userCredential?.additionalUserInfo?.isNewUser == false) {
        // sign out from firebase auth
        await signOut();

        // throw already registered exception
        throw FirebaseAuthException(code: "already-registered");
      }

      if (userCredential != null) {
        // update name on firebase auth
        Logger.info('signUp displayName: $displayName');
        if (displayName != null) {
          await userCredential.user?.updateDisplayName(
            displayName,
          );
          Logger.success('signUp updateDisplayName displayName: $displayName');
        }

        // TODO: Submit user data to backend
      }

      return userCredential;
    } catch (error) {
      Logger.error('signUp error: $error');

      // check is new user
      if (userCredential?.additionalUserInfo?.isNewUser == true) {
        // if new user, delete created account
        await userCredential?.user?.delete();

        // sign out
        await signOut();
      }

      rethrow;
    }
  }

  @override
  Future<UserCredential?> signIn({
    required AuthType authType,
    String? email,
    String? password,
  }) async {
    UserCredential? userCredential;

    try {
      Logger.info('signIn params: email $email, password $password');

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

      if (userCredential != null) {
        // check is new user
        if (userCredential.additionalUserInfo?.isNewUser == true) {
          // delete user from firebase
          await userCredential.user?.delete();

          // sign out
          await signOut();

          // throw not registered exception
          throw FirebaseAuthException(code: "not-registered");
        }

        // request get access token to backend
        final idToken = await userCredential.user?.getIdToken();
        if (idToken == null) {
          throw FirebaseAuthException(code: 'invalid-id-token');
        }
        final result = await appHttpClient.post(
          url: "${EnvConfig.baseAkasiaApiUrl}/credentials/firebase-auth",
          queryParameters: {
            'idToken': idToken,
          },
        );
        Logger.success('signIn getAccessToken result: $result');

        final String? accessToken = result.data['access_token'];
        final String? refreshToken = result.data['refresh_token'];
        if (accessToken == null || refreshToken == null) {
          throw FirebaseAuthException(code: 'invalid-access-token');
        }

        await Future.wait([
          // save access token
          authLocalDataSource.saveAccessToken(
            accessToken: accessToken,
          ),

          // save refresh token
          authLocalDataSource.saveRefreshToken(
            refreshToken: refreshToken,
          ),
        ]);
      }

      return userCredential;
    } catch (error) {
      Logger.error('signIn error: $error');

      if (userCredential != null) {
        // sign out
        await signOut();
      }

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
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    try {
      Logger.info(
          'confirmPasswordReset params: code $code, newPassword $newPassword');

      // confirm password reset
      await firebaseAuth.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );

      Logger.success('confirmPasswordReset success');
    } catch (error) {
      Logger.error('confirmPasswordReset error: $error');

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
