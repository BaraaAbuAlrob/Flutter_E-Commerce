import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/card_input_formatters.dart';
import 'package:flutter_ecommerce_app/utils/card_validators.dart';
import 'package:flutter_ecommerce_app/view_models/add_new_card_cubit/payment_methods_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_app_bar.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_snack_bar.dart';
import 'package:flutter_ecommerce_app/views/widgets/label_with_textfield_new_card.dart';

class AddNewCardPage extends StatefulWidget {
  const AddNewCardPage({super.key});

  @override
  State<AddNewCardPage> createState() => _AddNewCardPageState();
}

class _AddNewCardPageState extends State<AddNewCardPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final cubit = BlocProvider.of<PaymentMethodsCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Add New Card'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: keyboardHeight),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelWithTextFieldNewCard(
                            label: 'Card Number',
                            controller: _cardNumberController,
                            icon: Icons.credit_card,
                            hintText: 'xxxx xxxx xxxx xxxx',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            maxLength: 19,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                              CardNumberInputFormatter(),
                            ],
                            validator: CardValidators.validateCardNumber,
                          ),
                          const SizedBox(height: 20),
                          LabelWithTextFieldNewCard(
                            label: 'Card Holder Name',
                            controller: _cardHolderNameController,
                            icon: Icons.person,
                            hintText: 'Enter full name',
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\u0600-\u06FF\s]'),
                              ),
                            ],
                            validator: CardValidators.validateCardHolderName,
                          ),
                          const SizedBox(height: 20),
                          LabelWithTextFieldNewCard(
                            label: 'Expiry Date',
                            controller: _expiryDateController,
                            icon: Icons.date_range,
                            hintText: 'MM/YY',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            maxLength: 5,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              CardExpiryInputFormatter(),
                            ],
                            validator: CardValidators.validateExpiryDate,
                          ),
                          const SizedBox(height: 20),
                          LabelWithTextFieldNewCard(
                            label: 'CVV',
                            controller: _cvvController,
                            icon: Icons.password,
                            hintText: 'xxx',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            maxLength: 3,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: CardValidators.validateCvv,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
                  bloc: cubit,
                  listenWhen: (previous, current) =>
                      current is AddNewCardFailure ||
                      current is AddNewCardSuccess,
                  listener: (context, state) {
                    if (state is AddNewCardSuccess) {
                      Navigator.pop(context, state.newCard);
                    } else if (state is AddNewCardFailure) {
                      CustomSnackBar.showError(
                        context,
                        message: state.errorMessage,
                      );
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is AddNewCardLoading ||
                      current is AddNewCardFailure ||
                      current is AddNewCardSuccess,
                  builder: (context, state) {
                    if (state is AddNewCardLoading) {
                      return const ElevatedButton(
                        onPressed: null,
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          cubit.addNewCard(
                            _cardNumberController.text,
                            _cardHolderNameController.text,
                            _expiryDateController.text,
                            _cvvController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      child: const Text('Add Card'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
