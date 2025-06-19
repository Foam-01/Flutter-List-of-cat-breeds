import 'package:flutter/material.dart';
import 'pages/cat_breed_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Breeds',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CatBreedListPage(),
    );
  }
}
