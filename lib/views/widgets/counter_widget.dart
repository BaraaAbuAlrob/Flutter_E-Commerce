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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.greyWithShade300,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => cubit.decrementCounter(productId),
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Icon(
                    Icons.minimize_rounded,
                    color: value > 1
                        ? Theme.of(context).primaryColor
                        : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(width: 16.0),
          IconButton(
            onPressed: () => cubit.incrementCounter(productId),
            icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
