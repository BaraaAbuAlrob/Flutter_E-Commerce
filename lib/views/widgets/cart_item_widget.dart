import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/cart_cubit/cart_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/counter_widget.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_confirm_dialog.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_snack_bar.dart';

class CartItemWidget extends StatelessWidget {
  final AddToCartModel cartItem;
  final bool showCheckbox;
  final bool showCounter;
  final bool showDelete;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final EdgeInsetsGeometry? margin;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    this.showCheckbox = false,
    this.showCounter = true,
    this.showDelete = true,
    this.onTap,
    this.onDelete,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = (showCounter || showCheckbox || showDelete)
        ? BlocProvider.of<CartCubit>(context)
        : null;
    final colorObj = AppColors.getColorByName(cartItem.color.name);

    return Container(
      margin:
          margin ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.grey200, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowSubtle,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap:
              onTap ??
              ((showCheckbox && cubit != null)
                  ? () => cubit.toggleItemSelection(cartItem.id)
                  : null),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Checkbox لتحديد المنتج (يظهر فقط عند تفعيل النمط)
                if (showCheckbox)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(right: 12.0),
                    decoration: BoxDecoration(
                      color: cartItem.isSelected
                          ? (Theme.of(context).primaryColor)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(
                        color: cartItem.isSelected
                            ? Theme.of(context).primaryColor
                            : AppColors.grey300,
                        width: 1.5,
                      ),
                    ),
                    child: cartItem.isSelected
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: AppColors.white,
                          )
                        : null,
                  ),

                // صورة المنتج في حاوية أنيقة
                Container(
                  width: 90,
                  height: 90,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: cartItem.product.imgUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 14.0),

                // تفاصيل المنتج
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم المنتج وأيقونة الحذف في الزاوية
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              cartItem.product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (showDelete)
                            InkWell(
                              onTap:
                                  onDelete ??
                                  (cubit != null
                                      ? () async {
                                          final shouldDelete =
                                              await CustomConfirmDialog.show(
                                            context: context,
                                            title: 'Remove Item?',
                                            message:
                                                'Are you sure you want to remove "${cartItem.product.name}" from your cart?',
                                            confirmText: 'Remove',
                                            cancelText: 'Cancel',
                                          );
                                          if (shouldDelete == true &&
                                              context.mounted) {
                                            cubit.deleteItem(cartItem.id);
                                            CustomSnackBar.showInfo(
                                              context,
                                              message:
                                                  '${cartItem.product.name} removed from cart',
                                              duration:
                                                  const Duration(seconds: 2),
                                            );
                                          }
                                        }
                                      : null),
                              borderRadius: BorderRadius.circular(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 20,
                                  color: AppColors.grey500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4.0),

                      // الحجم (Size) واللون (Color) المختار
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Size
                          Text.rich(
                            TextSpan(
                              text: 'Size: ',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.grey500),
                              children: [
                                TextSpan(
                                  text: cartItem.size.name.toUpperCase(),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black87,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4.0),

                          // Color
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'Color: ',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.grey500),
                                  children: [
                                    TextSpan(
                                      text: cartItem.color.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.black87,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (colorObj != null) ...[
                                const SizedBox(width: 6.0),
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: colorObj,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.grey300,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),

                      // عداد الكمية والسعر
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (showCounter && cubit != null)
                            CounterWidget(
                              value: cartItem.quantity,
                              productId: cartItem.id,
                              cubit: cubit,
                            )
                          else
                            const SizedBox.shrink(),
                          Text(
                            '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black87,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
