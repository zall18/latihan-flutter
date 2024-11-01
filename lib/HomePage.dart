import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latihansp4/Connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> data = [];
  String? name = "-";

  Future<void> getData() async {
    var session = await SharedPreferences.getInstance();
    var token = session.getString("token");
    setState(() {
      name = session.getString("name");
    });

    var client =
        await http.get(Uri.parse(Connection().conn + "user/show?token=$token"));

    if (client.statusCode == 200) {
      setState(() {
        data = jsonDecode(client.body)["users"];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Selamat Datang!, $name"),
                    Icon(Icons.person)
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                Container(
                  width: double.maxFinite,
                  height: 140,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.maxFinite,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Ketik untuk mencari sesuatu"),
                        ],
                      )),
                ),
                Expanded(
                    child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var item = data[index];

                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/YPC.png",
                              width: 30,
                              height: 30,
                            ),
                            Text(item["name"]),
                            Text(item["email"]),
                          ],
                        ),
                      ),
                    );
                  },
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
