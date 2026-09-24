import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/secrvices/auth_repository.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_confirm_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    final shouldLogout = await CustomConfirmDialog.show(
      context: context,
      title: 'تسجيل الخروج',
      message: 'هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟',
      confirmText: 'تسجيل الخروج',
      cancelText: 'إلغاء',
      icon: Icons.logout_rounded,
      iconColor: AppColors.red,
      confirmButtonColor: AppColors.red,
    );

    if (shouldLogout != true) return;

    if (!mounted) return;
    setState(() {
      _isLoggingOut = true;
    });

    try {
      await AuthRepository.instance.signOut();
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.loginRoute,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoggingOut = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تسجيل الخروج: ${e.toString()}'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : (user?.email?.split('@').first ?? 'المستخدم');
    final userEmail = user?.email ?? 'user@example.com';
    final userPhoto = user?.photoURL;
    final initialLetter = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowMedium,
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.authPrimaryLight,
                      backgroundImage: (userPhoto != null && userPhoto.isNotEmpty)
                          ? CachedNetworkImageProvider(userPhoto)
                          : null,
                      child: (userPhoto == null || userPhoto.isEmpty)
                          ? Text(
                              initialLetter,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.authPrimary,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.grey500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Account Actions
              _buildSectionTitle('Account'),
              const SizedBox(height: 8),
              _buildSettingsCard(
                children: [
                  _buildListTile(
                    icon: Icons.location_on_outlined,
                    title: 'Shipping Addresses',
                    subtitle: 'Manage delivery addresses',
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(AppRoutes.addressRoute);
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildListTile(
                    icon: Icons.settings_outlined,
                    title: 'Settings & Security',
                    subtitle: 'Password, notifications & account',
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(AppRoutes.settingsRoute);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Danger / Sign Out Section
              _buildSettingsCard(
                children: [
                  _buildListTile(
                    icon: Icons.logout_rounded,
                    title: 'Sign Out',
                    titleColor: AppColors.red,
                    iconColor: AppColors.red,
                    showArrow: false,
                    onTap: _handleLogout,
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        if (_isLoggingOut)
          Container(
            color: AppColors.black.withValues(alpha: 0.3),
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.grey600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowSubtle,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    Color? iconColor,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.authPrimary).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.authPrimary, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: titleColor ?? AppColors.black87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.grey500),
            )
          : null,
      trailing: showArrow
          ? const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.grey400,
            )
          : null,
      onTap: onTap,
    );
  }
}
