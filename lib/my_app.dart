import 'package:flutter/material.dart';
import 'package:viacepapp/pages/my_home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Via Cep DIO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 5, 51, 121)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Via Cep DIO'),
    );
  }
}
