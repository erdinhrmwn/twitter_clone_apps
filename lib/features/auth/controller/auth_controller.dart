import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_clone_apps/apis/auth_api.dart';
import 'package:twitter_clone_apps/apis/user_api.dart';
import 'package:twitter_clone_apps/core/types/types.dart';
import 'package:twitter_clone_apps/models/user_model.dart';

part 'auth_controller.g.dart';

@riverpod
Future<User?> currentUser(CurrentUserRef ref) {
  return ref.watch(authControllerProvider.notifier).currentUser();
}

@riverpod
Future<UserModel> currentUserDetail(CurrentUserDetailRef ref) {
  final uid = ref.watch(currentUserProvider).value!.$id;
  return ref.watch(userDetailProvider(uid).future);
}

@riverpod
Future<UserModel> userDetail(UserDetailRef ref, String uid) {
  return ref.watch(authControllerProvider.notifier).getUserData(uid);
}

@riverpod
class AuthController extends _$AuthController {
  late AuthAPI _authApi;
  late UserAPI _userApi;

  @override
  Future<void> build() async {
    _authApi = ref.watch(authApiProvider);
    _userApi = ref.watch(userApiProvider);
  }

  Future<User?> currentUser() => _authApi.currentUser();

  FutureEither<Session> signIn({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return FutureEither.error('All fields must be filled');
    }

    final response = await _authApi.signIn(email: email, password: password);

    return response;
  }

  FutureEither<User> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String displayName,
  }) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || displayName.isEmpty) {
      return FutureEither.error('All fields must be filled');
    }

    if (password != confirmPassword) {
      return FutureEither.error('Password and Confirm Password must be the same');
    }

    final response = await _authApi.signUp(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      displayName: displayName,
    );

    return response.fold(left, (r) async {
      final user = UserModel(
        uid: r.$id,
        name: displayName,
        email: email,
      );

      final res = await _userApi.saveUserData(user);

      return res.fold(left, (_) => right(r));
    });
  }

  FutureEitherVoid signOut() async {
    final response = await _authApi.signOut();

    return response;
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userApi.getUserData(uid);
    final updatedUser = UserModel.fromJson(document.data);

    return updatedUser;
  }
}
