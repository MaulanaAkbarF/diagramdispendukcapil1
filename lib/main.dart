import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../Components/BottomNavigationBar.dart';
import 'Pages/SplashScreen.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Obnutries',
      initialRoute: SplashScreen.routeName,
      debugShowCheckedModeBanner: false,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        CustomBottomNavigationBar.routeName: (context) => const CustomBottomNavigationBar(),
      },
    );
  }
}
