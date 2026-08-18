import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

enum SnackBarType { success, error, warning, info }

class CustomSnackBar {
  static SnackBar build({
    required BuildContext context,
    required String message,
    String? title,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    VoidCallback? onVisible,
  }) {
    Color backgroundColor;
    Color iconColor;
    Color iconBgColor;
    IconData icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = const Color(0xFF1E293B); // Modern slate
        iconColor = const Color(0xFF10B981); // Emerald green
        iconBgColor = const Color(0xFF10B981).withValues(alpha: 0.15);
        icon = Icons.check_circle_rounded;
        break;
      case SnackBarType.error:
        backgroundColor = const Color(0xFF1E293B);
        iconColor = const Color(0xFFEF4444); // Crimson red
        iconBgColor = const Color(0xFFEF4444).withValues(alpha: 0.15);
        icon = Icons.error_rounded;
        break;
      case SnackBarType.warning:
        backgroundColor = const Color(0xFF1E293B);
        iconColor = const Color(0xFFF59E0B); // Amber
        iconBgColor = const Color(0xFFF59E0B).withValues(alpha: 0.15);
        icon = Icons.warning_amber_rounded;
        break;
      case SnackBarType.info:
        backgroundColor = const Color(0xFF1E293B);
        iconColor = AppColors.primary; // Primary blue
        iconBgColor = AppColors.primary.withValues(alpha: 0.15);
        icon = Icons.info_outline_rounded;
        break;
    }

    return SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      duration: duration,
      action: action,
      onVisible: onVisible,
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: title != null
                        ? FontWeight.normal
                        : FontWeight.w500,
                    color: AppColors.white.withValues(alpha: 0.95),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void show(
    BuildContext context, {
    required String message,
    String? title,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      build(
        context: context,
        message: message,
        title: title,
        type: type,
        duration: duration,
        action: action,
      ),
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackBarType.success,
      duration: duration,
      action: action,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackBarType.error,
      duration: duration,
      action: action,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackBarType.warning,
      duration: duration,
      action: action,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackBarType.info,
      duration: duration,
      action: action,
    );
  }
}
