class CardValidators {
  static String? validateCardNumber(String? value) {
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

  static String? validateCardHolderName(String? value) {
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

  static String? validateExpiryDate(String? value) {
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

  static String? validateCvv(String? value) {
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
}
