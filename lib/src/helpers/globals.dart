import 'dart:io';


String version = '1.0.0';
int periodoId = 2;

String urlConsumo = Platform.isAndroid
    ? "http://10.0.2.2:8015" // Android emulador
    : "http://localhost:8000"; // iOS emulador o dispositivo físico
