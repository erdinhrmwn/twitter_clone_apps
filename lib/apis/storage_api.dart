import 'package:appwrite/appwrite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_clone_apps/core/constants/appwrite_constants.dart';
import 'package:twitter_clone_apps/core/providers/appwrite_provider.dart';

part 'storage_api.g.dart';

@riverpod
StorageAPI storageApi(StorageApiRef ref) {
  final storage = ref.read(appwriteStorageProvider);

  return StorageAPI(storage: storage);
}

class StorageAPI {
  final String endpoint = AppwriteConstants.endpoint;
  final String imagesBucketId = AppwriteConstants.imagesBucketId;

  final Storage _storage;

  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImages(List<XFile> images) {
    return Future.wait(
      images.map((image) async {
        final result = await _storage.createFile(
          bucketId: imagesBucketId,
          fileId: ID.unique(),
          file: InputFile.fromPath(
            path: image.path,
            filename: image.name,
            contentType: image.mimeType,
          ),
        );

        return result.$id;
      }),
    );
  }

  String getPreviewUrl(String imageId) {
    return '$endpoint/storage/buckets/$imagesBucketId/files/$imageId/view?project=649a5978d37d1b7167ce';
  }
}
