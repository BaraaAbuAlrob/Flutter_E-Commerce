import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/cart_cubit/cart_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/cart_item_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        BlocProvider.of<CartCubit>(context).getCartItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CartCubit>(context);

    if (cubit.state is CartLoaded) {
      final loadedState = cubit.state as CartLoaded;
      if (loadedState.cartItems.length != dummyCart.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            cubit.getCartItems();
          }
        });
      }
    } else if (cubit.state is CartInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          cubit.getCartItems();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        bloc: cubit,
        buildWhen: (previous, current) =>
            current is CartLoading ||
            current is CartLoaded ||
            current is CartError,
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state is CartLoaded) {
            final cartItems = state.cartItems;
            if (cartItems.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: AppColors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your cart is empty!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return CartItemWidget(cartItem: cartItem);
                },
              ),
            );
          } else if (state is CartError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
        },
      ),
    );
  }
}