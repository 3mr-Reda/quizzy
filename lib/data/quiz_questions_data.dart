import 'dart:math';
import '../models/question_model.dart';

final Map<String, List<QuizQuestion>> allCategoryQuestions = {
  // 1. FLUTTER
  'flutter': [
    const QuizQuestion(
      question: 'What is the output or behavior of this code?',
      codeSnippet: 'void main() {\n  print(1 + 2 + 3);\n}',
      options: ['6', '5', '3', '1'],
      correctIndex: 0,
    ),
    const QuizQuestion(
      question: 'What is the main language used in Flutter development?',
      options: ['Java', 'Dart', 'Kotlin', 'Swift'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which widget is used to arrange widgets vertically in Flutter?',
      options: ['Row', 'Column', 'Stack', 'Wrap'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What function is the entry point of every Flutter application?',
      options: ['runApp()', 'main()', 'build()', 'init()'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which file contains Flutter dependencies and configuration?',
      options: ['config.json', 'pubspec.yaml', 'package.json', 'manifest.xml'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which widget rebuilds its UI when its state changes?',
      options: ['StatelessWidget', 'StatefulWidget', 'InheritedWidget', 'Container'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What command is used to trigger hot reload in the terminal?',
      options: ['R', 'r', 'q', 'c'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which method informs the framework that internal state has changed?',
      options: ['refresh()', 'setState()', 'update()', 'notify()'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which widget allows overlapping children on top of each other?',
      options: ['Column', 'Stack', 'ListView', 'Flex'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What rendering engine does Flutter use to draw pixels on screen?',
      options: ['WebKit', 'Impeller / Skia', 'Gecko', 'Blink'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which widget provides the standard Material Design visual layout structure?',
      options: ['Container', 'Scaffold', 'AppView', 'MaterialSurface'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is BuildContext in Flutter?',
      options: [
        'A memory cache',
        'A handle to the location of a widget in the widget tree',
        'A database connection',
        'A background thread'
      ],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which widget makes any child clickable with a ripple effect?',
      options: ['GestureDetector', 'InkWell', 'Listener', 'PointerEvent'],
      correctIndex: 1,
    ),
  ],

  // 2. DART
  'dart': [
    const QuizQuestion(
      question: 'What is the output of this code?',
      codeSnippet: 'void main() {\n  print(1 + 2 + 3);\n}',
      options: ['6', '5', '3', '1'],
      correctIndex: 0,
    ),
    const QuizQuestion(
      question: 'What will be printed to the console?',
      codeSnippet: 'void main() {\n  var list = [1, 2, 3];\n  print(list.where((x) => x > 1).length);\n}',
      options: ['2', '3', '1', 'Compile Error'],
      correctIndex: 0,
    ),
    const QuizQuestion(
      question: 'What type system does modern Dart use by default?',
      options: ['Dynamic typing', 'Sound Null Safety', 'Loose typing', 'No typing'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which keyword declares a compile-time constant in Dart?',
      options: ['final', 'const', 'static', 'var'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which operator is known as the null-aware operator in Dart?',
      options: ['??', '?.', '?:', '!'],
      correctIndex: 0,
    ),
    const QuizQuestion(
      question: 'What is used in Dart to share code across multiple class hierarchies without inheritance?',
      options: ['Abstract class', 'Mixin', 'Interface', 'Trait'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What object represents a potential value or error available at some time in the future?',
      options: ['Stream', 'Future', 'Isolate', 'Yield'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the entry point of every Dart program?',
      options: ['start()', 'main()', 'execute()', 'run()'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'How do you define private variables or methods in a Dart library?',
      options: ['private keyword', 'Prefix with underscore _', '# prefix', 'hide keyword'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which keyword is used to pause execution until a Future completes?',
      options: ['defer', 'await', 'hold', 'sync'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What entity handles concurrent execution with separate memory heaps in Dart?',
      options: ['Thread', 'Isolate', 'Coroutine', 'Worker'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What type represents an asynchronous sequence of data in Dart?',
      options: ['Future', 'Stream', 'Iterable', 'Generator'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which collection type in Dart contains unordered unique elements?',
      options: ['List', 'Set', 'Map', 'Queue'],
      correctIndex: 1,
    ),
  ],

  // 3. GENERAL KNOWLEDGE
  'general_knowledge': [
    const QuizQuestion(
      question: 'Which planet is known as the Red Planet?',
      options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the largest ocean on Earth?',
      options: ['Atlantic Ocean', 'Pacific Ocean', 'Indian Ocean', 'Arctic Ocean'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'In which country are the Great Pyramids of Giza located?',
      options: ['Sudan', 'Egypt', 'Greece', 'Mexico'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Who painted the Mona Lisa?',
      options: ['Vincent van Gogh', 'Leonardo da Vinci', 'Pablo Picasso', 'Claude Monet'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the hardest natural mineral found on Earth?',
      options: ['Gold', 'Diamond', 'Topaz', 'Quartz'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the capital city of Japan?',
      options: ['Kyoto', 'Tokyo', 'Osaka', 'Hiroshima'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'How many continents are there on Earth?',
      options: ['5', '7', '6', '8'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which element has the chemical symbol "O"?',
      options: ['Gold', 'Oxygen', 'Osmium', 'Oganesson'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the longest river in the world?',
      options: ['Amazon River', 'Nile River', 'Yangtze River', 'Mississippi River'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'In which year did the Apollo 11 moon landing take place?',
      options: ['1965', '1969', '1972', '1961'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the currency of the United Kingdom?',
      options: ['Euro', 'Pound Sterling', 'Dollar', 'Franc'],
      correctIndex: 1,
    ),
  ],

  // 4. MATHEMATICS
  'mathematics': [
    const QuizQuestion(
      question: 'What is the square root of 144?',
      options: ['10', '12', '14', '16'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the value of Pi rounded to two decimal places?',
      options: ['3.12', '3.14', '3.16', '3.18'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is 15% of 200?',
      options: ['25', '30', '35', '40'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the only even prime number?',
      options: ['0', '2', '4', '6'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the sum of angles in a triangle?',
      options: ['90 degrees', '180 degrees', '270 degrees', '360 degrees'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'If 3x + 5 = 20, what is the value of x?',
      options: ['3', '5', '7', '15'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is 2 raised to the power of 8 (2^8)?',
      options: ['128', '256', '512', '1024'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'How many sides does a regular hexagon have?',
      options: ['5', '6', '7', '8'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the perimeter of a square with a side length of 9 cm?',
      options: ['18 cm', '36 cm', '81 cm', '27 cm'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is 7 multiplied by 8?',
      options: ['54', '56', '58', '62'],
      correctIndex: 1,
    ),
  ],

  // 5. ENGLISH
  'english': [
    const QuizQuestion(
      question: 'What is the synonym of the word "Brave"?',
      options: ['Timid', 'Courageous', 'Cautious', 'Fearful'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which of the following is an adverb in English?',
      options: ['Quick', 'Quickly', 'Quicken', 'Quickness'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the past tense of the irregular verb "run"?',
      options: ['Runned', 'Ran', 'Running', 'Runs'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Choose the correct sentence:',
      options: [
        'She don\'t like apples.',
        'She doesn\'t like apples.',
        'She not like apples.',
        'She isn\'t like apples.'
      ],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the antonym of "Generous"?',
      options: ['Kind', 'Stingy', 'Friendly', 'Giving'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which article should precede the word "Honest"?',
      options: ['A', 'An', 'The', 'None'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is a group of lions called?',
      options: ['Flock', 'Pride', 'Pack', 'Herd'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which part of speech connects words or phrases (e.g. "and", "but")?',
      options: ['Preposition', 'Conjunction', 'Interjection', 'Adjective'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the plural of "Child"?',
      options: ['Childs', 'Children', 'Childrens', 'Childes'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What literary device gives human characteristics to non-human things?',
      options: ['Metaphor', 'Personification', 'Hyperbole', 'Simile'],
      correctIndex: 1,
    ),
  ],

  // 6. SCIENCE
  'science': [
    const QuizQuestion(
      question: 'What is the chemical formula for water?',
      options: ['CO2', 'H2O', 'NaCl', 'O2'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What organ in the human body pumps blood through the circulatory system?',
      options: ['Lungs', 'Heart', 'Liver', 'Kidneys'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What process do plants use to convert sunlight into food?',
      options: ['Respiration', 'Photosynthesis', 'Fermentation', 'Oxidation'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the center of an atom called?',
      options: ['Electron', 'Nucleus', 'Proton', 'Neutron'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the closest star to Earth?',
      options: ['Proxima Centauri', 'The Sun', 'Sirius', 'Alpha Centauri'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which gas do humans primarily inhale for cellular respiration?',
      options: ['Nitrogen', 'Oxygen', 'Carbon Dioxide', 'Argon'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What force pulls objects towards the center of the Earth?',
      options: ['Magnetism', 'Gravity', 'Friction', 'Inertia'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'At what temperature does pure water boil at sea level?',
      options: ['90°C', '100°C', '110°C', '120°C'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which blood cells fight infections and pathogens in the body?',
      options: ['Red blood cells', 'White blood cells', 'Platelets', 'Plasma'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What molecule carries genetic instructions in living organisms?',
      options: ['ATP', 'DNA', 'RNA', 'Hemoglobin'],
      correctIndex: 1,
    ),
  ],
};

/// Retrieves a shuffled list of random questions for a given category every time
List<QuizQuestion> getRandomQuestionsForCategory(String categoryId, {int count = 10}) {
  final categoryKey = categoryId.toLowerCase();
  final list = allCategoryQuestions[categoryKey] ?? allCategoryQuestions['flutter']!;

  // Create a copy, shuffle questions randomly
  final shuffledList = List<QuizQuestion>.from(list)..shuffle(Random());

  // Take requested count (or maximum available)
  final selected = shuffledList.take(count).toList();

  return selected;
}
