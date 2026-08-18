import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models/cart_cubit/cart_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/cart_item_widget.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_app_bar.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_confirm_dialog.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_snack_bar.dart';
import 'package:flutter_ecommerce_app/views/widgets/empty_state_widget.dart';

class CartPage extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const CartPage({super.key, this.onBackToHome});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _handleBack(BuildContext context) {
    if (widget.onBackToHome != null) {
      widget.onBackToHome!();
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
    }
  }

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
      final currentSubtotal = dummyCart.fold<double>(
        0,
        (prev, item) => prev + item.totalPrice,
      );
      final currentTotalQty = dummyCart.fold<int>(
        0,
        (prev, item) => prev + item.quantity,
      );
      final loadedTotalQty = loadedState.cartItems.fold<int>(
        0,
        (prev, item) => prev + item.quantity,
      );

      if (loadedState.cartItems.length != dummyCart.length ||
          loadedTotalQty != currentTotalQty ||
          loadedState.subtotal != currentSubtotal) {
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          title: 'My Cart',
          leading: IconButton(
            onPressed: () => _handleBack(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.black87,
              size: 20,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<CartCubit, CartState>(
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
                  return const EmptyStateWidget(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Your cart is empty!',
                    subtitle: 'Explore products and add them to your cart.',
                  );
                }
                final double shipping = state.subtotal > 0 ? 10.0 : 0.0;
                final double totalAmount = state.subtotal + shipping;

                return Column(
                  children: [
                    // قائمة المنتجات في السلة
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartItems[index];
                          return Dismissible(
                            key: ValueKey(cartItem.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 6.0,
                              ),
                              padding: const EdgeInsets.only(right: 20.0),
                              decoration: BoxDecoration(
                                color: AppColors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.red,
                                size: 28,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              final shouldDelete =
                                  await CustomConfirmDialog.show(
                                context: context,
                                title: 'Remove Item?',
                                message:
                                    'Are you sure you want to remove "${cartItem.product.name}" from your cart?',
                                confirmText: 'Remove',
                                cancelText: 'Cancel',
                              );
                              return shouldDelete ?? false;
                            },
                            onDismissed: (direction) {
                              cubit.deleteItem(cartItem.id);
                              CustomSnackBar.showInfo(
                                context,
                                message:
                                    '${cartItem.product.name} removed from cart',
                                duration: const Duration(seconds: 2),
                              );
                            },
                            child: CartItemWidget(
                              cartItem: cartItem,
                              onDelete: () async {
                                final shouldDelete =
                                    await CustomConfirmDialog.show(
                                  context: context,
                                  title: 'Remove Item?',
                                  message:
                                      'Are you sure you want to remove "${cartItem.product.name}" from your cart?',
                                  confirmText: 'Remove',
                                  cancelText: 'Cancel',
                                );
                                if (shouldDelete == true && context.mounted) {
                                  cubit.deleteItem(cartItem.id);
                                  CustomSnackBar.showInfo(
                                    context,
                                    message:
                                        '${cartItem.product.name} removed from cart',
                                    duration: const Duration(seconds: 2),
                                  );
                                }
                              },
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: AppColors.grey200,
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                          );
                        },
                      ),
                    ),

                    // قسم الـ Checkout الثابت في الأسفل دائماً
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowStrong,
                            blurRadius: 20,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 12.0,
                        bottom: 20.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Pill handle indicator
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.grey300,
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // حقل ادخال الـ Promo Code
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.stars_outlined,
                                  color: AppColors.grey500,
                                  size: 22,
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Text(
                                    'Enter your promo code',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppColors.grey500),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: AppColors.grey500,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Subtotal
                          totalAndSubtotalWidget(
                            context,
                            title: 'Subtotal',
                            amount: state.subtotal,
                          ),

                          // Shipping
                          totalAndSubtotalWidget(
                            context,
                            title: 'Shipping',
                            amount: shipping,
                          ),
                          const SizedBox(height: 8.0),

                          // Dash separator
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Dash(
                                dashColor: AppColors.grey200,
                                length: constraints.maxWidth,
                                dashGap: 6,
                                dashLength: 6,
                                dashThickness: 1.5,
                              );
                            },
                          ),
                          const SizedBox(height: 8.0),

                          // Total Amount
                          totalAndSubtotalWidget(
                            context,
                            title: 'Total amount',
                            amount: totalAmount,
                            isTotal: true,
                          ),
                          const SizedBox(height: 20.0),

                          // Checkout Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pushNamed(AppRoutes.checkoutRoute);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: const Text(
                                'Checkout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (state is CartError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('Something went wrong!'));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget totalAndSubtotalWidget(
    BuildContext context, {
    required String title,
    required double amount,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isTotal ? AppColors.black87 : AppColors.grey500,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
