import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
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

  String? _validateCardNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Card number is required!';
    }
    final cleanNumber = value.replaceAll(' ', '');
    if (!RegExp(r'^\d+$').hasMatch(cleanNumber)) {
      return 'Card number must contain digits only!';
    }
    if (cleanNumber.length < 16) {
      return 'Card number must be 16 digits!';
    }
    return null;
  }

  String? _validateCardHolderName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Card holder name is required!';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return 'Name must be at least 3 characters!';
    }
    if (!RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$').hasMatch(trimmed)) {
      return 'Name must contain letters only!';
    }
    if (!trimmed.contains(' ')) {
      return 'Please enter first and last name!';
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Expiry date is required!';
    }
    if (value.length != 5 || !value.contains('/')) {
      return 'Expiry date must be in MM/YY format!';
    }
    final parts = value.split('/');
    if (parts.length != 2) return 'Invalid expiry date!';

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || month < 1 || month > 12) {
      return 'Month must be between 01 and 12!';
    }
    if (year == null) {
      return 'Invalid year!';
    }

    final now = DateTime.now();
    final currentTwoDigitYear = now.year % 100;
    final currentMonth = now.month;

    if (year < currentTwoDigitYear ||
        (year == currentTwoDigitYear && month < currentMonth)) {
      return 'Card has expired!';
    }
    if (year > currentTwoDigitYear + 25) {
      return 'Invalid expiry year!';
    }

    return null;
  }

  String? _validateCvv(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CVV is required!';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'CVV must contain numbers only!';
    }
    if (value.length != 3) {
      return 'CVV must be exactly 3 digits!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Add New Card')),
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
                            maxLength: 19,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                              CardNumberInputFormatter(),
                            ],
                            validator: _validateCardNumber,
                          ),
                          const SizedBox(height: 20),
                          LabelWithTextFieldNewCard(
                            label: 'Card Holder Name',
                            controller: _cardHolderNameController,
                            icon: Icons.person,
                            hintText: 'Enter full name',
                            keyboardType: TextInputType.name,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\u0600-\u06FF\s]'),
                              ),
                            ],
                            validator: _validateCardHolderName,
                          ),
                          const SizedBox(height: 20),
                          LabelWithTextFieldNewCard(
                            label: 'Expiry Date',
                            controller: _expiryDateController,
                            icon: Icons.date_range,
                            hintText: 'MM/YY',
                            keyboardType: TextInputType.number,
                            maxLength: 5,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              CardExpiryInputFormatter(),
                            ],
                            validator: _validateExpiryDate,
                          ),
                          const SizedBox(height: 20),
                          LabelWithTextFieldNewCard(
                            label: 'CVV',
                            controller: _cvvController,
                            icon: Icons.password,
                            hintText: 'xxx',
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: _validateCvv,
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
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Card added successfully!'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Add Card'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(RegExp(r'\D'), '');

    var formatted = '';
    for (int i = 0; i < newText.length; i++) {
      if (i == 2) {
        formatted += '/';
      }
      formatted += newText[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
