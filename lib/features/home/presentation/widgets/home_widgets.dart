import 'package:flutter/material.dart';
import 'package:broly_1_1/features/deals/data/models/deal_model.dart';

/// Insignia de porcentaje de descuento reutilizable.
class DiscountBadge extends StatelessWidget {
  final String text;
  final double fontSize;

  const DiscountBadge(this.text, {super.key, this.fontSize = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xff38ed7a),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xff06200d),
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Imagen de juego con placeholder de fallback en caso de error.
class GameImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const GameImage(this.url, {super.key, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Container(
        color: const Color(0xff182f22),
        child: const Center(
          child: Icon(Icons.sports_esports, color: Color(0xff3eef7c)),
        ),
      );
    }
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        color: const Color(0xff182f22),
        child: const Center(
          child: Icon(Icons.videogame_asset, color: Color(0xff3eef7c), size: 22),
        ),
      ),
    );
  }
}

/// Encabezado de la aplicación con logo y botón de acción.
class HomeHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;

  const HomeHeader({super.key, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.sports_esports_rounded, color: Color(0xff3eef7c), size: 24),
        const SizedBox(width: 8),
        const Text(
          'GameSaver',
          style: TextStyle(
            color: Color(0xff3eef7c),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onSearchTap,
          icon: const Icon(Icons.search, size: 22),
          color: const Color(0xffd6e1d8),
          tooltip: 'Buscar ofertas',
        ),
      ],
    );
  }
}

/// Título de sección reutilizable.
class SectionTitle extends StatelessWidget {
  final String title;
  final bool showArrow;
  final VoidCallback? onArrowTap;

  const SectionTitle(this.title, {super.key, this.showArrow = false, this.onArrowTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showArrow ? onArrowTap : null,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xffe4ece5),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (showArrow)
            const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xff3eef7c), size: 14),
        ],
      ),
    );
  }
}

/// Tarjeta grande para el juego destacado en portada.
class FeaturedGameCard extends StatelessWidget {
  final DealModel deal;
  final VoidCallback onTap;

  const FeaturedGameCard({super.key, required this.deal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 1.75,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              GameImage(deal.thumb),
              // Gradiente para resaltar títulos y precios
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.9),
                    ],
                  ),
                ),
              ),
              if (deal.savings != '0')
                Positioned(
                  top: 10,
                  right: 10,
                  child: DiscountBadge('-${deal.savings}%', fontSize: 11),
                ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deal.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (deal.savings != '0') ...[
                          DiscountBadge('-${deal.savings}%'),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          '\$${deal.salePrice}',
                          style: const TextStyle(
                            color: Color(0xff55ee8b),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '\$${deal.normalPrice}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
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
    );
  }
}

/// Tarjeta para el carrusel horizontal de Grandes Ahorros.
class HorizontalDealCard extends StatelessWidget {
  final DealModel deal;
  final VoidCallback onTap;

  const HorizontalDealCard({super.key, required this.deal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: GameImage(deal.thumb),
                  ),
                ),
                if (deal.savings != '0')
                  Positioned(
                    top: 6,
                    right: 6,
                    child: DiscountBadge('-${deal.savings}%', fontSize: 9),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            deal.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xffe3ebe4),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '\$${deal.salePrice}',
                style: const TextStyle(
                  color: Color(0xff55ee8b),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '\$${deal.normalPrice}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Fila para la lista vertical de ofertas / recién agregados.
class RecentGameRow extends StatelessWidget {
  final DealModel deal;
  final VoidCallback onTap;

  const RecentGameRow({super.key, required this.deal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 64,
                height: 44,
                child: GameImage(deal.thumb),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xffe3ebe4),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deal.steamRatingPercent != '0'
                        ? 'Steam: ${deal.steamRatingPercent}% positivo'
                        : 'Oferta Especial',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (deal.savings != '0') ...[
                  DiscountBadge('-${deal.savings}%', fontSize: 10),
                  const SizedBox(height: 3),
                ],
                Text(
                  '\$${deal.salePrice}',
                  style: const TextStyle(
                    color: Color(0xff55ee8b),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
