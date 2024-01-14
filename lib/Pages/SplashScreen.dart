import 'package:flutter/material.dart';
import '../Pages/EnterPage.dart';
import '../Style/styleapp.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/splashscreen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      Get.to(() => const EnterPage(), transition: Transition.topLevel, duration: const Duration(milliseconds: 2500));
      // Get.to(() => const OtpVerification(dataReceiveFromRegisterPage: 'Ini ada datanya lohh'), transition: Transition.topLevel, duration: const Duration(milliseconds: 2500));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [Colors.white, Colors.white],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Image/logodispendukcapilmalang.png',
                  width: 200,
                  height: 200,),
                const SizedBox(height: 40.0),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [Colors.blue, Colors.green],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'DIAGRAM\nKEPENDUDUKAN',
                      style: StyleApp.giantTextStyle.copyWith(
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [Colors.limeAccent, Colors.greenAccent],
                          ).createShader(const Rect.fromLTWH(0.0, 0.0, 10.0, 100.0)),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
