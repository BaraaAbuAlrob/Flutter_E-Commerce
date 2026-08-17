import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

class LabelWithTextFieldNewCard extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const LabelWithTextFieldNewCard({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.maxLength,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<LabelWithTextFieldNewCard> createState() =>
      _LabelWithTextFieldNewCardState();
}

class _LabelWithTextFieldNewCardState
    extends State<LabelWithTextFieldNewCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          validator: widget.validator ??
              (value) => value == null || value.isEmpty
                  ? '${widget.label} cannot be empty!'
                  : null,
          decoration: InputDecoration(
            counterText: '',
            prefixIcon: Icon(widget.icon),
            prefixIconColor: AppColors.grey,
            hintText: widget.hintText,
            fillColor: AppColors.grey100,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
