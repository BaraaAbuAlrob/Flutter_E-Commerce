import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/views/widgets/product_item.dart';

import '../../models/home_carousel_item_model.dart';
import '../../models/product_item_model.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'New Arrivals',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                'See All',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          FlutterCarousel.builder(
            itemCount: dummyHomeCarouselItems.length,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) =>
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 28.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: CachedNetworkImage(
                          imageUrl: dummyHomeCarouselItems[itemIndex].imgUrl,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.error, color: AppColors.red),
                          ),
                        ),
                      ),
                    ),
            options: FlutterCarouselOptions(
              height: 200,
              showIndicator: true,
              autoPlay: true,
              slideIndicator: CircularWaveSlideIndicator(),
            ),
          ),
          const SizedBox(height: 24.0),
          GridView.builder(
            itemCount: dummyProducts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 10,
              mainAxisExtent: 230,
            ),
            itemBuilder: (context, index) {
              return ProductItem(productItem: dummyProducts[index]);
            },
          ),
        ],
      ),
    );
  }
}
