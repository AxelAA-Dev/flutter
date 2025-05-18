import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const SettingsScreen({
    Key? key,
    required this.onToggleDarkMode,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = false;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  /// Inicializa las notificaciones
  void _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  /// Solicitar permisos para notificaciones
  Future<void> _requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      setState(() {
        notificationsEnabled = true;
      });
      _showTestNotification();
    } else {
      setState(() {
        notificationsEnabled = false;
      });
      print("Permiso de notificaciones denegado");
    }
  }

  /// Enviar una notificación de prueba
  Future<void> _showTestNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Canal de Notificaciones',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      0,
      'Notificación de Prueba',
      'Las notificaciones están activadas',
      notificationDetails,
    );
  }

  /// Cerrar sesión y regresar al login
  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Switch para el modo oscuro
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Modo Oscuro'),
                Switch(
                  value: widget.isDarkMode,
                  onChanged: (value) {
                    widget.onToggleDarkMode(value);
                  },
                ),
              ],
            ),
            const Divider(),

            /// Switch para notificaciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Habilitar Notificaciones'),
                Switch(
                  value: notificationsEnabled,
                  onChanged: (value) async {
                    if (value) {
                      await _requestNotificationPermission();
                    } else {
                      setState(() {
                        notificationsEnabled = false;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  backgroundColor: Colors.red[300],
                ),
                child: const Text('Cerrar Sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
