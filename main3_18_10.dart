import 'package:flutter/material.dart';

/// Flutter code sample for [AppBar] with dynamic color, SnackBar, and Switch.

final List<int> _items = List<int>.generate(51, (int index) => index);

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppBar Demo',
      theme: ThemeData(colorSchemeSeed: const Color(0xff00BCD4)), // Cambiado a un nuevo color (cian)
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
  Color appBarColor = const Color.fromARGB(255, 141, 181, 213);
  Color appBarForeground = Colors.white;
  final List<Color> _colors = [Colors.blue, Colors.green, Colors.red, Colors.purple, Colors.orange];
  int _currentColorIndex = 0;
  int _currentForegroundIndex = 0;

  final List<Color> _foregroundOptions = [Colors.white, Colors.black, Colors.yellow, Colors.teal, Colors.grey];

  void _changeAppBarColor() {
    setState(() {
      _currentColorIndex = (_currentColorIndex + 1) % _colors.length;
      appBarColor = _colors[_currentColorIndex];
    });
  }

  void _changeAppBarForeground() {
    setState(() {
      _currentForegroundIndex = (_currentForegroundIndex + 1) % _foregroundOptions.length;
      appBarForeground = _foregroundOptions[_currentForegroundIndex];
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
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Demo'),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
        backgroundColor: appBarColor,
        foregroundColor: appBarForeground,
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            tooltip: 'Cambiar color de fondo',
            onPressed: _changeAppBarColor,
          ),
          IconButton(
            icon: const Icon(Icons.text_fields),
            tooltip: 'Cambiar color del texto/íconos',
            onPressed: _changeAppBarForeground,
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
                  const Text('Color de sombra'),
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
                child: Text('scrolledUnderElevation: ${scrolledUnderElevation ?? 'predeterminado'}'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _changeAppBarForeground,
                icon: const Icon(Icons.text_fields),
                label: const Text('Cambiar color texto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
