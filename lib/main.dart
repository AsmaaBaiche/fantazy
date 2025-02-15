import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/team_selection_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/RegisterScreen.dart';
import 'screens/ProfileScreen.dart';
import 'screens/HomeScreen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy Football Jazair',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF1A1B1E),
        colorScheme: ColorScheme.dark(
          primary: Colors.purple,
          secondary: Colors.purpleAccent,
        ),
      ),
      initialRoute: '/',
      routes: {
     '/': (context) => const SplashScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/team': (context) => const TeamSelectionScreen(),
  '/leaderboard': (context) =>  LeaderboardScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/home': (context) => const HomeScreen(),
      },
    );
  }
}