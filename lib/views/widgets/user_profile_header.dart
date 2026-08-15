import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

class UserProfileHeader extends StatelessWidget {
  final String avatarPath;
  final String userName;
  final String subtitle;

  const UserProfileHeader({
    super.key,
    this.avatarPath = 'assets/images/home_images/mommy.jpg',
    this.userName = 'Baraa Ahmad AbuAlrob',
    this.subtitle = 'Let\'s go shopping!',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage(avatarPath),
        ),
        const SizedBox(width: 12.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              userName,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.grey500,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
