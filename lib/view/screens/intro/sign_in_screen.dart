import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_login_signin/view/all_app_color/app_color.dart';
import 'package:hive_login_signin/view/all_font_size/app_font_size.dart';
import 'package:hive_login_signin/view/screens/intro/home_screen.dart';
import 'package:hive_login_signin/view/screens/intro/login_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signInUser(BuildContext context) async {
    final box = Hive.box('userBox');
    final username = nameController.text.trim();
    final userEmail = emailController.text.trim();
    final password = passwordController.text.trim();


    if (userEmail.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
      if (box.containsKey(userEmail)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email already exists!')),
        );
      } else {
        await box.put(userEmail, {'username': username, 'password': password});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User Registered!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
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
                  'Register',
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
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: AllAppColor.appbarColor,
                        ),
                        labelText: 'Enter name',
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
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AllAppColor.appbarColor,
                      foregroundColor: AllAppColor.appPrimaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15)),
                  onPressed: () => signInUser(context),
                  child: Text('Signup', style: TextStyle(fontSize: AllAppTextSize.appSubtitleTextSize),
                  )),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have account? ', style: TextStyle(
                        fontSize: AllAppTextSize.appSubtitleTextSize,
                        color: AllAppColor.apptitleColor),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Text('PleaseLogin', style: TextStyle(fontSize: AllAppTextSize.appSubtitleTextSize,
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
