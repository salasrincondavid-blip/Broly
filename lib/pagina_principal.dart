import 'package:flutter/material.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff09110c),
      body: _selectedIndex == 0
          ? const HomeView()
          : Center(
              child: Text(
                ['Ofertas', 'Favoritos', 'Buscar'][_selectedIndex - 1],
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const featuredImage =
      'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=900';
  static const dealImages = [
    'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=600',
    'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=600',
  ];

  static const deals = [
    ('Red Dead\nRedemption 2', '\$19.79', '-67%'),
    ('Monster Hunter:\nWorld', '\$14.99', '-50%'),
  ];

  static const newGames = [
    ('Geometry Dash', 'Acción / Plataformas', '\$1.99', '-50%', Icons.grid_view_rounded),
    ('Stardew Valley', 'Simulación / RPG', '\$11.99', '-20%', Icons.grass),
    ('Rainbow Six Siege', 'Shooter / Táctico', '\$7.99', '-67%', Icons.shield_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        children: [
          const _Header(),
          const SizedBox(height: 18),
          const _SectionTitle('Destacados'),
          const SizedBox(height: 9),
          const _FeaturedGame(imageUrl: featuredImage),
          const SizedBox(height: 20),
          const _SectionTitle('Grandes Ahorros', showArrow: true),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(child: _DealCard(data: deals[0], imageUrl: dealImages[0])),
              const SizedBox(width: 8),
              Expanded(child: _DealCard(data: deals[1], imageUrl: dealImages[1])),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Recién Agregados'),
          const SizedBox(height: 8),
          ...newGames.map((game) => _NewGameRow(game: game)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('videogame_asset', style: TextStyle(color: Color(0xffd7ffe2), fontSize: 12, fontWeight: FontWeight.bold)),
        const Text(' GameSaver', style: TextStyle(color: Color(0xff3eef7c), fontSize: 12, fontWeight: FontWeight.bold)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search, size: 18), color: const Color(0xffd6e1d8)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.showArrow = false});
  final String title;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(color: Color(0xffe4ece5), fontSize: 14, fontWeight: FontWeight.bold)),
        const Spacer(),
        if (showArrow) const Icon(Icons.arrow_forward, color: Color(0xffd69aff), size: 17),
      ],
    );
  }
}

class _FeaturedGame extends StatelessWidget {
  const _FeaturedGame({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.65,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _GameImage(imageUrl),
            const Positioned(top: 8, right: 8, child: _Discount('-75%')),
            Positioned(
              left: 9,
              right: 9,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Neon City 2077', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Row(children: [const _Discount('-75%'), const SizedBox(width: 7), const Text('\$14.99', style: TextStyle(color: Color(0xff55ee8b), fontSize: 10, fontWeight: FontWeight.bold)), const SizedBox(width: 6), Text('\$59.99', style: TextStyle(color: Colors.white.withValues(alpha: .6), fontSize: 9, decoration: TextDecoration.lineThrough))]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameImage extends StatelessWidget {
  const _GameImage(this.url);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(url, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: const Color(0xff294834)));
  }
}

class _Discount extends StatelessWidget {
  const _Discount(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), decoration: BoxDecoration(color: const Color(0xff38ed7a), borderRadius: BorderRadius.circular(3)), child: Text(text, style: const TextStyle(color: Color(0xff06200d), fontSize: 9, fontWeight: FontWeight.bold)));
}

class _DealCard extends StatelessWidget {
  const _DealCard({required this.data, required this.imageUrl});
  final (String, String, String) data;
  final String imageUrl;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [AspectRatio(aspectRatio: 1.5, child: Stack(children: [ClipRRect(borderRadius: BorderRadius.circular(5), child: _GameImage(imageUrl)), Positioned(top: 5, right: 5, child: _Discount(data.$3))])), const SizedBox(height: 5), Text(data.$1, style: const TextStyle(color: Color(0xffe3ebe4), fontSize: 9, height: 1.25)), const SizedBox(height: 5), Text(data.$2, style: const TextStyle(color: Color(0xff55ee8b), fontSize: 10, fontWeight: FontWeight.bold))]);
}

class _NewGameRow extends StatelessWidget {
  const _NewGameRow({required this.game});
  final (String, String, String, String, IconData) game;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xff294834),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(game.$5, color: const Color(0xff70e89a), size: 19),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.$1,
                  style: const TextStyle(
                    color: Color(0xffe3ebe4),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  game.$2,
                  style: TextStyle(color: Colors.white.withValues(alpha: .62), fontSize: 8),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Discount(game.$4),
              const SizedBox(height: 2),
              Text(
                game.$3,
                style: const TextStyle(
                  color: Color(0xff55ee8b),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NavigationBar extends StatelessWidget {
  const NavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onDestinationSelected,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer_outlined),
          label: 'Ofertas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Buscar',
        ),
      ],
    );
  }
}

class CardExample extends StatelessWidget {
  const CardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}