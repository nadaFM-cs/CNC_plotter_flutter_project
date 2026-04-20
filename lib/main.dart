
import 'package:cnc_plotter/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/api_service.dart';
import 'cubit/sketch_cubit.dart';

void main() {
  final api = ApiService("http://192.168.137.247:8000");

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SketchCubit(api),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  StartScreen(),
    );
  }
}