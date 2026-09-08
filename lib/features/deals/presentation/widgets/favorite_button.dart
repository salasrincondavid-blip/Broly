import 'package:flutter/material.dart';
import 'package:broly_1_1/features/auth/data/services/auth_service.dart';
import 'package:broly_1_1/features/deals/data/models/deal_model.dart';

/// Botón de corazón interactivo para agregar/quitar favoritos directamente desde cualquier tarjeta.
class FavoriteButton extends StatelessWidget {
  final DealModel deal;
  final double iconSize;
  final EdgeInsets padding;

  const FavoriteButton({
    super.key,
    required this.deal,
    this.iconSize = 22,
    this.padding = const EdgeInsets.all(6),
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        final isFav = AuthService.instance.isFavorite(deal.dealID);
        return InkWell(
          onTap: () {
            final added = AuthService.instance.toggleFavorite(deal);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 1200),
                backgroundColor: const Color(0xFF13261B),
                content: Text(
                  added
                      ? '¡"${deal.title}" añadido a favoritos!'
                      : 'Removido de favoritos',
                  style: const TextStyle(color: Color(0xFF3EEF7C), fontSize: 13),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: padding,
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? const Color(0xFFFF5252) : Colors.white60,
              size: iconSize,
            ),
          ),
        );
      },
    );
  }
}
