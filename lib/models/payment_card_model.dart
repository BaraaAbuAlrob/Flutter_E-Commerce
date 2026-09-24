class PaymentCardModel {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;

  PaymentCardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
  });

  String get maskedCardNumber {
    final clean = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (clean.length >= 4) {
      final last4 = clean.substring(clean.length - 4);
      return '•••• •••• •••• $last4';
    }
    return cardNumber;
  }

  String get cardType {
    final clean = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (clean.startsWith('4')) return 'Visa';
    if (clean.startsWith('5') || clean.startsWith('2')) return 'MasterCard';
    if (clean.startsWith('3')) return 'American Express';
    return 'MasterCard';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
    };
  }

  factory PaymentCardModel.fromMap(Map<dynamic, dynamic> map) {
    return PaymentCardModel(
      id: map['id']?.toString() ?? '',
      cardNumber: map['cardNumber']?.toString() ?? '',
      cardHolderName: map['cardHolderName']?.toString() ?? '',
      expiryDate: map['expiryDate']?.toString() ?? '',
      cvv: map['cvv']?.toString() ?? '',
    );
  }
}
