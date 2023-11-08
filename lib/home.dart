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
  Widget build(BuildContext context) {
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
              _getDrawerElements(),
        ),
      ),
      backgroundColor: fgColor,
    );
  }

  bool hideInvalidAuth = true;
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
        Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: ElevatedButton(
            onPressed: () async {
              await (await SharedPreferences.getInstance()).remove(srinkApikey);
              apiKey = "";
              setState(() {});
            },
            child: Text("Logout"),
          ),
        ),
      ];
    }
    final TextEditingController tokenController = TextEditingController();
    List<Padding> invalidAuthWidget() {
      if (hideInvalidAuth) {
        return [];
      }
      return [
        Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Text(
            "The auth token you entered was invalid, please try again.",
            style: TextStyle(
              color: Color.fromARGB(255, 220, 60, 60),
              fontSize: 13,
            ),
          ),
        )
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
                controller: tokenController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: txtColor),
                  labelText: "API Key",
                  fillColor: Colors.grey,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter some text";
                  }
                  return null;
                },
              ),
            ),
          )
        ] +
        invalidAuthWidget() +
        [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  hideInvalidAuth = true;
                  setState(() {});
                  return;
                }
                SrinkResponse resp = await shortenUrl(
                    "https://test.com", "test", tokenController.text);
                if (!resp.ok) {
                  hideInvalidAuth = false;
                } else {
                  hideInvalidAuth = true;
                  await (await SharedPreferences.getInstance())
                      .setString(srinkApikey, tokenController.text);
                  apiKey = tokenController.text;
                }
                setState(() {});
              },
              child: Text("Login"),
            ),
          ),
        ];
  }
}
