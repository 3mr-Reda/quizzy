import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizzy/main.dart';
import 'package:quizzy/screens/category_details_screen.dart';
import 'package:quizzy/screens/profile_screen.dart';
import 'package:quizzy/screens/quiz_in_progress_screen.dart';
import 'package:quizzy/screens/quiz_screen.dart';
import 'package:quizzy/screens/final_screen.dart';
import 'package:quizzy/screens/result_screen.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizzyApp());
    expect(find.text('Quizzy'), findsOneWidget);
    expect(find.text('Test Your Knowledge'), findsOneWidget);
  });

  testWidgets('Home screen smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 860 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const QuizzyApp());
    // Pump past the 2.8s timer to trigger transition to HomeScreen
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pumpAndSettle();

    // Verify header elements
    expect(find.text('Good Morning,'), findsOneWidget);
    expect(find.text('Ready to test your knowledge?'), findsOneWidget);
    expect(find.text('Choose a category and start your journey!'), findsOneWidget);

    // Verify all 6 categories
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('Dart'), findsOneWidget);
    expect(find.text('General\nKnowledge'), findsOneWidget);
    expect(find.text('Mathematics'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Science'), findsOneWidget);

    // Verify bottom nav items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Quizzes'), findsOneWidget);
    expect(find.text('Results'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Category details screen smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 860 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: CategoryDetailsScreen(),
      ),
    );

    // Verify header card elements
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('Test your Flutter knowledge!'), findsOneWidget);
    expect(find.text('10 Questions'), findsOneWidget);
    expect(find.text('15 Minutes'), findsOneWidget);

    // Verify sections
    expect(find.text('About this quiz'), findsOneWidget);
    expect(find.text('Instructions'), findsOneWidget);
    expect(find.text('Choose the correct answer from 4 options.'), findsOneWidget);
    expect(find.text("You can't change your answer after submission."), findsOneWidget);
    expect(find.text('Complete all questions before time runs out.'), findsOneWidget);

    // Verify Start Quiz button
    expect(find.text('Start Quiz'), findsOneWidget);
  });

  testWidgets('Quiz screen smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 860 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: QuizScreen(),
      ),
    );

    // Verify progress text (e.g. 1/10)
    expect(find.text('1/10'), findsOneWidget);

    // Verify Next button
    expect(find.text('Next'), findsOneWidget);

    // Verify timer icon
    expect(find.byIcon(Icons.access_time_rounded), findsOneWidget);

    // Verify at least 4 options are rendered (4 radio buttons)
    expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(4));

    // Tap first option
    await tester.tap(find.byIcon(Icons.radio_button_unchecked).first);
    await tester.pump();

    // Verify radio button becomes checked
    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('Final screen (Time\'s Up) smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 860 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: FinalScreen(score: 8, totalQuestions: 10),
      ),
    );

    // Verify header
    expect(find.text("Time's Up!"), findsOneWidget);
    expect(find.text('You answered all the questions'), findsOneWidget);

    // Verify score circular progress text
    expect(find.text('8/10'), findsOneWidget);
    expect(find.text('80%'), findsOneWidget);

    // Verify stat cards
    expect(find.text('Correct'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('Wrong'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // Verify buttons
    expect(find.text('Try Again'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('Profile screen smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 860 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );

    // Verify user name "عمرو"
    expect(find.text('عمرو'), findsOneWidget);
    expect(find.text('Quiz Enthusiast'), findsOneWidget);

    // Verify stats
    expect(find.text('Quizzes Taken'), findsOneWidget);
    expect(find.text('Avg. Score'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('85%'), findsOneWidget);

    // Verify menu items
    expect(find.text('My Results'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Help & Support'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);

    // Tap edit button to open edit modal
    await tester.tap(find.byTooltip('Edit Profile'));
    await tester.pumpAndSettle();

    // Verify Edit Profile modal opened
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
  });

  testWidgets('Quiz in Progress screen smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 860 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: QuizInProgressScreen(),
      ),
    );

    // Verify progress text (e.g. 1/10)
    expect(find.text('1/10'), findsOneWidget);

    // Verify Next button
    expect(find.text('Next'), findsOneWidget);

    // Verify timer icon
    expect(find.byIcon(Icons.access_time_rounded), findsOneWidget);

    // Verify radio buttons
    expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(4));

    // Tap first option
    await tester.tap(find.byIcon(Icons.radio_button_unchecked).first);
    await tester.pump();

    // Verify selected option shows checked radio and checkmark badge
    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

    // Tap Next
    await tester.tap(find.text('Next'));
    await tester.pump();

    // Now on question 2/10
    expect(find.text('2/10'), findsOneWidget);
  });
}
