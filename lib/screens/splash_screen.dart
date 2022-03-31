import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:news_it/screens/home_screen.dart';
import 'package:news_it/screens/register.dart';
import 'package:news_it/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Data d = Data();
  @override
  void initState() {
    super.initState();
    getApi();
    Timer(const Duration(seconds: 4), () {
      checkFirstSeen();
    });
  }

  getApi() async {
    await d.getApiId();
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RegisterScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Center(
        child: TextLiquidFill(
          text: 'NewsIt',
          boxHeight: MediaQuery.of(context).size.height,
          boxWidth: MediaQuery.of(context).size.width,
          loadDuration: const Duration(seconds: 4),
          waveDuration: const Duration(seconds: 4),
          waveColor: Theme.of(context).primaryColor,
          boxBackgroundColor: Colors.blue,
          textStyle: const TextStyle(
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
  }
}
