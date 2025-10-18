import 'package:flutter/material.dart';

/// Flutter code sample for [AppBar] with dynamic color, SnackBar, and Switch.

final List<int> _items = List<int>.generate(51, (int index) => index);

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: const Color(0xff00BCD4)),
      debugShowCheckedModeBanner: false, // Añadido para quitar el banner de debug
      home: const AppBarExample(),
    );
  }
}

class AppBarExample extends StatefulWidget {
  const AppBarExample({super.key});

  @override
  State<AppBarExample> createState() => _AppBarExampleState();
}

class _AppBarExampleState extends State<AppBarExample> {
  bool shadowColor = false;
  double? scrolledUnderElevation;
  Color appBarColor = Colors.blue;
  Color scaffoldBackgroundColor = Colors.grey[200]!;
  // Se reemplazarán por colores tomados de ColorScheme en build
  late List<Color> _appBarColors;
  late List<Color> _scaffoldColors;
  int _currentAppBarColorIndex = 0;
  int _currentScaffoldColorIndex = 0;

  void _changeAppBarColor(int newIndex, bool isAppBar) {
    setState(() {
      if (isAppBar) {
        _currentAppBarColorIndex = newIndex;
        appBarColor = _appBarColors[_currentAppBarColorIndex];
      } else {
        _currentScaffoldColorIndex = newIndex;
        scaffoldBackgroundColor = _scaffoldColors[_currentScaffoldColorIndex];
      }
    });
  }

  void _showElevationSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('scrolledUnderElevation: ${scrolledUnderElevation ?? 'default'}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // Inicializar opciones de color a partir del ColorScheme
    _appBarColors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.surface,
      colorScheme.error,
      colorScheme.background,
    ];
    _scaffoldColors = [
      colorScheme.background,
      colorScheme.surfaceVariant,
      colorScheme.secondaryContainer,
      colorScheme.primaryContainer,
      colorScheme.errorContainer,
    ];
    // Asegurar índices válidos
    if (_currentAppBarColorIndex >= _appBarColors.length) _currentAppBarColorIndex = 0;
    if (_currentScaffoldColorIndex >= _scaffoldColors.length) _currentScaffoldColorIndex = 0;
    appBarColor = _appBarColors[_currentAppBarColorIndex];
    scaffoldBackgroundColor = _scaffoldColors[_currentScaffoldColorIndex];
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('AppBar Demo'),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            tooltip: 'Colores del AppBar',
            onPressed: () async {
              // Mostrar un menú simple con opciones derivadas del ColorScheme
              final choice = await showMenu<int>(
                context: context,
                position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
                items: _appBarColors.asMap().entries.map((entry) {
                  final index = entry.key;
                  final color = entry.value;
                  return PopupMenuItem<int>(
                    value: index,
                    child: Row(
                      children: [
                        Container(width: 20, height: 20, color: color),
                        const SizedBox(width: 8),
                        Text('AppBar: ${index + 1}'),
                      ],
                    ),
                  );
                }).toList(),
              );
              if (choice != null) _changeAppBarColor(choice, true);
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_paint),
            tooltip: 'Colores del fondo',
            onPressed: () async {
              final choice = await showMenu<int>(
                context: context,
                position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
                items: _scaffoldColors.asMap().entries.map((entry) {
                  final index = entry.key;
                  final color = entry.value;
                  return PopupMenuItem<int>(
                    value: index,
                    child: Row(
                      children: [
                        Container(width: 20, height: 20, color: color),
                        const SizedBox(width: 8),
                        Text('Fondo: ${index + 1}'),
                      ],
                    ),
                  );
                }).toList(),
              );
              if (choice != null) _changeAppBarColor(choice, false);
            },
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: _items.length,
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Center(
              child: Text(
                'Scroll to see the Appbar in effect.',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
            );
          }
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: _items[index].isOdd ? oddItemColor : evenItemColor,
            ),
            child: Text('Item $index'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: OverflowBar(
            overflowAlignment: OverflowBarAlignment.center,
            alignment: MainAxisAlignment.center,
            overflowSpacing: 5.0,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Shadow Color'),
                  Switch(
                    value: shadowColor,
                    onChanged: (bool value) {
                      setState(() {
                        shadowColor = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (scrolledUnderElevation == null) {
                      scrolledUnderElevation = 4.0;
                    } else {
                      scrolledUnderElevation = scrolledUnderElevation! + 1.0;
                    }
                    _showElevationSnackBar();
                  });
                },
                child: Text('scrolledUnderElevation: ${scrolledUnderElevation ?? 'default'}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
