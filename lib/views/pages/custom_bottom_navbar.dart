import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/cart_cubit/cart_cubit.dart';
import 'package:flutter_ecommerce_app/view_models/home_cubit/home_cubit.dart';
import 'package:flutter_ecommerce_app/views/pages/cart_page.dart';
import 'package:flutter_ecommerce_app/views/pages/favorites_page.dart';
import 'package:flutter_ecommerce_app/views/pages/home_page.dart';
import 'package:flutter_ecommerce_app/views/pages/profile_page.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_app_bar.dart';
import 'package:flutter_ecommerce_app/views/widgets/user_profile_header.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomBottomNavbar extends StatefulWidget {
  const CustomBottomNavbar({super.key});

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  late final PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context, int index) {
    List<Widget> actions;
    switch (index) {
      case 0:
        actions = [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ];
        break;
      case 1:
        actions = [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ];
        break;
      case 2:
        actions = [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          ),
        ];
        break;
      case 3:
        actions = [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ];
        break;
      default:
        actions = [];
    }

    return CustomAppBar(
      centerTitle: false,
      titleWidget: const UserProfileHeader(),
      actions: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    // الألوان المستعملة للتصميم
    final primaryColor = Theme.of(context).primaryColor;
    final inactiveColor = Theme.of(context).disabledColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: _buildAppBar(context, _controller.index),
          body: PersistentTabView(
            controller: _controller,
            tabs: [
              // 1. الصفحة الرئيسية - Home
              PersistentTabConfig(
                screen: BlocProvider(
                  create: (context) {
                    final cubit = HomeCubit();
                    cubit.getHomeData();
                    return cubit;
                  },
                  child: const HomePage(),
                ),
                item: ItemConfig(
                  icon: const Icon(Icons.home),
                  inactiveIcon: const Icon(Icons.home_outlined),
                  title: "Home",
                  activeForegroundColor: primaryColor,
                  inactiveForegroundColor: inactiveColor,
                ),
              ),

              // 2. السلة - Cart
              PersistentTabConfig(
                screen: BlocProvider(
                  create: (context) {
                    final cubit = CartCubit();
                    cubit.getCartItems();
                    return cubit;
                  },
                  child: const CartPage(),
                ),
                item: ItemConfig(
                  icon: const Icon(Icons.shopping_cart),
                  inactiveIcon: const Icon(Icons.shopping_cart_outlined),
                  title: "Cart",
                  activeForegroundColor: primaryColor,
                  inactiveForegroundColor: inactiveColor,
                ),
              ),

              // 3. المفضلة - Favorites
              PersistentTabConfig(
                screen: const FavoritesPage(),
                item: ItemConfig(
                  icon: const Icon(Icons.favorite),
                  inactiveIcon: const Icon(Icons.favorite_border),
                  title: "Favorites",
                  activeForegroundColor: primaryColor,
                  inactiveForegroundColor: inactiveColor,
                ),
              ),

              // 4. الحساب الشخصي - Profile
              PersistentTabConfig(
                screen: const ProfilePage(),
                item: ItemConfig(
                  icon: const Icon(Icons.person),
                  inactiveIcon: const Icon(Icons.person_outline),
                  title: "Profile",
                  activeForegroundColor: primaryColor,
                  inactiveForegroundColor: inactiveColor,
                ),
              ),
            ],

            // تعديل استايل وخصائص الـ Navbar هنا:
            navBarBuilder: (navBarConfig) => Style6BottomNavBar(
              navBarConfig: navBarConfig,
              navBarDecoration: NavBarDecoration(
                padding: const EdgeInsets.all(10),
                color: AppColors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowMedium,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
