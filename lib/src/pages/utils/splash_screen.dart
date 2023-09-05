import 'package:flutter/material.dart';
import 'package:apptei/src/utils/images.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFE9900),
        body: Column(
          children: [
            Image.asset(
              Images.logindetalle,
              width: 550,
              height: 200,
            ),
            const SizedBox(height: 120),
            Center(
              child: Image.asset(
                Images.logowhite,
                width: 250,
                height: 150,
              ),
            ),
          ],
        ));
  }
}
