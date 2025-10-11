import 'package:flutter/material.dart';

/// App modificado: temas, interactividad, modo oscuro y visualización de valores.

final List<int> _items = List<int>.generate(51, (int index) => index);

void main() => runApp(const AppBarApp());

class AppBarApp extends StatefulWidget {
  const AppBarApp({super.key});

  @override
  State<AppBarApp> createState() => _AppBarAppState();
}

class _AppBarAppState extends State<AppBarApp> {
  // ThemeMode control
  ThemeMode _themeMode = ThemeMode.light;
  // Seed color for theme (modifiable)
  Color _seedColor = const Color(0xff6750a4);

  void toggleThemeMode(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void changeSeedColor(Color color) {
    setState(() {
      _seedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppBar Demo Modificado',
      theme: ThemeData(
        colorSchemeSeed: _seedColor,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: _seedColor,
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black87),
      ),
      themeMode: _themeMode,
      home: AppBarExample(
        onThemeModeChanged: toggleThemeMode,
        onSeedColorChanged: changeSeedColor,
        seedColor: _seedColor,
        themeMode: _themeMode,
      ),
    );
  }
}

class AppBarExample extends StatefulWidget {
  const AppBarExample({
    super.key,
    required this.onThemeModeChanged,
    required this.onSeedColorChanged,
    required this.seedColor,
    required this.themeMode,
  });

  final ValueChanged<bool> onThemeModeChanged;
  final ValueChanged<Color> onSeedColorChanged;
  final Color seedColor;
  final ThemeMode themeMode;

  @override
  State<AppBarExample> createState() => _AppBarExampleState();
}

class _AppBarExampleState extends State<AppBarExample> {
  bool shadowEnabled = false;
  double? scrolledUnderElevation;
  Color appBarColor = Colors.transparent;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleAppBarColor() {
    setState(() {
      appBarColor = appBarColor == Colors.transparent ? widget.seedColor : Colors.transparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Ajuste de opacidad según modo claro/oscuro
    final bool isDark = widget.themeMode == ThemeMode.dark || Theme.of(context).brightness == Brightness.dark;
    final double oddOpacity = isDark ? 0.12 : 0.08;
    final double evenOpacity = isDark ? 0.20 : 0.12;

    final Color oddItemColor = colorScheme.primary.withOpacity(oddOpacity);
    final Color evenItemColor = colorScheme.primary.withOpacity(evenOpacity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Demo Modificado'),
        backgroundColor: appBarColor == Colors.transparent ? Theme.of(context).appBarTheme.backgroundColor : appBarColor,
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowEnabled ? Theme.of(context).colorScheme.shadow : null,
        actions: [
          IconButton(
            tooltip: 'Cambiar color AppBar',
            onPressed: () {
              _toggleAppBarColor();
              _showSnackBar('AppBar color toggled');
            },
            icon: const Icon(Icons.color_lens),
          ),
          IconButton(
            tooltip: 'Mostrar scrolledUnderElevation',
            onPressed: () {
              _showSnackBar('scrolledUnderElevation: ${scrolledUnderElevation ?? 'default'}');
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('scrolledUnderElevation: ${scrolledUnderElevation ?? 'default'}'),
                Text('Sombra: ${shadowEnabled ? 'activada' : 'desactivada'}'),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: _items.length,
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Center(
                    child: Text(
                      'Scroll to see the AppBar in effect.',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final bool odd = _items[index].isOdd;
                final Color bg = odd ? oddItemColor : evenItemColor;

                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: bg,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        odd ? Icons.star : Icons.favorite,
                        color: colorScheme.onPrimary,
                        size: 28,
                      ),
                      const SizedBox(height: 6),
                      Text('Item $index', style: TextStyle(color: colorScheme.onPrimary)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: OverflowBar(
            overflowAlignment: OverflowBarAlignment.center,
            alignment: MainAxisAlignment.center,
            overflowSpacing: 8.0,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Sombra'),
                  Switch(
                    value: shadowEnabled,
                    onChanged: (v) {
                      setState(() {
                        shadowEnabled = v;
                      });
                      _showSnackBar('Sombra: ${v ? 'activada' : 'desactivada'}');
                    },
                  ),
                ],
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (scrolledUnderElevation == null) {
                      scrolledUnderElevation = 4.0;
                    } else {
                      scrolledUnderElevation = scrolledUnderElevation! + 1.0;
                    }
                  });
                  _showSnackBar('scrolledUnderElevation: ${scrolledUnderElevation ?? 'default'}');
                },
                child: Text('scrolledUnderElevation: ${scrolledUnderElevation ?? 'default'}'),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Dark mode'),
                  Switch(
                    value: widget.themeMode == ThemeMode.dark,
                    onChanged: (v) {
                      widget.onThemeModeChanged(v);
                      _showSnackBar('Modo oscuro: ${v ? 'activado' : 'desactivado'}');
                    },
                  ),
                ],
              ),
              const SizedBox(width: 8),
              PopupMenuButton<Color>(
                tooltip: 'Cambiar color base',
                icon: const Icon(Icons.palette),
                onSelected: (Color color) {
                  widget.onSeedColorChanged(color);
                  _showSnackBar('Color base cambiado');
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: Colors.deepPurple, child: Text('Deep Purple')),
                  PopupMenuItem(value: Colors.teal, child: Text('Teal')),
                  PopupMenuItem(value: Colors.orange, child: Text('Orange')),
                  PopupMenuItem(value: Colors.blueGrey, child: Text('BlueGrey')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}