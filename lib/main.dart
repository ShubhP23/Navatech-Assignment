import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navatech/src/model/album_model.dart';
import 'package:navatech/src/model/photo_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AlbumModelAdapter());
  Hive.registerAdapter(PhotoModelAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navatech Assignment',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(
        body: Center(child: Text('Navatech Assignment Starting...')),
      ),
    );
  }
}
