import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/features/explore/controller/explore_controller.dart';
import 'package:twitter_clone_apps/features/explore/widgets/search_tile.dart';

class ExploreView extends HookConsumerWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = useState([]);

    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Palette.searchBarColor,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            onSubmitted: (value) async {
              final data = await ref.refresh(searchUserProvider(value).future);
              users.value = data;
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              fillColor: Palette.searchBarColor,
              filled: true,
              enabledBorder: appBarTextFieldBorder,
              focusedBorder: appBarTextFieldBorder,
              hintText: 'Search Twitter',
            ),
          ),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: users.value.length,
        itemBuilder: (BuildContext context, int index) {
          final user = users.value[index];
          return SearchTile(user: user);
        },
      ),
    );
  }
}
