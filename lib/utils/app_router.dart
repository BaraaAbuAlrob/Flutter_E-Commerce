import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/address_model.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models/add_new_card_cubit/payment_methods_cubit.dart';
import 'package:flutter_ecommerce_app/view_models/address_cubit/address_cubit.dart';
import 'package:flutter_ecommerce_app/view_models/login_cubit/login_cubit.dart';
import 'package:flutter_ecommerce_app/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:flutter_ecommerce_app/view_models/register_cubit/register_cubit.dart';
import 'package:flutter_ecommerce_app/views/pages/add_new_card_page.dart%E2%80%8E.dart';
import 'package:flutter_ecommerce_app/views/pages/address_page.dart';
import 'package:flutter_ecommerce_app/views/pages/checkout_page.dart';
import 'package:flutter_ecommerce_app/views/pages/custom_bottom_navbar.dart';
import 'package:flutter_ecommerce_app/views/pages/login_page.dart';
import 'package:flutter_ecommerce_app/views/pages/product_details_page.dart';
import 'package:flutter_ecommerce_app/views/pages/register_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.loginRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LoginCubit(),
            child: const LoginPage(),
          ),
          settings: settings,
        );
      case AppRoutes.registerRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => RegisterCubit(),
            child: const RegisterPage(),
          ),
          settings: settings,
        );
      case AppRoutes.homePage:
        return MaterialPageRoute(
          builder: (_) => const CustomBottomNavbar(),
          settings: settings,
        );
      case AppRoutes.addNewCardRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => PaymentMethodsCubit(),
            child: const AddNewCardPage(),
          ),
          settings: settings,
        );
      case AppRoutes.checkoutRoute:
        return MaterialPageRoute(
          builder: (_) => const CheckoutPage(),
          settings: settings,
        );
      case AppRoutes.addressRoute:
        final AddressModel? initialAddress =
            settings.arguments as AddressModel?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AddressCubit(),
            child: AddressPage(initialSelectedAddress: initialAddress),
          ),
          settings: settings,
        );
      case AppRoutes.productDetailsPage:
        final String productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) {
              final cubit = ProductDetailsCubit();
              cubit.getProductDetails(productId: productId);
              return cubit;
            },
            child: ProductDetailsPage(productId: productId),
          ),
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
