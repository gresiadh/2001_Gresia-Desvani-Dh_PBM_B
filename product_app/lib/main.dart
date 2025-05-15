import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';  
import 'package:product_app/screen/home_screen.dart';
import 'firebase_options.dart';                      

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProductApp Gresia Desvani Dharmawan',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
