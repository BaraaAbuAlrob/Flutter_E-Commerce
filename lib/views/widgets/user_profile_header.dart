import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

class UserProfileHeader extends StatelessWidget {
  final String? avatarUrl;
  final String? userName;
  final String? subtitle;

  const UserProfileHeader({
    super.key,
    this.avatarUrl,
    this.userName,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    final resolvedName = userName ??
        (currentUser?.displayName?.isNotEmpty == true
            ? currentUser!.displayName!
            : (currentUser?.email?.split('@').first ?? 'User'));

    final resolvedPhoto = avatarUrl ?? currentUser?.photoURL;
    final resolvedSubtitle = subtitle ?? 'Let\'s go shopping!';

    final initialLetter = resolvedName.isNotEmpty
        ? resolvedName[0].toUpperCase()
        : 'U';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.authPrimaryLight,
          backgroundImage: (resolvedPhoto != null && resolvedPhoto.isNotEmpty)
              ? CachedNetworkImageProvider(resolvedPhoto)
              : null,
          child: (resolvedPhoto == null || resolvedPhoto.isEmpty)
              ? Text(
                  initialLetter,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.authPrimary,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              resolvedName,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: AppColors.black87,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              resolvedSubtitle,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.grey500,
                    fontSize: 12.0,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
