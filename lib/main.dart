// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import './pages/chit_form.dart'; // Import the file where chit_form function is defined

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chit Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(0, 0, 0, 0)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Seetu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500, // Change the font weight to bold
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Call chit_form when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChitForm()),
          );
        },
        label: const Text('New Seetu'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
