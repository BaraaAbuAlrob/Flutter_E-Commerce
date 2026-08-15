import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/home_cubit/home_cubit.dart';
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
    return BlocProvider(
      create: (BuildContext context) {
        final homeCubit = HomeCubit();
        homeCubit.getHomeData();
        return homeCubit;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            TabBar(
              controller: _tabController,
              unselectedLabelColor: AppColors.grey,
              tabs: const [
                Tab(text: 'Home'),
                Tab(text: 'Categories'),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [HomeTabView(), CategoriesTabView()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
