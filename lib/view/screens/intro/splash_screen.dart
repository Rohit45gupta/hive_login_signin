import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_login_signin/view/screens/intro/home_screen.dart';
import 'package:hive_login_signin/view/screens/intro/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late Box userBox = Hive.box('userBox');

  @override
  void initState() {
    super.initState();
    userBox = Hive.box('userBox');
    checkLoginStatus();
  }

  void checkLoginStatus() {
    bool? isLoggedIn = userBox.get('isLoggedIn', defaultValue: false);
    Timer(const Duration(seconds: 3), (){
      if (isLoggedIn == true) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              maxRadius: 60,
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6pqpbGnaKTQnrUCNPQXisCgZTO1_R-nHKZ9bT33NMGYEiROjTA-E_xP0&s'),
            )
          ],
        ),
      ),
    );
  }
}
