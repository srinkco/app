// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srink/api.dart';
import 'package:srink/config.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<String> _fetchToken() async {
    final pref = await SharedPreferences.getInstance();

    final token = pref.getString(srinkApikey);
    if (token == null) {
      return "";
    }

    SrinkResponse resp = await shortenUrl("https://test.com", "test", token);
    if (!resp.ok) {
      // logout if token invalid
      await pref.remove(srinkApikey);
      return "";
    }

    return token;
  }

  late Future<String> futureFetchToken;

  @override
  void initState() {
    super.initState();
    futureFetchToken = _fetchToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: FutureBuilder<String>(
        future: futureFetchToken,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = [
              Center(
                child: Text(
                  "Logged In Successfully",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ];
            apiKey = snapshot.data;
            SchedulerBinding.instance.addPostFrameCallback(
              (_) => Navigator.popAndPushNamed(context, '/'),
            );
          } else if (snapshot.hasError) {
            return SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Error",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Divider(
                      height: 20,
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Text(
                          "${snapshot.error}",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            children = const [
              Text(
                "Srink.Co",
                style: TextStyle(
                  color: Color.fromARGB(255, 212, 212, 212),
                  fontFamily: "sans-serif",
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              Divider(
                color: bgColor,
                height: 30,
              ),
              CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ];
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          );
        },
      ),
    );
  }
}
