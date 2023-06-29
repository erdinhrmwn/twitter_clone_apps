import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/apis/storage_api.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';

class CarouselImage extends HookConsumerWidget {
  const CarouselImage({super.key, required this.imageLinks});

  final List<String> imageLinks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageApi = ref.read(storageApiProvider);

    final currentIndex = useState(0);

    return Column(
      children: [
        CarouselSlider(
          items: imageLinks.map(
            (imageId) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                child: CachedNetworkImage(
                  imageUrl: storageApi.getPreviewUrl(imageId),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
          options: CarouselOptions(
            height: 200,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              currentIndex.value = index;
            },
          ),
        ),
        AnimatedSmoothIndicator(
          count: imageLinks.length,
          activeIndex: currentIndex.value,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            dotColor: Palette.greyColor,
            activeDotColor: Palette.whiteColor,
          ),
        ),
      ],
    );
  }
}
