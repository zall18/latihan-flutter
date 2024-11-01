import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latihansp4/Connection.dart';
import 'package:latihansp4/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _nisnController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  Future<void> Login() async {
    String nisn = _nisnController.text;
    String password = _passwordController.text;

    var client = await http.post(Uri.parse(Connection().conn + "login"),
        body: {"email": nisn, "password": password});

    if (client.statusCode == 200) {
      var data = jsonDecode(client.body);
      log(data.toString());

      var session = await SharedPreferences.getInstance();
      await session.setString("token", data["token"]);
      await session.setString("name", data["user"]["name"]);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Berhasil")));

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
    } else {
      var data = jsonDecode(client.body);
      log(data.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Gagal")));
    }
  }

  void showPassword() {
    if (_isObscure) {
      setState(() {
        _isObscure = false;
      });
    } else {
      setState(() {
        _isObscure = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue, const Color.fromARGB(255, 62, 157, 234)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            child: Form(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 60,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _nisnController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Nisn"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "password",
                        suffixIcon: IconButton(
                            onPressed: showPassword,
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off))),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.maxFinite,
                  child: ElevatedButton(onPressed: Login, child: Text("Login")),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}
