import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_clone_apps/core/constants/appwrite_constants.dart';

part 'appwrite_provider.g.dart';

@riverpod
Client appwriteClient(AppwriteClientRef ref) {
  return Client()
    ..setEndpoint(AppwriteConstants.endpoint)
    ..setProject(AppwriteConstants.projectId)
    ..setSelfSigned();
}

@riverpod
Account appwriteAccount(AppwriteAccountRef ref) {
  final client = ref.watch(appwriteClientProvider);

  return Account(client);
}

@riverpod
Databases appwriteDb(AppwriteDbRef ref) {
  final client = ref.watch(appwriteClientProvider);

  return Databases(client);
}

@riverpod
Storage appwriteStorage(AppwriteStorageRef ref) {
  final client = ref.watch(appwriteClientProvider);

  return Storage(client);
}

@riverpod
Realtime appwriteRealtime(AppwriteRealtimeRef ref) {
  final client = ref.watch(appwriteClientProvider);

  return Realtime(client);
}
