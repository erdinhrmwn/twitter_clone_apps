import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone_apps/apis/storage_api.dart';
import 'package:twitter_clone_apps/common/app_loader.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/image_picker.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/user_avatar.dart';
import 'package:twitter_clone_apps/features/user/controller/user_controller.dart';
import 'package:twitter_clone_apps/models/user_model.dart';

class EditProfileView extends HookConsumerWidget {
  const EditProfileView({super.key});

  static route() => MaterialPageRoute(builder: (context) => const EditProfileView());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageApi = ref.read(storageApiProvider);
    final user = ref.watch(currentUserDetailProvider).value;

    final nameTextController = useTextEditingController();
    final bioTextController = useTextEditingController();

    final isLoading = useState(false);

    final profilePic = useState<XFile?>(null);
    final coverPic = useState<XFile?>(null);

    useEffect(() {
      if (user != null) {
        nameTextController.text = user.name;
        bioTextController.text = user.bio;
      }

      return null;
    }, [user]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: AppTextStyles.h4,
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () async {
              try {
                isLoading.value = true;

                UserModel copiedUser = user!.copyWith(
                  name: nameTextController.text,
                  bio: bioTextController.text,
                );

                if (profilePic.value != null) {
                  final url = await storageApi.uploadUserPics(profilePic.value!);
                  copiedUser = user.copyWith(profilePic: url);
                }

                if (coverPic.value != null) {
                  final url = await storageApi.uploadUserPics(coverPic.value!);
                  copiedUser = copiedUser.copyWith(coverPic: url);
                }

                await ref.read(userControllerProvider.notifier).updateUser(user: copiedUser);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                print(e);
              }
            },
            child: Text(
              'Save',
              style: AppTextStyles.body.primary.bold,
            ),
          ),
        ],
      ),
      body: isLoading.value || user == null
          ? const AppLoader()
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          coverPic.value = await handleImagePicker();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: coverPic.value != null
                              ? Image.file(
                                  File(coverPic.value!.path),
                                  fit: BoxFit.fitWidth,
                                )
                              : user.coverPic.isEmpty
                                  ? Container(
                                      color: Palette.blueColor,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: storageApi.getUserPicsUrl(user.coverPic),
                                      fit: BoxFit.fitWidth,
                                    ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 10,
                        child: GestureDetector(
                          onTap: () async {
                            profilePic.value = await handleImagePicker();
                          },
                          child: profilePic.value != null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(File(profilePic.value!.path)),
                                  radius: 35,
                                )
                              : UserAvatar(profilePic: user.profilePic, radius: 35),
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: nameTextController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: AppTextStyles.body,
                    contentPadding: const EdgeInsets.all(18),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: bioTextController,
                  decoration: InputDecoration(
                    hintText: 'Bio',
                    hintStyle: AppTextStyles.body,
                    contentPadding: const EdgeInsets.all(18),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
    );
  }
}
