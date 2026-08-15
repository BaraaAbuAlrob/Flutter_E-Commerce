import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/views/widgets/empty_state_widget.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.favorite_border_rounded,
      title: 'No Favorites Yet!',
      subtitle: 'Items marked as favorite will appear here.',
    );
  }
}
