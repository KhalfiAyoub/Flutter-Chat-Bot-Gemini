import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_chatbot/pages/login.page.dart';
import 'package:mobile_chatbot/pages/chatBot.page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context)=>LoginPage(),
        "/bot": (context)=>chatBotPage()
      },
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent
      ),
    );
  }
}

