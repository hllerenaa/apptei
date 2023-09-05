import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apptei/src/widget/extends_files.dart';
import 'package:apptei/src/services/jwt_service.dart';
import 'package:apptei/src/models/user_singleton.dart';

class LoginService {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final JWTService _jwtService =
      JWTService(); // <-- instancia de tu nuevo servicio JWT

  Future<bool> authenticateUser(BuildContext context) async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complete el formulario')),
      );
      return false;
    }

    try {
      final response = await _sendLoginRequest(
        usernameController.text,
        passwordController.text,
      );
      if (response['success']) {
        final token = response['data']['token'] ?? '';
        if (token.isEmpty) {
          throw Exception('Token not received from server.');
        }
        // Guardar el JWT
        await _jwtService.saveToken(token);
        // Guardar el modelo USER
        User loggedInUser = User(
            id: response['data']['user']['id'],
            username: response['data']['user']['username'],
            fullName: response['data']['user']['fullName'],
            first_name: response['data']['user']['first_name'],
            last_name: response['data']['user']['last_name'],
            email: response['data']['user']['email'],
            celular: response['data']['user']['celular'],
            photo: response['data']['user']['photo']);
        UserSingleton.instance.currentUser = loggedInUser;
        await UserSingleton.instance.saveUserToPrefs();
        await UserSingleton.instance.loadUserFromPrefs();
        Navigator.of(context).pushReplacementNamed('/menu');
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['msg'])),
        );
        return false;
      }
    } catch (error) {
      if (error is SocketException) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          confirmBtnText: 'Ok',
          title: '',
          text: 'Error de conexión: $error',
        );
        return false;
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          confirmBtnText: 'Ok',
          title: '',
          text: 'Error inesperado: $error',
        );
        return false;
      }
    }
  }

  Future<Map<String, dynamic>> _sendLoginRequest(
      String username, String password) async {
    final url = '${urlConsumo}/apimobile/v1/tei/auth/';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    return json.decode(response.body);
  }
}
