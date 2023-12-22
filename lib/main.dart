// ignore_for_file: prefer_const_constructors
import 'package:srink/splash.dart';
import 'package:srink/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/splash",
    routes: {
      '/splash': (context) => SplashScreen(),
      '/': (context) => HomePage(),
    },
  ));
}
