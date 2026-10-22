import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
<<<<<<< HEAD

void main() {
=======
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase Dashboard > Project Settings > API Keys
const String supabaseUrl = 'https://rvwwrhyeknagygybbvqz.supabase.co';
const String supabasePublishableKey =
    'sb_publishable_7dmqmOpXQSPj2uztm7yfjw_QUswItSv';

const List<String> antiqueCategories = [
  'Bakır ve Pirinç Eşyalar',
  'Saatler ve Koleksiyonluk Ürünler',
  'Seramik ve Porselen',
  'Kitap, Belge ve Hat Eserleri',
  'Mobilya ve Dekorasyon',
  'Para, Madalya ve Koleksiyon',
  'Diğer',
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
  runApp(const AntiqueAdminApp());
}

class AntiqueAdminApp extends StatelessWidget {
  const AntiqueAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF8B5E3C);

    return MaterialApp(
<<<<<<< HEAD
      title: 'Antika Yönetimi',
=======
      title: 'Antika Yönetimi',  
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        useMaterial3: true,
      ),
      home: const AntiqueAdminPage(),
    );
  }
}

class Antique {
  const Antique({
<<<<<<< HEAD
    required this.name,
    required this.year,
    required this.history,
    required this.value,
  });

  final String name;
  final int year;
  final String history;
  final double value;
=======
    this.id,
    required this.name,
    required this.category,
    required this.year,
    required this.history,
    required this.value,
    required this.quantity,
  });

  final int? id;
  final String name;
  final String category;
  final int year;
  final String history;
  final double value;
  final int quantity;
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
}

class AntiqueAdminPage extends StatefulWidget {
  const AntiqueAdminPage({super.key});

  @override
  State<AntiqueAdminPage> createState() => _AntiqueAdminPageState();
}

class _AntiqueAdminPageState extends State<AntiqueAdminPage> {
  final List<Antique> _antiques = [];
  _AdminPage _currentPage = _AdminPage.menu;
<<<<<<< HEAD

  void _saveAntique(Antique antique) {
    setState(() {
      _antiques.add(antique);
      _currentPage = _AdminPage.menu;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Antika kaydı oluşturuldu.')),
    );
=======
  bool _isLoading = true;
  String? _loadError;

  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadAntiques();
  }

  Future<void> _loadAntiques() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    try {
      final rows = await _supabase.from('urunler').select().order('id');
      final loaded = (rows as List).map((row) {
        final item = Map<String, dynamic>.from(row as Map);
        return Antique(
          id: (item['id'] as num).toInt(),
          name: (item['ad'] ?? '').toString(),
          category: (item['kategori'] ?? 'Diğer').toString(),
          year: (item['antika_yili'] as num?)?.toInt() ?? 0,
          history: (item['aciklama'] ?? '').toString(),
          value: (item['satis_fiyati'] as num?)?.toDouble() ?? 0,
          quantity: (item['stok'] as num?)?.toInt() ?? 0,
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        _antiques
          ..clear()
          ..addAll(loaded);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = error.toString();
      });
    }
  }

  Future<void> _insertAntique(Antique antique) async {
    final result = await _supabase.from('urunler').insert({
      'ad': antique.name,
      'kategori': antique.category,
      'antika_yili': antique.year,
      'aciklama': antique.history,
      'alis_fiyati': 0,
      'satis_fiyati': antique.value,
      'stok': antique.quantity,
    }).select();

    debugPrint('SUPABASE KAYIT SONUCU: $result');
  }

  Future<void> _saveAntique(Antique antique) async {
    final matchingIndices = <int>[];
    for (var i = 0; i < _antiques.length; i++) {
      if (_antiques[i].name.trim().toLowerCase() ==
          antique.name.trim().toLowerCase()) {
        matchingIndices.add(i);
      }
    }

    try {
      if (matchingIndices.isNotEmpty) {
        final selectedIndex = await showDialog<int>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Bu antika zaten kayıtlı'),
            content: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '"${antique.name}" adlı ürün için hangi kayda '
                      '${antique.quantity} adet eklemek istiyorsun?',
                    ),
                    const SizedBox(height: 12),
                    ...matchingIndices.map((index) {
                      final existing = _antiques[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.inventory_2_outlined),
                          title: Text(existing.name),
                          subtitle: Text(
                            'Kategori: ${existing.category}\n'
                            'Yıl: ${existing.year} • Mevcut adet: ${existing.quantity}\n'
                            'Değer: ${existing.value.toStringAsFixed(2)} ₺',
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.add_circle_outline),
                          onTap: () => Navigator.pop(dialogContext, index),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(dialogContext, -1),
                      icon: const Icon(Icons.add),
                      label: const Text('Hayır, ayrı kayıt oluştur'),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('İptal'),
              ),
            ],
          ),
        );

        if (!mounted || selectedIndex == null) return;

        if (selectedIndex == -1) {
          await _insertAntique(antique);
        } else {
          final existing = _antiques[selectedIndex];
          if (existing.id == null) {
            throw Exception('Seçilen kaydın veritabanı kimliği bulunamadı.');
          }
          await _supabase
              .from('urunler')
              .update({'stok': existing.quantity + antique.quantity})
              .eq('id', existing.id!);
        }

        await _loadAntiques();
        if (!mounted) return;
        setState(() => _currentPage = _AdminPage.menu);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              selectedIndex == -1
                  ? 'Ayrı antika kaydı oluşturuldu.'
                  : 'Seçtiğin kaydın stok adedi artırıldı.',
            ),
          ),
        );
        return;
      }

      await _insertAntique(antique);
      await _loadAntiques();
      if (!mounted) return;
      setState(() => _currentPage = _AdminPage.menu);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Antika kaydı oluşturuldu.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kaydetme başarısız: $error'),
          duration: const Duration(seconds: 8),
        ),
      );
    }
  }

  Future<void> _deleteAntique(Antique antique) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ürünü sil'),
        content: Text(
          '"${antique.name}" adlı ürünü silmek istediğine emin misin?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm != true || antique.id == null) return;

    try {
      await _supabase.from('urunler').delete().eq('id', antique.id!);
      await _loadAntiques();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün başarıyla silindi.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Silme işlemi başarısız: $error'),
          duration: const Duration(seconds: 8),
        ),
      );
    }
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
=======
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Antika Yönetimi')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, size: 48),
                const SizedBox(height: 12),
                const Text('Supabase bağlantısı kurulamadı.'),
                const SizedBox(height: 8),
                SelectableText(_loadError!),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _loadAntiques,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tekrar dene'),
                ),
              ],
            ),
          ),
        ),
      );
    }

>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
    switch (_currentPage) {
      case _AdminPage.menu:
        return _AdminMenu(
          antiqueCount: _antiques.length,
          onCreateAntique: () {
            setState(() => _currentPage = _AdminPage.create);
          },
          onShowAntiques: () {
            setState(() => _currentPage = _AdminPage.list);
          },
        );
      case _AdminPage.create:
        return _AddAntiquePage(
          onCancel: () => setState(() => _currentPage = _AdminPage.menu),
          onSave: _saveAntique,
        );
      case _AdminPage.list:
        return _AntiqueListPage(
          antiques: _antiques,
          onBack: () => setState(() => _currentPage = _AdminPage.menu),
          onCreateAntique: () {
            setState(() => _currentPage = _AdminPage.create);
          },
<<<<<<< HEAD
=======
          onDelete: _deleteAntique,
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
        );
    }
  }
}

enum _AdminPage { menu, create, list }

class _AdminMenu extends StatelessWidget {
  const _AdminMenu({
    required this.antiqueCount,
    required this.onCreateAntique,
    required this.onShowAntiques,
  });

  final int antiqueCount;
  final VoidCallback onCreateAntique;
  final VoidCallback onShowAntiques;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Antika Yönetimi')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.workspace_premium_outlined,
                  size: 64,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Hoş geldiniz',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Antika kayıtlarınızı buradan yönetin.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: onCreateAntique,
                  icon: const Icon(Icons.add),
                  label: const Text('Yeni Kayıt Oluştur'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: onShowAntiques,
                  icon: const Icon(Icons.inventory_2_outlined),
                  label: Text('Kayıtları Görüntüle ($antiqueCount)'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

<<<<<<< HEAD
class _AntiqueListPage extends StatelessWidget {
=======
class _AntiqueListPage extends StatefulWidget {
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
  const _AntiqueListPage({
    required this.antiques,
    required this.onBack,
    required this.onCreateAntique,
<<<<<<< HEAD
=======
    required this.onDelete,
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
  });

  final List<Antique> antiques;
  final VoidCallback onBack;
  final VoidCallback onCreateAntique;
<<<<<<< HEAD
=======
  final Future<void> Function(Antique) onDelete;

  @override
  State<_AntiqueListPage> createState() => _AntiqueListPageState();
}

class _AntiqueListPageState extends State<_AntiqueListPage> {
  String _selectedCategory = 'Tüm kategoriler';
  String _searchText = '';

  List<Antique> get _filteredAntiques {
    return widget.antiques.where((antique) {
      final matchesCategory = _selectedCategory == 'Tüm kategoriler' ||
          antique.category == _selectedCategory;
      final matchesSearch =
          antique.name.toLowerCase().contains(_searchText.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
<<<<<<< HEAD
=======
    final visibleAntiques = _filteredAntiques;
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
<<<<<<< HEAD
          onPressed: onBack,
=======
          onPressed: widget.onBack,
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Menüye dön',
        ),
        title: const Text('Antika Kayıtları'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
<<<<<<< HEAD
              onPressed: onCreateAntique,
=======
              onPressed: widget.onCreateAntique,
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
              icon: const Icon(Icons.add),
              label: const Text('Ekle'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
            Text(
              '${antiques.length} kayıt',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
=======
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 280,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Ürün ara',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() => _searchText = value.trim());
                    },
                  ),
                ),
               SizedBox(
  width: 280,
  child: DropdownButtonFormField<String>(
    value: _selectedCategory,
    isExpanded: true,
    decoration: const InputDecoration(
      labelText: 'Kategori filtresi',
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
    ),
    items: [
      const DropdownMenuItem<String>(
        value: 'Tüm kategoriler',
        child: Text(
          'Tüm kategoriler',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      ...antiqueCategories.map(
        (category) => DropdownMenuItem<String>(
          value: category,
          child: Text(
            category,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    ],
    onChanged: (value) {
      if (value != null) {
        setState(() => _selectedCategory = value);
      }
    },
  ),
),
                Text('${visibleAntiques.length} kayıt'),
              ],
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
<<<<<<< HEAD
                child: antiques.isEmpty
=======
                child: visibleAntiques.isEmpty
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 48,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 12),
                              Text(
<<<<<<< HEAD
                                'Henüz antika kaydı yok.',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Yeni kayıt oluşturmak için Ekle butonuna basın.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
=======
                                widget.antiques.isEmpty
                                    ? 'Henüz antika kaydı yok.'
                                    : 'Bu aramaya uygun ürün bulunamadı.',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Arama veya kategori filtresini değiştirebilirsin.',
                                textAlign: TextAlign.center,
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
                              ),
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Antika Adı')),
<<<<<<< HEAD
                              DataColumn(label: Text('Antika Yılı')),
                              DataColumn(label: Text('Tarihsel Geçmişi')),
                              DataColumn(label: Text('Değeri')),
                            ],
                            rows: antiques.map((antique) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(antique.name)),
                                  DataCell(Text(antique.year.toString())),
                                  DataCell(
                                    SizedBox(
                                      width: 300,
=======
                              DataColumn(label: Text('Kategori')),
                              DataColumn(label: Text('Antika Yılı')),
                              DataColumn(label: Text('Tarihsel Geçmişi')),
                              DataColumn(label: Text('Değeri')),
                              DataColumn(label: Text('Adet')),
                              DataColumn(label: Text('İşlem')),
                            ],
                            rows: visibleAntiques.map((antique) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(antique.name)),
                                  DataCell(Text(antique.category)),
                                  DataCell(Text(antique.year.toString())),
                                  DataCell(
                                    SizedBox(
                                      width: 280,
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
                                      child: Text(
                                        antique.history,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${antique.value.toStringAsFixed(2)} ₺',
                                    ),
                                  ),
<<<<<<< HEAD
=======
                                  DataCell(Text(antique.quantity.toString())),
                                  DataCell(
                                    IconButton(
                                      tooltip: 'Ürünü sil',
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          widget.onDelete(antique),
                                    ),
                                  ),
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
                                ],
                              );
                            }).toList(),
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
}

class _AddAntiquePage extends StatefulWidget {
  const _AddAntiquePage({
    required this.onCancel,
    required this.onSave,
  });

  final VoidCallback onCancel;
<<<<<<< HEAD
  final ValueChanged<Antique> onSave;
=======
  final Future<void> Function(Antique) onSave;
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48

  @override
  State<_AddAntiquePage> createState() => _AddAntiquePageState();
}

class _AddAntiquePageState extends State<_AddAntiquePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  final _historyController = TextEditingController();
  final _valueController = TextEditingController();
<<<<<<< HEAD
=======
  final _quantityController = TextEditingController(text: '1');
  String _selectedCategory = 'Diğer';
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _historyController.dispose();
    _valueController.dispose();
<<<<<<< HEAD
    super.dispose();
  }

  void _save() {
=======
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
    if (!_formKey.currentState!.validate()) return;

    final value = double.parse(
      _valueController.text.trim().replaceAll(',', '.'),
    );
<<<<<<< HEAD
    widget.onSave(
      Antique(
        name: _nameController.text.trim(),
        year: int.parse(_yearController.text.trim()),
        history: _historyController.text.trim(),
        value: value,
=======

    await widget.onSave(
      Antique(
        name: _nameController.text.trim(),
        category: _selectedCategory,
        year: int.parse(_yearController.text.trim()),
        history: _historyController.text.trim(),
        value: value,
        quantity: int.parse(_quantityController.text.trim()),
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.onCancel,
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Menüye dön',
        ),
        title: const Text('Yeni Antika Kaydı'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Antika Bilgileri',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Antika adı',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Antika adını girin.'
                        : null,
                  ),
                  const SizedBox(height: 16),
<<<<<<< HEAD
=======
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                    items: antiqueCategories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
                  TextFormField(
                    controller: _yearController,
                    decoration: const InputDecoration(
                      labelText: 'Antika yılı',
                      hintText: 'Örn. 1920',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Antika yılını girin.';
                      }
                      if (int.tryParse(value.trim()) == null) {
                        return 'Geçerli bir yıl girin.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _historyController,
                    decoration: const InputDecoration(
                      labelText: 'Tarihsel geçmişi',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    minLines: 3,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Tarihsel geçmişi girin.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _valueController,
                    decoration: const InputDecoration(
                      labelText: 'Değeri (₺)',
                      hintText: 'Örn. 12500,50',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Antikanın değerini girin.';
                      }
                      final parsed = double.tryParse(
                        value.trim().replaceAll(',', '.'),
                      );
                      if (parsed == null || !parsed.isFinite || parsed < 0) {
                        return 'Geçerli bir değer girin.';
                      }
                      return null;
                    },
                  ),
<<<<<<< HEAD
=======
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Adet',
                      hintText: 'Örn. 3',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      final quantity = int.tryParse(value?.trim() ?? '');
                      if (quantity == null || quantity < 1) {
                        return 'En az 1 adet girin.';
                      }
                      return null;
                    },
                  ),
>>>>>>> 907c29fcfadd7259ef6b86bad2ab152e833c1d48
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: widget.onCancel,
                        child: const Text('İptal'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Kaydet'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
