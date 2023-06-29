import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_clone_apps/apis/user_api.dart';
import 'package:twitter_clone_apps/models/user_model.dart';

part 'explore_controller.g.dart';

@riverpod
Future<List<UserModel>> searchUser(SearchUserRef ref, String name) {
  final exploreController = ref.read(exploreControllerProvider.notifier);
  return exploreController.searchUser(name);
}

@riverpod
class ExploreController extends _$ExploreController {
  late UserAPI _userApi;

  @override
  void build() {
    _userApi = ref.read(userApiProvider);
    return;
  }

  Future<List<UserModel>> searchUser(String name) async {
    final users = await _userApi.searchUserByName(name);

    return users.documents.map((e) => UserModel.fromJson(e.data)).toList();
  }
}
