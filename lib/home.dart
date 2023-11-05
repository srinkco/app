// ignore_for_file: prefer_const_constructors
import 'package:srink/api.dart';
import 'package:srink/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<Widget> drawer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    drawer = _getDrawerElements();
    return Scaffold(
      appBar: AppBar(
        title: Text("Srink Link Shortener"),
        backgroundColor: bgColor,
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: drawerBgColor,
        child: ListView(
          children: const <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: drawerBoxColor,
                  ),
                  child: Center(
                    child: Text(
                      "Srink.co",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 195, 31),
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ] +
              drawer,
        ),
      ),
      backgroundColor: fgColor,
    );
  }

  List<Widget> _getDrawerElements() {
    if (apiKey.isNotEmpty) {
      return [
        Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            "Logged In Successfully",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ];
    }
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            style: const TextStyle(color: txtColor),
            cursorColor: const Color.fromARGB(255, 158, 158, 158),
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: txtColor),
              hintText: "Enter API Key",
              hoverColor: Colors.blueGrey,
              focusColor: Colors.grey,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter some text";
              }
              String? error;
              void checkToken(String token) async {
                SrinkResponse resp =
                    await shortenUrl("https://test.com", "test", token);
                if (resp.ok) {
                  error = "nothing";
                  return;
                }
                error = resp.error;
              }

              checkToken(value);
              if (error != null) {
                return error;
              }

              SharedPreferences.getInstance()
                  .then(
                    (spi) => spi.setString(
                      srinkApikey,
                      value,
                    ),
                  )
                  .whenComplete(() => null);
              return null;
            },
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            drawer.clear();
            drawer.add(Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Text(
                "Logged In Successfully",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ));
            setState(() {});
          },
          child: Text("Login"),
        ),
      ),
    ];
  }
}
