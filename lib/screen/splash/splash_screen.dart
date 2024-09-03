import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tailor_shop/core/constants/app_assets.dart';

class SplashScreen extends StatefulWidget {
  final NavigatorState navigatorState;
  const SplashScreen({super.key, required this.navigatorState});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initScreen();
  }

  initScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        widget.navigatorState
            .pushNamedAndRemoveUntil('login', (route) => false);
      });
    } else {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        widget.navigatorState.pushNamedAndRemoveUntil('home', (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Image.asset(AppAssets.logoIcon, scale: 8),
            const SizedBox(height: 16),
            const Text(
              'Tailor Shop',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            ),
            Expanded(child: Container()),
            const Text(
              'For www.vingreentech.com',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
