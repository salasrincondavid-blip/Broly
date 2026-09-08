import 'package:flutter/material.dart';
import 'package:broly_1_1/features/deals/data/models/deal_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DealCard extends StatelessWidget {
  final DealModel deal;

  const DealCard({super.key, required this.deal});

  Future<void> _openDealUrl(BuildContext context) async {
    final url = Uri.parse('https://www.cheapshark.com/redirect?dealID=${deal.dealID}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace de la oferta')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDealUrl(context),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  deal.thumb,
                  width: 90,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 90,
                    height: 60,
                    color: Colors.grey[800],
                    child: const Icon(Icons.videogame_asset, color: Colors.white54),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deal.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (deal.savings != '0') ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00CEC9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '-${deal.savings}%',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          '\$${deal.normalPrice}',
                          style: const TextStyle(
                            color: Colors.white38,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '\$${deal.salePrice}',
                          style: const TextStyle(
                            color: Color(0xFF6C5CE7),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white38, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
