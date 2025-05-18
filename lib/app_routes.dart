import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'main.dart'; // Importa el main.dart para acceder al SettingsWrapper

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      settings: (context) {
        final settingsWrapper = SettingsWrapper.of(context);

        return SettingsScreen(
          onToggleDarkMode: settingsWrapper!.toggleDarkMode,
          isDarkMode: settingsWrapper.isDarkMode,
        );
      },
    };
  }
}
