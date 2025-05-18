import 'package:flutter/material.dart';
import 'app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  bool notificationsEnabled = false;

  /// Función para cambiar el modo oscuro
  void toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  /// Función para cambiar el estado de notificaciones
  void toggleNotifications(bool value) {
    setState(() {
      notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.getRoutes(),
      builder: (context, child) {
        return SettingsWrapper(
          isDarkMode: isDarkMode,
          toggleDarkMode: toggleDarkMode,
          notificationsEnabled: notificationsEnabled,
          toggleNotifications: toggleNotifications,
          child: child!,
        );
      },
    );
  }
}

/// Wrapper para pasar el estado global
class SettingsWrapper extends InheritedWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;
  final bool notificationsEnabled;
  final Function(bool) toggleNotifications;

  const SettingsWrapper({
    required Widget child,
    required this.isDarkMode,
    required this.toggleDarkMode,
    required this.notificationsEnabled,
    required this.toggleNotifications,
  }) : super(child: child);

  static SettingsWrapper? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsWrapper>();
  }

  @override
  bool updateShouldNotify(SettingsWrapper oldWidget) {
    return oldWidget.isDarkMode != isDarkMode ||
        oldWidget.notificationsEnabled != notificationsEnabled;
  }
}
