import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models/add_new_card_cubit/payment_methods_cubit.dart';
import 'package:flutter_ecommerce_app/view_models/checkout_cubit/checkout_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/cart_item_widget.dart';
import 'package:flutter_ecommerce_app/views/widgets/checkout_headlines_item.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_bottom_sheet.dart';
import 'package:flutter_ecommerce_app/views/widgets/empty_shipping_payment.dart';
import 'package:flutter_ecommerce_app/views/widgets/payment_method_bottom_sheet.dart';
import 'package:flutter_ecommerce_app/views/widgets/payment_method_item.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  Widget _buildPaymentMethodItem(
    PaymentCardModel? chosenCard,
    BuildContext context,
  ) {
    if (chosenCard != null) {
      return PaymentMethodItem(
        paymentCard: chosenCard,
        onItemTapped: () async {
          final checkoutCubit = BlocProvider.of<CheckoutCubit>(context);
          final selected = await showCustomBottomSheet<PaymentCardModel>(
            context: context,
            title: 'Payment Methods',
            subtitle: 'Select your preferred payment card',
            child: BlocProvider(
              create: (context) {
                final cubit = PaymentMethodsCubit();
                cubit.fetchPaymentMethods(chosenCard);
                return cubit;
              },
              child: const PaymentMethodBottomSheet(),
            ),
          );
          if (selected != null) {
            checkoutCubit.changePaymentMethod(selected);
          }
        },
      );
    } else {
      final checkoutCubit = BlocProvider.of<CheckoutCubit>(context);
      return EmptyShippingAndPayment(
        title: 'Add Payment Method',
        onTab: () async {
          final result = await Navigator.of(context)
              .pushNamed(AppRoutes.addNewCardRoute);
          if (result is PaymentCardModel) {
            checkoutCubit.changePaymentMethod(result);
          } else {
            checkoutCubit.getCartItems();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = CheckoutCubit();
        cubit.getCartItems();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: Builder(
          builder: (context) {
            final cubit = BlocProvider.of<CheckoutCubit>(context);

            return BlocBuilder<CheckoutCubit, CheckoutState>(
              bloc: cubit,
              buildWhen: (previous, current) =>
                  current is CheckoutLoaded ||
                  current is CheckoutLoading ||
                  current is CheckoutError,
              builder: (context, state) {
                if (state is CheckoutLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is CheckoutError) {
                  return Center(child: Text(state.message));
                } else if (state is CheckoutLoaded) {
                  final cartItems = state.checkoutItems;
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            CheckoutHeadlinesItem(
                              title: 'Address',
                              onTap: () {},
                            ),
                            const SizedBox(height: 16.0),
                            EmptyShippingAndPayment(
                              title: 'Add shipping address',
                              onTab: () {},
                            ),
                            const SizedBox(height: 16.0),
                            CheckoutHeadlinesItem(
                              title: 'Products',
                              numOfProducts: state.numOfProducts,
                            ),
                            const SizedBox(height: 16.0),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final cartItem = cartItems[index];
                                return CartItemWidget(
                                  cartItem: cartItem,
                                  showCounter: false,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6.0,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16.0),
                            CheckoutHeadlinesItem(title: 'Payment'),
                            const SizedBox(height: 16.0),
                            _buildPaymentMethodItem(
                              state.chosenPaymentCard,
                              context,
                            ),
                            const SizedBox(height: 16.0),
                            Divider(color: AppColors.grey200),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: AppColors.grey),
                                ),
                                Text(
                                  '\$${state.totalAmount.toStringAsFixed(1)}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 40.0),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).primaryColor,
                                  foregroundColor: AppColors.white,
                                ),
                                child: const Text(
                                  'Proceed to Buy',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('Something went wrong!'));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
