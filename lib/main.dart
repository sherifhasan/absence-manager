import 'package:absence_manager/application/absence_cubit.dart';
import 'package:absence_manager/presentation/attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection.dart';

void main() {
  setUpInjections(); // Initialize the service locator
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injection<AbsenceCubit>()..loadInitialData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Attendance System',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AttendanceScreen(),
      ),
    );
  }
}
