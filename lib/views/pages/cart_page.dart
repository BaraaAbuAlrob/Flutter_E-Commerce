import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/view_models/cart_cubit/cart_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/cart_item_widget.dart';
import 'package:flutter_ecommerce_app/views/widgets/empty_state_widget.dart';

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

    return BlocBuilder<CartCubit, CartState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          current is CartLoading ||
          current is CartLoaded ||
          current is CartError,
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is CartLoaded) {
          final cartItems = state.cartItems;
          if (cartItems.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty!',
              subtitle: 'Explore products and add them to your cart.',
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
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('Something went wrong!'));
        }
      },
    );
  }
}
