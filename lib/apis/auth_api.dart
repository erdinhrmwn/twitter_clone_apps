import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_clone_apps/core/providers/appwrite_provider.dart';
import 'package:twitter_clone_apps/core/types/types.dart';

part 'auth_api.g.dart';

@riverpod
AuthAPI authApi(AuthApiRef ref) {
  final account = ref.read(appwriteAccountProvider);

  return AuthAPI(account: account);
}

class AuthAPI implements IAuthAPI {
  final Account _account;

  AuthAPI({required Account account}) : _account = account;

  @override
  FutureEither<Session> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _account.createEmailSession(
        email: email,
        password: password,
      );

      return right(user);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  FutureEither<User> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String displayName,
  }) async {
    try {
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: displayName,
      );

      return right(user);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid signOut() async {
    try {
      await _account.deleteSession(sessionId: 'current');

      return right(null);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  Future<User?> currentUser() async {
    try {
      return await _account.get();
    } catch (error) {
      log(error.toString());

      return null;
    }
  }
}

abstract class IAuthAPI {
  Future<User?> currentUser();

  FutureEither<Session> signIn({
    required String email,
    required String password,
  });

  FutureEither<User> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String displayName,
  });

  FutureEitherVoid signOut();
}
