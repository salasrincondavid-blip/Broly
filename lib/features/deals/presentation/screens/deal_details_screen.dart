import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:broly_1_1/features/deals/data/models/deal_model.dart';

class DealDetailsScreen extends StatefulWidget {
  final DealModel deal;

  const DealDetailsScreen({super.key, required this.deal});

  @override
  State<DealDetailsScreen> createState() => _DealDetailsScreenState();
}

class _DealDetailsScreenState extends State<DealDetailsScreen> {
  bool _isFavorite = false;

  Future<void> _launchUri(Uri uri) async {
    try {
      // Intentar primero con aplicación externa (navegador predeterminado)
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        // Fallback a modo por defecto de la plataforma
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      try {
        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No se pudo abrir el enlace: $e'),
              backgroundColor: const Color(0xFFFF6B6B),
            ),
          );
        }
      }
    }
  }

  Future<void> _openStoreUrl(BuildContext context) async {
    // 1. Intentar enlace de CheapShark si existe dealID
    if (widget.deal.dealID.isNotEmpty) {
      final cheapSharkUri = Uri.parse('https://www.cheapshark.com/redirect?dealID=${widget.deal.dealID}');
      try {
        final launched = await launchUrl(cheapSharkUri, mode: LaunchMode.externalApplication);
        if (launched) return;
      } catch (_) {
        // Continuar al diálogo de opciones alternativas
      }
    }

    // 2. Si falla o no hay dealID, mostrar opciones de compra directas
    if (context.mounted) {
      _showStoreOptions(context);
    }
  }

  void _showStoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1B13),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: Color(0xFF1C3826)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.storefront, color: Color(0xFF3EEF7C)),
                  const SizedBox(width: 10),
                  Text(
                    'Opciones para comprar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF13261B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.open_in_browser, color: Color(0xFF3EEF7C)),
                ),
                title: const Text('Oferta en CheapShark (Redirigir)', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Enlace directo con descuento aplicado', style: TextStyle(color: Color(0xFF8DA494), fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                  final uri = Uri.parse('https://www.cheapshark.com/redirect?dealID=${widget.deal.dealID}');
                  _launchUri(uri);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF13261B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.videogame_asset, color: Color(0xFF66C0F4)),
                ),
                title: const Text('Buscar en Steam Store', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Página oficial de la tienda Steam', style: TextStyle(color: Color(0xFF8DA494), fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                  final uri = Uri.parse('https://store.steampowered.com/search/?term=${Uri.encodeComponent(widget.deal.title)}');
                  _launchUri(uri);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF13261B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.search, color: Color(0xFFFFB800)),
                ),
                title: const Text('Buscar en Google Shopping / Web', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Comparar en todas las tiendas', style: TextStyle(color: Color(0xFF8DA494), fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                  final uri = Uri.parse('https://www.google.com/search?q=${Uri.encodeComponent('${widget.deal.title} comprar videojuego oferta')}');
                  _launchUri(uri);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateSavingsAmount() {
    final normal = double.tryParse(widget.deal.normalPrice) ?? 0.0;
    final sale = double.tryParse(widget.deal.salePrice) ?? 0.0;
    final diff = normal - sale;
    return diff > 0 ? diff : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.deal;
    final savingsAmount = _calculateSavingsAmount();

    return Scaffold(
      backgroundColor: const Color(0xFF09110C),
      appBar: AppBar(
        title: const Text(
          'Detalles del Juego',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? const Color(0xFFFF5252) : const Color(0xFFD6E1D8),
            ),
            tooltip: _isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  backgroundColor: const Color(0xFF13261B),
                  content: Text(
                    _isFavorite ? '¡Agregado a favoritos!' : 'Eliminado de favoritos',
                    style: const TextStyle(color: Color(0xFF3EEF7C)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner principal con gradiente
                    Stack(
                      children: [
                        Container(
                          height: 240,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFF132219),
                          ),
                          child: Image.network(
                            deal.thumb,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFF132219),
                              child: const Center(
                                child: Icon(
                                  Icons.videogame_asset,
                                  size: 80,
                                  color: Color(0xFF3EEF7C),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Sombra degradada para fusionar con el fondo
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFF09110C).withValues(alpha: 0.2),
                                  const Color(0xFF09110C),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Badge de descuento sobre la imagen
                        if (deal.savings != '0')
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3EEF7C),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF3EEF7C).withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                '-${deal.savings}% DESCUENTO',
                                style: const TextStyle(
                                  color: Color(0xFF06200D),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título del juego
                          Text(
                            deal.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tarjeta de Precios y Ahorro
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D1B13),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF1C3826),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Precio en oferta',
                                          style: TextStyle(
                                            color: Color(0xFF8DA494),
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '\$${deal.salePrice} USD',
                                          style: const TextStyle(
                                            color: Color(0xFF3EEF7C),
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'Precio habitual',
                                          style: TextStyle(
                                            color: Color(0xFF8DA494),
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '\$${deal.normalPrice}',
                                          style: const TextStyle(
                                            color: Colors.white38,
                                            fontSize: 18,
                                            decoration: TextDecoration.lineThrough,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (savingsAmount > 0) ...[
                                  const Divider(color: Color(0xFF1C3826), height: 24),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.savings_outlined,
                                        color: Color(0xFF55EE8B),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Ahorras \$${savingsAmount.toStringAsFixed(2)} USD en esta compra',
                                        style: const TextStyle(
                                          color: Color(0xFF55EE8B),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Métricas y Calificaciones
                          const Text(
                            'Información de la oferta',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              // Calificación Steam
                              Expanded(
                                child: _buildInfoCard(
                                  icon: Icons.thumb_up_alt_outlined,
                                  title: 'Opiniones Steam',
                                  value: deal.steamRatingPercent != '0'
                                      ? '${deal.steamRatingPercent}%'
                                      : 'N/D',
                                  color: const Color(0xFF66C0F4),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Deal Rating
                              Expanded(
                                child: _buildInfoCard(
                                  icon: Icons.star_outline_rounded,
                                  title: 'Puntaje Oferta',
                                  value: '${deal.dealRating} / 10',
                                  color: const Color(0xFFFFB800),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Garantía y plataforma
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D1B13),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFF1C3826)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.verified_outlined, color: Color(0xFF3EEF7C), size: 24),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Claves 100% legítimas directas de tiendas autorizadas por CheapShark.',
                                    style: TextStyle(
                                      color: Color(0xFFB0C4B5),
                                      fontSize: 13,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Barra inferior con el botón de compra / comparación
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: Color(0xFF0D1B13),
                border: Border(
                  top: BorderSide(color: Color(0xFF1C3826), width: 1),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _openStoreUrl(context),
                  icon: const Icon(Icons.open_in_new, size: 20),
                  label: const Text(
                    'Ir a la tienda oficial para comparar',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1C3826)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF8DA494),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
