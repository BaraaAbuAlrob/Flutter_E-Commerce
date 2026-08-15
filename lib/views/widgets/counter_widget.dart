import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

class CounterWidget extends StatelessWidget {
  final int value;
  final String productId;
  final dynamic cubit;

  const CounterWidget({
    super.key,
    required this.value,
    required this.productId,
    this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.grey300,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => cubit.decrementCounter(productId),
              icon: Icon(
                Icons.remove_rounded,
                color: value > 1
                    ? Theme.of(context).primaryColor
                    : AppColors.grey400,
                size: 18,
              ),
            ),
            const SizedBox(width: 4.0),
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 4.0),
            IconButton(
              onPressed: () => cubit.incrementCounter(productId),
              icon: Icon(
                Icons.add_rounded,
                color: Theme.of(context).primaryColor,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
