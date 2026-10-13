import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/category_details_screen.dart';
import 'screens/category_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/final_screen.dart';
import 'screens/quiz_in_progress_screen.dart';
import 'screens/result_screen.dart';
import 'screens/review_answers_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const QuizzyApp());
}

class QuizzyApp extends StatelessWidget {
  const QuizzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizzy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF506DF2),
          surface: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/categories': (context) => const CategoryListScreen(),
        '/category_details': (context) => const CategoryDetailsScreen(),
        '/quiz': (context) => const QuizInProgressScreen(),
        '/final': (context) => const FinalScreen(),
        '/result': (context) => const FinalScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/review_answers': (context) => const ReviewAnswersScreen(
              questions: [],
              userAnswers: [],
              category: QuizCategory(
                id: 'flutter',
                title: 'Flutter',
                color: Color(0xFF0284C7),
                isFlutterLogo: true,
              ),
              score: 0,
            ),
      },
    );
  }
}
