// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_config.dart'; // importando a configuração separada
import 'pages/readings_page.dart'; // sua página principal de leituras

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle de Leituras',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ReadingsPage(),
    );
  }
}
