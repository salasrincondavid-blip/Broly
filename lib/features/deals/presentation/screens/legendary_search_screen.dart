import 'package:flutter/material.dart';
import 'package:broly_1_1/features/deals/data/datasources/cheapshark_remote_datasource.dart';
import 'package:broly_1_1/features/deals/data/models/deal_model.dart';
import 'package:broly_1_1/features/deals/data/models/store_model.dart';
import 'package:broly_1_1/features/deals/presentation/widgets/deal_card.dart';

class LegendarySearchScreen extends StatefulWidget {
  const LegendarySearchScreen({super.key});

  @override
  State<LegendarySearchScreen> createState() => _LegendarySearchScreenState();
}

class _LegendarySearchScreenState extends State<LegendarySearchScreen> {
  final CheapSharkRemoteDataSource _dataSource = CheapSharkRemoteDataSource();
  final TextEditingController _searchController = TextEditingController();

  // Dynamic Stores list from API
  List<StoreModel> _stores = [];
  bool _isLoadingStores = true;
  final Set<String> _selectedStoreIds = {};

  // Filters State
  RangeValues _priceRange = const RangeValues(0, 100);
  double _minDiscount = 50.0;

  // Search Results State
  List<DealModel> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;
  String? _errorMessage;

  // Pre-fallback active store list while API loads
  final List<Map<String, String>> _defaultStores = [
    {'id': '1', 'name': 'Steam'},
    {'id': '7', 'name': 'GOG'},
    {'id': '25', 'name': 'Epic'},
    {'id': '13', 'name': 'Ubisoft'},
    {'id': '11', 'name': 'Humble Store'},
    {'id': '15', 'name': 'Fanatical'},
    {'id': '2', 'name': 'GamersGate'},
    {'id': '3', 'name': 'GreenManGaming'},
  ];

  @override
  void initState() {
    super.initState();
    // Default select main stores
    _selectedStoreIds.addAll(['1', '7', '25', '13']);
    _fetchStores();
  }

  Future<void> _fetchStores() async {
    try {
      final fetchedStores = await _dataSource.getStores();
      if (mounted && fetchedStores.isNotEmpty) {
        setState(() {
          _stores = fetchedStores;
          _isLoadingStores = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingStores = false;
        });
      }
    }
  }

  Future<void> _performSearch() async {
    setState(() {
      _isSearching = true;
      _hasSearched = true;
      _errorMessage = null;
    });

    try {
      final results = await _dataSource.getDeals(
        title: _searchController.text,
        lowerPrice: _priceRange.start,
        upperPrice: _priceRange.end,
        minDiscount: _minDiscount,
        storeIDs: _selectedStoreIds.toList(),
        pageSize: 40,
      );

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ocurrió un error al realizar la búsqueda de descuentos.';
          _isSearching = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryAccent = const Color(0xff3eef7c);
    final cardBgColor = const Color(0xff122017);
    final borderColor = const Color(0xff1f3627);

    return Scaffold(
      backgroundColor: const Color(0xff09110c),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              const Text(
                'Búsqueda Avanzada',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (_) => _performSearch(),
                  decoration: InputDecoration(
                    hintText: 'Buscar juegos...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search, color: Colors.white60),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 1. Price Range Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.payments_outlined, color: primaryAccent, size: 22),
                            const SizedBox(width: 8),
                            const Text(
                              'Rango de Precio',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '\$${_priceRange.start.round()} - \$${_priceRange.end >= 100 ? "100+" : _priceRange.end.round()}',
                          style: TextStyle(
                            color: primaryAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: primaryAccent,
                        inactiveTrackColor: Colors.white12,
                        thumbColor: primaryAccent,
                        overlayColor: primaryAccent.withValues(alpha: 0.2),
                        rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
                      ),
                      child: RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 100,
                        divisions: 20,
                        onChanged: (values) {
                          setState(() {
                            _priceRange = values;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('\$0', style: TextStyle(color: Colors.white38, fontSize: 12)),
                        Text('\$100', style: TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 2. Minimum Discount Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.percent_rounded, color: primaryAccent, size: 22),
                            const SizedBox(width: 8),
                            const Text(
                              'Descuento Mínimo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${_minDiscount.round()}%',
                            style: TextStyle(
                              color: primaryAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: primaryAccent,
                        inactiveTrackColor: Colors.white12,
                        thumbColor: primaryAccent,
                        overlayColor: primaryAccent.withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: _minDiscount,
                        min: 0,
                        max: 90,
                        divisions: 18,
                        onChanged: (value) {
                          setState(() {
                            _minDiscount = value;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('0%', style: TextStyle(color: Colors.white38, fontSize: 12)),
                        Text('90%', style: TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 3. Stores Selection Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.storefront_outlined, color: primaryAccent, size: 22),
                        const SizedBox(width: 8),
                        const Text(
                          'Tiendas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Grid of Stores
                    _isLoadingStores
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(color: Color(0xff3eef7c)),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _stores.isNotEmpty
                                ? _stores.length
                                : _defaultStores.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.8,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              final String id;
                              final String name;

                              if (_stores.isNotEmpty) {
                                id = _stores[index].storeID;
                                name = _stores[index].storeName;
                              } else {
                                id = _defaultStores[index]['id']!;
                                name = _defaultStores[index]['name']!;
                              }

                              final isSelected = _selectedStoreIds.contains(id);

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedStoreIds.remove(id);
                                    } else {
                                      _selectedStoreIds.add(id);
                                    }
                                  });
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff0b1710),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected ? primaryAccent : Colors.white10,
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: isSelected ? primaryAccent : Colors.transparent,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: isSelected ? primaryAccent : Colors.white38,
                                          ),
                                        ),
                                        child: isSelected
                                            ? const Icon(
                                                Icons.check,
                                                size: 14,
                                                color: Color(0xff09110c),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action Button "Ver Resultados"
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAccent,
                    foregroundColor: const Color(0xff06200d),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                  onPressed: _isSearching ? null : _performSearch,
                  icon: _isSearching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xff06200d),
                          ),
                        )
                      : const Icon(Icons.search, size: 22, color: Color(0xff06200d)),
                  label: Text(
                    _isSearching ? 'Buscando...' : 'Ver Resultados',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Search Results Section
              if (_isSearching)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: CircularProgressIndicator(color: Color(0xff3eef7c)),
                  ),
                )
              else if (_errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              else if (_hasSearched) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Resultados Encontrados',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_searchResults.length} ofertas',
                      style: TextStyle(color: primaryAccent, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _searchResults.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.0),
                        child: Center(
                          child: Text(
                            'No se encontraron ofertas que coincidan con estos filtros.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white60),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return DealCard(deal: _searchResults[index]);
                        },
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
