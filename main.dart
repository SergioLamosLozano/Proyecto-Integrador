import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppBar Demo',
      debugShowCheckedModeBanner: false, // 🔹 quita la etiqueta "DEBUG"
      theme: ThemeData(
        // Usamos Google Fonts para asegurar una tipografía serif consistente
        // en todas las plataformas. Aquí usamos 'Libre Baskerville' como
        // alternativa libre y similar a Times New Roman.
        textTheme: GoogleFonts.libreBaskervilleTextTheme(),
        // También podemos aplicar color scheme como antes
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // 🔹 color principal de la app
          brightness: Brightness.light, // 🔹 modo claro
        ),
        useMaterial3: true, // 🔹 diseño Material 3 (más moderno)
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, // 🔹 AppBar azul
          foregroundColor: Colors.white, // 🔹 texto e íconos blancos
          elevation: 3, // 🔹 pequeña sombra debajo del AppBar
          centerTitle: false,
        ),
      ),
      home: const AppBarExample(),
    );
  }
}

class AppBarExample extends StatelessWidget {
  const AppBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Añadimos un Drawer para que el icono de menú (leading) pueda abrirlo
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                // cerrar el drawer al seleccionar
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ajustes'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        // Usamos la propiedad `leading` para mostrar un icono a la izquierda (puede ser menú o logo)
        // En este caso ponemos un IconButton con el icono de menú que abre el Drawer.
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Abrir menú',
              onPressed: () {
                // Abre el Drawer asociado al Scaffold
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),

        title: const Text('AppBar Demo'),
        actions: <Widget>[
          // 🔔 Botón 1: muestra SnackBar
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              // Aquí personalizamos el SnackBar: texto, color de fondo y duración
              final snack = SnackBar(
                // Texto del snackbar personalizado
                // Forzamos la fuente también en el texto del SnackBar para
                // garantizar que use 'Times New Roman' aunque no se aplique
                // por alguna razón desde el Theme.
                content: Text(
                  '¡Acción completada con éxito!',
                  // Aseguramos el estilo usando GoogleFonts también a nivel de widget
                  style: GoogleFonts.libreBaskerville(textStyle: const TextStyle(color: Colors.white)),
                ),
                // Color de fondo personalizado
                backgroundColor: Colors.teal,
                // Duración personalizada (4 segundos)
                duration: const Duration(seconds: 4),
                // Estilo visual flotante con bordes redondeados
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                // Opcional: acción en el snackbar
                action: SnackBarAction(
                  label: 'DESHACER',
                  textColor: Colors.white,
                  onPressed: () {
                    // Aquí podrías revertir la acción si hace falta
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              );

              // Mostrar el SnackBar usando el ScaffoldMessenger
              ScaffoldMessenger.of(context).showSnackBar(snack);
            },
          ),

          // ➡️ Botón 2: navega a otra página
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return const NextPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
      // Cuerpo principal: mostramos un título grande y una tarjeta con info
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Texto central indicando la clase y el proyecto
            Text(
              'Clase - Proyecto Integrador',
              style: GoogleFonts.libreBaskerville(textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            // Una tarjeta descriptiva en el medio
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text('Asignatura: Desarrollo de Software', textAlign: TextAlign.center),
                    SizedBox(height: 8),
                    Text('Semestre: Sexto', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Footer: usamos bottomNavigationBar para fijar información al pie de la pantalla
      bottomNavigationBar: Container(
        color: Colors.blue.shade700,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Izquierda: nombre del curso
            Text(
              'Proyecto Integrador - 2025',
              style: GoogleFonts.libreBaskerville(textStyle: const TextStyle(color: Colors.white)),
            ),
            // Derecha: autor o sección
            Text(
              'Sección: 1A',
              style: GoogleFonts.libreBaskerville(textStyle: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Next page')),
      body: const Center(
        child: Text(
          'This is the next page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
// This is a basic Flutter app demonstrating the use of AppBar with actions.