// user.dart
class User {
  final int id;
  final String username;
  final String email;

  User({required this.id, required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}

class LoginUsersRequest {
  final DatosEntrada datosEntrada;
  final DatosSalida? datosSalida; // Opcional para la solicitud

  LoginUsersRequest({
    required this.datosEntrada,
    this.datosSalida,
  });

  factory LoginUsersRequest.fromJson(Map<String, dynamic> json) {
    return LoginUsersRequest(
      datosEntrada: DatosEntrada.fromJson(json['datosEntrada']),
      datosSalida: json['datosSalida'] != null 
          ? DatosSalida.fromJson(json['datosSalida'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['datosEntrada'] = datosEntrada.toJson();
    if (datosSalida != null) {
      data['datosSalida'] = datosSalida?.toJson();
    }
    return data;
  }
}

class DatosEntrada {
  final String email;
  final String password;

  DatosEntrada({
    required this.email,
    required this.password,
  });

  factory DatosEntrada.fromJson(Map<String, dynamic> json) {
    return DatosEntrada(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class DatosSalida {
  final int id;
  final String nombre;
  final bool? existe; // Nullable si no siempre viene en la respuesta

  DatosSalida({
    required this.id,
    required this.nombre,
    this.existe,
  });

  factory DatosSalida.fromJson(Map<String, dynamic> json) {
    return DatosSalida(
      id: json['id'],
      nombre: json['nombre'],
      existe: json['existe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      if (existe != null) 'existe': existe,
    };
  }
}
