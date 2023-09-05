import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:apptei/main.dart';
import 'package:apptei/src/utils/colors.dart';
import 'package:apptei/src/utils/images.dart';
import 'package:apptei/src/utils/font_family.dart';
import 'package:apptei/src/utils/common_widget.dart';
import 'package:apptei/src/services/login_service.dart';
import 'package:apptei/src/widget/overlay.dart';
import 'package:apptei/src/helpers/globals.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginService _loginModel = LoginService();
  bool _isPasswordHidden = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: ColorResources.white,
          body: GestureDetector(
            onTap: () {
              final FocusScopeNode focus = FocusScope.of(context);
              if (!focus.hasPrimaryFocus && focus.hasFocus) {
                FocusManager.instance.primaryFocus!.unfocus();
              }
            },
            child: Padding(
              padding: EdgeInsets.only(top: 50, left: 24, right: 24),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: lightText("Versión: ${version}",
                            ColorResources.grey6B7, 16, TextAlign.center),
                      ),
                      Image.asset(
                        Images.logindetalle,
                        height: 100,
                        width: 250,
                      ),
                      Center(
                        child: Image.asset(
                          Images.logo,
                          height: 200,
                          width: 300,
                        ),
                      ),
                      boldText("Bienvenido(a)", ColorResources.blue1D3, 24),
                      SizedBox(height: 7),
                      lightText(
                          "Accede al campus virtual con tus credenciales SGA",
                          ColorResources.grey6B7,
                          16),
                      SizedBox(height: 25),
                      Container(
                        height: 150,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _loginModel.usernameController,
                              cursorColor: ColorResources.blue1D3,
                              style: TextStyle(
                                color: ColorResources.black,
                                fontSize: 18,
                                fontFamily: TextFontFamily.ROBOTO_REGULAR,
                              ),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 15),
                                prefixText: "   ",
                                hintText: "Ingresa tu usuario",
                                hintStyle: TextStyle(
                                  color: ColorResources.grey9CA,
                                  fontSize: 18,
                                  fontFamily: TextFontFamily.ROBOTO_REGULAR,
                                ),
                                filled: true,
                                fillColor: ColorResources.greyF9F,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorResources.greyF9F, width: 1),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorResources.greyF9F, width: 1),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorResources.greyF9F, width: 1),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: _loginModel.passwordController,
                              cursorColor: ColorResources.blue1D3,
                              style: TextStyle(
                                color: ColorResources.black,
                                fontSize: 18,
                                fontFamily: TextFontFamily.ROBOTO_REGULAR,
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: _isPasswordHidden,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 15),
                                prefixText: "   ",
                                hintText: "Ingresa tu contraseña",
                                hintStyle: TextStyle(
                                  color: ColorResources.grey9CA,
                                  fontSize: 18,
                                  fontFamily: TextFontFamily.ROBOTO_REGULAR,
                                ),
                                filled: true,
                                fillColor: ColorResources.greyF9F,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorResources.greyF9F,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorResources.greyF9F,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorResources.greyF9F,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordHidden
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordHidden = !_isPasswordHidden;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      containerButtonOrange(() async {
                        if (_loginModel.usernameController.text.isEmpty ||
                            _loginModel.passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Por favor, completa todos los campos.')),
                          );
                          return;
                        }
                        setState(() {
                          _isLoading = true;
                        });
                        bool success =
                            await _loginModel.authenticateUser(context);
                        if (!success) {
                          FocusScope.of(context).unfocus();

                          setState(() {
                            _isLoading = false;
                          });
                          // En este punto, el modelo ya ha mostrado el snackbar de error.
                        } else {
                          setState(() {
                            _isLoading = false;
                          });
                          // Navegar a la pantalla principal o cualquier otra acción que desees hacer
                        }
                      }, "Acceder"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isLoading) LoadingOverlay(),
      ],
    );
  }
}
