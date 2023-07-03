import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_clone_apps/apis/user_api.dart';
import 'package:twitter_clone_apps/core/enums/notification_type_enum.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/notification/controller/notification_controller.dart';
import 'package:twitter_clone_apps/models/user_model.dart';

part 'user_controller.g.dart';

@riverpod
Stream<RealtimeMessage> streamProfileData(StreamProfileDataRef ref) {
  final userApi = ref.read(userApiProvider);

  return userApi.getLatestUserProfileData();
}

@riverpod
class UserController extends _$UserController {
  late UserModel _currentUser;
  late UserAPI _userApi;
  late NotificationController _notificationController;

  @override
  void build() {
    _currentUser = ref.watch(currentUserDetailProvider).value!;
    _userApi = ref.read(userApiProvider);
    _notificationController = ref.read(notificationControllerProvider.notifier);
  }

  Future<void> followUser({required UserModel user}) async {
    final userFollowers = user.followers.toList();

    if (_currentUser.following.contains(user.uid)) {
      userFollowers.remove(_currentUser.uid);
      _currentUser.following.remove(user.uid);
    } else {
      userFollowers.add(_currentUser.uid);
      _currentUser.following.add(user.uid);
    }

    user = user.copyWith(followers: userFollowers);
    _currentUser = _currentUser.copyWith(following: _currentUser.following);

    final response = await _userApi.handleFollowers(user);

    if (response.isLeft()) {
      return Future.error('Failed to follow user');
    }

    final responseX = await _userApi.handleFollowing(_currentUser);

    if (responseX.isLeft()) {
      return Future.error('Failed to follow user');
    }

    await _notificationController.createNotification(
      uid: user.uid,
      text: '${_currentUser.name} started following you',
      notificationType: NotificationType.follow,
    );
  }

  Future<void> updateUser({required UserModel user}) async {
    final response = await _userApi.updateUserData(user);

    if (response.isLeft()) {
      return Future.error('Failed to update user');
    }
  }
}
