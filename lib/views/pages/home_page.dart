import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_ecommerce_app/models/home_carousel_item_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/views/widgets/product_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            'https://res.cloudinary.com/dbahe7lxz/image/upload/v1785859558/idraaak/qqyxqerw3sc7esxsmeqb.jpg',
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Baraa AbuAlrob',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              'Let\'s go shopping!',
                              style: Theme.of(context).textTheme.labelSmall!
                                  .copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'New Arrivals',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
                      (
                        BuildContext context,
                        int itemIndex,
                        int pageViewIndex,
                      ) => Padding(
                        padding: const EdgeInsetsDirectional.only(end: 28.0),
                        child: Image.network(
                          dummyHomeCarouselItems[itemIndex].imgUrl,
                          fit: BoxFit.fill,
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
          ),
        ),
      ),
    );
  }
}
