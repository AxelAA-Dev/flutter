import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Función para mostrar la ventana emergente
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿De qué trata esta aplicación?'),
          content: const Text(
            '''
            Nuestra aplicación permite monitorear la calidad del agua filtrada en tiempo real,
            mostrando información clave como alcalinidad y nivel de pureza. Ideal para hogares 
            y comunidades que buscan garantizar un consumo seguro y saludable.
            ''',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  /// Widget para crear una tarjeta de información
  Widget infoCard(String title, String data, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: Colors.blue[300]),
                const SizedBox(width: 16),
                Text(title, style: const TextStyle(fontSize: 16)),
              ],
            ),
            Text(data, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor de Agua'),
        backgroundColor: Colors.blue[300],
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            infoCard('Zona del Filtro', 'Zona A', Icons.location_on),
            infoCard('Alcalinidad', '7.0 pH', Icons.water_drop),
            infoCard('Nivel de Alcalinidad', 'Moderado', Icons.thermostat),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue[300],
              ),
              child: const Text('Ir a Configuraciones'),
            ),
          ],
        ),
      ),
    );
  }
}
