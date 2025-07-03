import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navatech/src/bloc/album/album_bloc.dart';
import 'package:navatech/src/data/local/local_storage_service.dart';
import 'package:navatech/src/data/remote/api_service.dart';
import 'package:navatech/src/data/repository/photo_repository.dart';
import 'package:navatech/src/model/album_model.dart';
import 'package:navatech/src/model/photo_model.dart';
import 'package:navatech/src/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AlbumModelAdapter());
  Hive.registerAdapter(PhotoModelAdapter());

  final repository = PhotoRepository(
    api: ApiService(),
    local: LocalStorageService(),
  );

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final PhotoRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: repository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AlbumBloc(repository: repository)),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        ),
      ),
    );
  }
}
