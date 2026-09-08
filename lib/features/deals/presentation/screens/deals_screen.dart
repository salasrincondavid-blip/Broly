import 'package:flutter/material.dart';
import 'package:broly_1_1/features/deals/data/datasources/cheapshark_remote_datasource.dart';
import 'package:broly_1_1/features/deals/data/models/deal_model.dart';
import 'package:broly_1_1/features/deals/presentation/widgets/deal_card.dart';
import 'package:broly_1_1/features/auth/presentation/screens/login_screen.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  final CheapSharkRemoteDataSource _dataSource = CheapSharkRemoteDataSource();
  final TextEditingController _searchController = TextEditingController();

  List<DealModel> _deals = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDeals();
  }

  Future<void> _fetchDeals({String? title}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final deals = await _dataSource.getDeals(title: title, pageSize: 10);
      setState(() {
        _deals = deals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ocurrió un error al cargar las ofertas.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_offer, color: Color(0xFF3EEF7C)),
            SizedBox(width: 8),
            Text('Ofertas Gamer'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            // Buscador de Juegos
            TextField(
              controller: _searchController,
              onSubmitted: (value) => _fetchDeals(title: value),
              decoration: InputDecoration(
                hintText: 'Buscar juego en oferta...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8DA494)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF8DA494)),
                        onPressed: () {
                          _searchController.clear();
                          _fetchDeals();
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF3EEF7C),
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () => _fetchDeals(),
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        )
                      : _deals.isEmpty
                          ? const Center(
                              child: Text(
                                'No se encontraron ofertas disponibles.',
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                          : RefreshIndicator(
                              color: const Color(0xFF3EEF7C),
                              backgroundColor: const Color(0xFF0D1B13),
                              onRefresh: () =>
                                  _fetchDeals(title: _searchController.text),
                              child: ListView.builder(
                                itemCount: _deals.length,
                                itemBuilder: (context, index) {
                                  return DealCard(deal: _deals[index]);
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
