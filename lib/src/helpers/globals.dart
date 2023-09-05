import 'dart:io';


String version = '1.0.0';
int periodoId = 2;

String urlConsumo = Platform.isAndroid
    ? "https://postulate.unemi.edu.ec" // Android emulador
    : "http://localhost:8000"; // iOS emulador o dispositivo físico
