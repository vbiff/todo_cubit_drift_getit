import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/core/service_locator.dart';
import 'package:todo_cubit/presentation/home-screen/cubit.dart';
import 'package:todo_cubit/presentation/home-screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  runApp(BlocProvider(create: (context) => sl<TodosCubit>(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}
