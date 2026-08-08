import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/views/pages/custom_bottom_navbar.dart';
import 'package:flutter_ecommerce_app/views/pages/product_details_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homePage:
        return MaterialPageRoute(
          builder: (_) => const CustomBottomNavbar(),
          settings: settings,
        );
      case AppRoutes.productDetailsPage:
        final String productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsPage(productId: productId),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: const Center(child: Text('Page not found')),
          ),
          settings: settings,
        );
    }
  }
}
