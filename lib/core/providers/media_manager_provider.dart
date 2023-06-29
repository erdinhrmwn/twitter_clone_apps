import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_clone_apps/core/helpers/permission_helper.dart';

part 'media_manager_provider.g.dart';

@riverpod
class MediaManager extends _$MediaManager {
  @override
  List<XFile> build() {
    return [];
  }

  Future<void> handleImagePicker() async {
    await PermissionHelper.requestPermissions([Permission.photos, Permission.storage]);

    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    state = images;
  }
}
