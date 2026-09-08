import 'package:flutter/material.dart';
import 'package:broly_1_1/features/deals/data/models/deal_model.dart';
import 'package:broly_1_1/features/deals/presentation/screens/deal_details_screen.dart';

class DealCard extends StatelessWidget {
  final DealModel deal;

  const DealCard({super.key, required this.deal});

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DealDetailsScreen(deal: deal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToDetails(context),
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
                    color: const Color(0xff182f22),
                    child: const Icon(Icons.videogame_asset, color: Color(0xff3eef7c)),
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
                              color: const Color(0xff38ed7a),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '-${deal.savings}%',
                              style: const TextStyle(
                                color: Color(0xff06200d),
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
                            color: Color(0xff55ee8b),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xff3eef7c), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
