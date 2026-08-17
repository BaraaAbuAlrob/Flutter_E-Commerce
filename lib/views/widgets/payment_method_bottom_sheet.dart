import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models/add_new_card_cubit/payment_methods_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/main_button.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  const PaymentMethodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentMethodsCubit = BlocProvider.of<PaymentMethodsCubit>(context);

    return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
      bloc: paymentMethodsCubit,
      buildWhen: (previous, current) =>
          current is FetchedPaymentMethods ||
          current is FetchPaymentMethodsError ||
          current is FetchingPaymentMethods,
      builder: (context, state) {
        if (state is FetchingPaymentMethods) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        } else if (state is FetchedPaymentMethods) {
          final paymentCards = state.paymentCards;
          final selectedCard = state.selectedCard;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: paymentCards.length,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final paymentCard = paymentCards[index];
                          final isSelected = selectedCard?.id == paymentCard.id;

                          return GestureDetector(
                            onTap: () {
                              paymentMethodsCubit.selectPaymentCard(
                                paymentCard,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(14.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.06)
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.grey300,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.15,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    )
                                  else
                                    BoxShadow(
                                      color: AppColors.shadowSubtle,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.grey100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.asset(
                                      'assets/images/payment_methods_images/card.png',
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          paymentCard.cardType,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          paymentCard.maskedCardNumber,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? AppColors.black
                                                : AppColors.grey500,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${paymentCard.cardHolderName} • Exp ${paymentCard.expiryDate}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.grey400,
                                        width: isSelected ? 0 : 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check_rounded,
                                            size: 16,
                                            color: AppColors.white,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Add New Card Tile
                      InkWell(
                        onTap: () async {
                          final addedCard = await Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.addNewCardRoute);
                          if (addedCard is PaymentCardModel) {
                            paymentMethodsCubit.fetchPaymentMethods(addedCard);
                          } else {
                            paymentMethodsCubit.fetchPaymentMethods(
                              dummyPaymentCards.isNotEmpty
                                  ? dummyPaymentCards.last
                                  : selectedCard,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            color: AppColors.grey100.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: AppColors.grey300,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Add New Card',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Save a new payment card for checkout',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: AppColors.grey400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Sticky Bottom Confirm Button
              Container(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 12.0,
                  bottom: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(color: AppColors.grey200, width: 1),
                  ),
                ),
                child: MainButton(
                  text: 'Confirm Payment',
                  onTap: () {
                    Navigator.of(context).pop(selectedCard);
                  },
                ),
              ),
            ],
          );
        } else if (state is FetchPaymentMethodsError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: AppColors.red),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
