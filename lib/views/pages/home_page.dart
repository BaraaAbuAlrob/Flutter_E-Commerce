import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/views/widgets/categories_tab_view.dart';

import '../widgets/home_tab_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: CachedNetworkImageProvider(
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
                                .copyWith(color: AppColors.grey),
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
              TabBar(
                controller: _tabController,
                unselectedLabelColor: AppColors.grey,
                tabs: const [
                  Tab(text: 'Home'),
                  Tab(text: 'Categories'),
                ],
              ),
              const SizedBox(height: 24.0),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [HomeTabView(), CategoriesTabView()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
