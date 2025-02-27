import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_login_signin/view/screens/intro/home_screen.dart';
import 'package:hive_login_signin/view/screens/intro/sign_in_screen.dart';
import '../../all_app_color/app_color.dart';
import '../../all_font_size/app_font_size.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Box userBox = Hive.box('userBox');

  void userLoggedIn(BuildContext context) {
    userBox.put('isLoggedIn', true);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void loginUser(BuildContext context) async {
    final box = Hive.box('userBox');
    final useremail = emailController.text.trim();
    final password = passwordController.text.trim();

    if (box.containsKey(useremail)) {
      final userData = box.get(useremail) as Map;
      if (userData['password'] == password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User Logged In successfully!')),
        );
        userLoggedIn(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect password')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 88.0),
                child: Text(
                  'LogIn',
                  style: TextStyle(
                      color: AllAppColor.appbarColor,
                      fontSize: AllAppTextSize.appbarTextSize),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Card(
                    elevation: AllAppTextSize.appElevTextSize,
                    color: AllAppColor.appPrimaryColor,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AllAppColor.appbarColor,
                        ),
                        labelText: 'Enter email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13)),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Card(
                    elevation: AllAppTextSize.appElevTextSize,
                    color: AllAppColor.appPrimaryColor,
                    child: TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.password,
                          color: AllAppColor.appbarColor,
                        ),
                        labelText: 'Enter password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13)),
                      ),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AllAppColor.appbarColor,
                      foregroundColor: AllAppColor.appPrimaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 55, vertical: 15)),
                  onPressed: () => loginUser(context),
                  child: Text(
                    'LogIn',
                    style:
                        TextStyle(fontSize: AllAppTextSize.appSubtitleTextSize),
                  )),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have account? ',
                    style: TextStyle(
                        fontSize: AllAppTextSize.appSubtitleTextSize,
                        color: AllAppColor.apptitleColor),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()));
                      },
                      child: Text(
                        'PleaseSignup',
                        style: TextStyle(
                            fontSize: AllAppTextSize.appSubtitleTextSize,
                            color: AllAppColor.appbarColor),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
