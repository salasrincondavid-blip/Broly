import 'package:flutter/material.dart';
import 'package:broly_1_1/features/deals/data/datasources/cheapshark_remote_datasource.dart';
import 'package:broly_1_1/features/deals/data/models/deal_model.dart';
import 'package:broly_1_1/features/deals/presentation/screens/deal_details_screen.dart';
import 'package:broly_1_1/features/home/presentation/widgets/home_widgets.dart';

class HomeView extends StatefulWidget {
  final VoidCallback? onSearchTap;

  const HomeView({super.key, this.onSearchTap});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final CheapSharkRemoteDataSource _dataSource = CheapSharkRemoteDataSource();
  List<DealModel> _deals = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDeals();
  }

  Future<void> _loadDeals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final deals = await _dataSource.getDeals(pageSize: 10);
      if (mounted) {
        setState(() {
          _deals = deals;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ocurrió un error al cargar las ofertas.';
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToDetails(DealModel deal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DealDetailsScreen(deal: deal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xff3eef7c)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white54, size: 48),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3eef7c),
                  foregroundColor: const Color(0xff06200d),
                ),
                onPressed: _loadDeals,
                child: const Text('Reintentar', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }

    if (_deals.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron ofertas disponibles.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    // Dividimos las ofertas en secciones dinámicas
    final featuredDeal = _deals.first;
    final horizontalDeals = _deals.length > 1
        ? _deals.sublist(1, _deals.length > 5 ? 5 : _deals.length)
        : <DealModel>[];
    final recentDeals = _deals.length > 5 ? _deals.sublist(5) : <DealModel>[];

    return RefreshIndicator(
      color: const Color(0xff3eef7c),
      backgroundColor: const Color(0xff0d1b13),
      onRefresh: _loadDeals,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          HomeHeader(onSearchTap: widget.onSearchTap),
          const SizedBox(height: 18),

          // 1. Destacados (Juego principal dinámico)
          const SectionTitle('Destacados'),
          const SizedBox(height: 10),
          FeaturedGameCard(
            deal: featuredDeal,
            onTap: () => _navigateToDetails(featuredDeal),
          ),
          const SizedBox(height: 22),

          // 2. Grandes Ahorros (Carrusel horizontal con ListView.builder)
          if (horizontalDeals.isNotEmpty) ...[
            SectionTitle(
              'Grandes Ahorros',
              showArrow: true,
              onArrowTap: widget.onSearchTap,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 175,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: horizontalDeals.length,
                itemBuilder: (context, index) {
                  final deal = horizontalDeals[index];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    child: HorizontalDealCard(
                      deal: deal,
                      onTap: () => _navigateToDetails(deal),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 22),
          ],

          // 3. Recién Agregados (Lista vertical dinámica)
          if (recentDeals.isNotEmpty) ...[
            const SectionTitle('Recién Agregados'),
            const SizedBox(height: 10),
            ...recentDeals.map(
              (deal) => RecentGameRow(
                deal: deal,
                onTap: () => _navigateToDetails(deal),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
