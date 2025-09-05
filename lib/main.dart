import 'package:flutter/material.dart';
import 'package:talk_to_draw_new/splash_screen.dart';

import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => const MySplashPage(),
        '/home_screen': (context) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,

    );
  }
}