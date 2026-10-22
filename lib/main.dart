import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const AntiqueAdminApp());
}

class AntiqueAdminApp extends StatelessWidget {
  const AntiqueAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF8B5E3C);

    return MaterialApp(
      title: 'Antika Yönetimi',
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
    required this.name,
    required this.year,
    required this.history,
    required this.value,
  });

  final String name;
  final int year;
  final String history;
  final double value;
}

class AntiqueAdminPage extends StatefulWidget {
  const AntiqueAdminPage({super.key});

  @override
  State<AntiqueAdminPage> createState() => _AntiqueAdminPageState();
}

class _AntiqueAdminPageState extends State<AntiqueAdminPage> {
  final List<Antique> _antiques = [];
  _AdminPage _currentPage = _AdminPage.menu;

  void _saveAntique(Antique antique) {
    setState(() {
      _antiques.add(antique);
      _currentPage = _AdminPage.menu;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Antika kaydı oluşturuldu.')),
    );
  }

  @override
  Widget build(BuildContext context) {
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

class _AntiqueListPage extends StatelessWidget {
  const _AntiqueListPage({
    required this.antiques,
    required this.onBack,
    required this.onCreateAntique,
  });

  final List<Antique> antiques;
  final VoidCallback onBack;
  final VoidCallback onCreateAntique;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Menüye dön',
        ),
        title: const Text('Antika Kayıtları'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: onCreateAntique,
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
            Text(
              '${antiques.length} kayıt',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: antiques.isEmpty
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
                                'Henüz antika kaydı yok.',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Yeni kayıt oluşturmak için Ekle butonuna basın.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
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
  final ValueChanged<Antique> onSave;

  @override
  State<_AddAntiquePage> createState() => _AddAntiquePageState();
}

class _AddAntiquePageState extends State<_AddAntiquePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  final _historyController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _historyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final value = double.parse(
      _valueController.text.trim().replaceAll(',', '.'),
    );
    widget.onSave(
      Antique(
        name: _nameController.text.trim(),
        year: int.parse(_yearController.text.trim()),
        history: _historyController.text.trim(),
        value: value,
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
