import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:heroicons/heroicons.dart';
import 'package:twitter_clone_apps/common/common.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/features/explore/view/explore_view.dart';
import 'package:twitter_clone_apps/features/tweet/view/create_tweet_view.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/tweet_list.dart';

class HomeView extends HookWidget {
  const HomeView({super.key});

  static route() => MaterialPageRoute(builder: (context) => const HomeView());

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 3);
    final currentIndex = useState(0);

    useEffect(() {
      tabController.animateTo(currentIndex.value);

      return null;
    }, [currentIndex.value]);

    return Scaffold(
      appBar: currentIndex.value == 0 ? const MyAppBar() : null,
      body: IndexedStack(
        index: currentIndex.value,
        children: const [
          TweetList(),
          ExploreView(),
          Center(child: Text('Notifications')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CreateTweetScreen.route());
        },
        shape: const StadiumBorder(),
        child: const HeroIcon(
          HeroIcons.plus,
          size: 24,
          style: HeroIconStyle.solid,
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Palette.backgroundColor,
        currentIndex: currentIndex.value,
        onTap: (value) => currentIndex.value = value,
        items: [
          BottomNavigationBarItem(
            icon: HeroIcon(
              HeroIcons.home,
              style: currentIndex.value == 0 ? HeroIconStyle.mini : HeroIconStyle.outline,
              size: 28,
            ),
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(
              HeroIcons.magnifyingGlass,
              style: currentIndex.value == 1 ? HeroIconStyle.mini : HeroIconStyle.outline,
              size: 28,
            ),
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(
              HeroIcons.bell,
              style: currentIndex.value == 2 ? HeroIconStyle.mini : HeroIconStyle.outline,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
