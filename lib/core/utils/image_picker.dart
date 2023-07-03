import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:twitter_clone_apps/core/helpers/permission_helper.dart';

Future<List<XFile>> handleMultiImagePicker() async {
  await PermissionHelper.requestPermissions([Permission.photos, Permission.storage]);

  final ImagePicker picker = ImagePicker();
  final List<XFile> images = await picker.pickMultiImage();

  return images;
}

Future<XFile?> handleImagePicker() async {
  await PermissionHelper.requestPermissions([Permission.photos, Permission.storage]);

  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  return image;
}
