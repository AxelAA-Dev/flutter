import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // para kIsWeb
import 'dart:io' show Platform;
import 'package:aquateam/modelos/user.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    String baseUrl;

    if (kIsWeb) {
      baseUrl = 'http://localhost:8080/mso-usuario/ms/AquaTam/v1';
    } else if (Platform.isAndroid) {
      baseUrl = 'http://10.0.2.2:8080/mso-usuario/ms/AquaTam/v1';
    } else {
      baseUrl = 'http://localhost:8080/mso-usuario/ms/AquaTam/v1';
    }

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      headers: {'Content-Type': 'application/json'},
    ));

    // 👇 Añade un interceptor para imprimir logs
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      logPrint: (log) => print(log),

    ));
  }

  Future<DatosSalida> login(String email, String password) async {
    try {
      final request = LoginUsersRequest(
        datosEntrada: DatosEntrada(email: email, password: password),
      );

final response = await _dio.post(
  '/login/user',
  data: request.toJson(),
);


if (response.data['datos'] != null) {
  return DatosSalida.fromJson(response.data['datos']);
} else {
  throw 'Estructura de respuesta inválida';
}


    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

 String _handleError(DioError e) {
  if (e.response != null) {
    final errorData = e.response?.data;
    final mensaje = errorData?['mensaje'] ?? 'Error desconocido';
    final codigo = e.response?.statusCode;
    return 'Error $codigo: $mensaje';
  }
  return 'Error de conexión: ${e.message}';
}

}
