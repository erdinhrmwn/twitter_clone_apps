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
  final String projectId = AppwriteConstants.projectId;
  final String userPicsBucketId = AppwriteConstants.userPicsBucketId;
  final String tweetImagesBucketId = AppwriteConstants.tweetImagesBucketId;

  final Storage _storage;

  StorageAPI({required Storage storage}) : _storage = storage;

  Future<String> uploadUserPics(XFile image) async {
    final result = await _storage.createFile(
      bucketId: userPicsBucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(
        path: image.path,
        filename: image.name,
        contentType: image.mimeType,
      ),
    );

    return result.$id;
  }

  Future<List<String>> uploadTweetImages(List<XFile> images) {
    return Future.wait(
      images.map((image) async {
        final result = await _storage.createFile(
          bucketId: tweetImagesBucketId,
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

  String getUserPicsUrl(String imageId) {
    return '$endpoint/storage/buckets/$userPicsBucketId/files/$imageId/view?project=$projectId';
  }

  String getTweetPreviewUrl(String imageId) {
    return '$endpoint/storage/buckets/$tweetImagesBucketId/files/$imageId/view?project=$projectId';
  }
}
