
import 'package:flutter/material.dart';

void main() {
  runApp(const AntikaApp());
}

class AntikaApp extends StatelessWidget {
  const AntikaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Antika Stok Takip',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F2EC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF795548),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  final List<String> titles = [
    'Dashboard',
    'Ürünler',
    'Stok Hareketleri',
    'Raporlar',
  ];

  final List<IconData> icons = [
    Icons.dashboard,
    Icons.inventory_2,
    Icons.swap_horiz,
    Icons.bar_chart,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 240,
            color: const Color(0xFF29231F),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Icon(
                  Icons.account_balance,
                  color: Color(0xFFD6B477),
                  size: 42,
                ),
                const SizedBox(height: 12),
                const Text(
                  'ANTİKA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                const Text(
                  'STOK YÖNETİMİ',
                  style: TextStyle(
                    color: Color(0xFFD6B477),
                    fontSize: 11,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),

                // Sol menü butonları
                for (int i = 0; i < titles.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      selected: selectedIndex == i,
                      selectedTileColor: const Color(0xFF514137),
                      leading: Icon(
                        icons[i],
                        color: selectedIndex == i
                            ? const Color(0xFFD6B477)
                            : Colors.white70,
                      ),
                      title: Text(
                        titles[i],
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          selectedIndex = i;
                        });
                      },
                    ),
                  ),

                const Spacer(),
                const Text(
                  'Antika Stok Takip v1.0',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),

          // Seçilen menünün içeriği
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return _dashboard();
      case 1:
        return _simplePage(
          'Ürünler',
          'Antika ürünlerini burada yöneteceğiz.',
          Icons.inventory_2,
        );
      case 2:
        return _simplePage(
          'Stok Hareketleri',
          'Ürün giriş ve çıkış kayıtları burada görünecek.',
          Icons.swap_horiz,
        );
      case 3:
        return _simplePage(
          'Raporlar',
          'Stok ve satış raporları burada yer alacak.',
          Icons.bar_chart,
        );
      default:
        return _dashboard();
    }
  }

  Widget _dashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Yönetim Paneli',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF29231F),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Antika envanterinizi buradan yönetin.'),
        const SizedBox(height: 30),
        Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            _statCard('Toplam Ürün', '0', Icons.inventory_2),
            _statCard('Stok Adedi', '0', Icons.warehouse),
            _statCard('Stok Hareketleri', '0', Icons.swap_horiz),
          ],
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: _cardDecoration(),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Son Eklenen Ürünler',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                Expanded(
                  child: Center(
                    child: Text('Henüz ürün eklenmedi.'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _simplePage(String title, String description, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF29231F),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 28),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: _cardDecoration(),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 65, color: const Color(0xFFB9AA99)),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Bu bölümün özelliklerini sıradaki adımlarda ekleyeceğiz.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(22),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF795548), size: 30),
          const SizedBox(height: 18),
          Text(title, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE5DED4)),
    );
  }
}
