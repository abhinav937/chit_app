import 'package:flutter/material.dart';
import 'chit_form.dart'; // Import the file where chit_form function is defined

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
            MaterialPageRoute(builder: (context) => chit_form(context)),
          );
        },
        label: const Text('New Seetu'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
