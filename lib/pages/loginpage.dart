import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uisample/pages/homepage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool isPasswordvisible = false;
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  String username = "admin";
  String password = "admin123";
  late SharedPreferences preferences;
  late bool newuser;
  @override
  void initState() {
    check_user_already_login();
    super.initState();
  }

  void check_user_already_login() async {
    preferences = await SharedPreferences.getInstance();
    newuser = preferences.getBool('newuser') ?? true;
    if (newuser == false) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Myhomepage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/todo.jpeg"),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: usernamecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    hintText: "Enter username/ Phone Number"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: passwordcontroller,
                obscureText: isPasswordvisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  hintText: "Enter Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        if (isPasswordvisible == false) {
                          isPasswordvisible = true;
                        } else {
                          isPasswordvisible = false;
                        }
                      });
                    },
                    icon: isPasswordvisible == false
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(360, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  )),
              onPressed: () async {
                preferences = await SharedPreferences.getInstance();
                String uname = usernamecontroller.text;
                String pass = passwordcontroller.text;

                if (uname == username && pass == password) {
                  preferences.setString('username', uname);
                  preferences.setString('password', pass);

                  preferences.setBool('newuser', false);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Myhomepage()));
                }

                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text("invalid username and password")));
                // }
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
