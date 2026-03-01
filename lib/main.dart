import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MindReaderApp());
}

class MindReaderApp extends StatelessWidget {
  const MindReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101116),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE13CFF),
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(color: Color(0xFFC8C8C8)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = <_GameCardData>[
      _GameCardData(
        title: 'Binary Number Prediction',
        description:
            'I can guess the number you are thinking from 0 to 63 with a few yes/no answers.',
        icon: Icons.my_location_outlined,
        screenBuilder: (_) => const BinaryPredictionScreen(),
      ),
      _GameCardData(
        title: 'Magic Square Prediction',
        description: 'Pick a number from a magic square, and I will predict the final number.',
        icon: Icons.grid_4x4,
        screenBuilder: (_) => const MagicSquareScreen(),
      ),
      _GameCardData(
        title: 'Always 1089 Trick',
        description: 'Pick a 3-digit number and follow simple steps. The answer is always 1089!',
        icon: Icons.auto_awesome,
        screenBuilder: (_) => const Always1089Screen(),
      ),
      _GameCardData(
        title: 'The Missing Card Trick',
        description: 'Think of a card... it will disappear!',
        icon: Icons.style,
        screenBuilder: (_) => const MissingCardScreen(),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 110,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Mind Reader', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500)),
              const SizedBox(height: 14),
              const Text('Choose a Game', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: games.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: game.screenBuilder),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7E7EC),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(game.icon, color: const Color(0xFFE13CFF), size: 30),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    game.title,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    game.description,
                                    style: const TextStyle(color: Color(0xFF666666), fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameCardData {
  _GameCardData({
    required this.title,
    required this.description,
    required this.icon,
    required this.screenBuilder,
  });

  final String title;
  final String description;
  final IconData icon;
  final WidgetBuilder screenBuilder;
}

class BinaryPredictionScreen extends StatefulWidget {
  const BinaryPredictionScreen({super.key});

  @override
  State<BinaryPredictionScreen> createState() => _BinaryPredictionScreenState();
}

class _BinaryPredictionScreenState extends State<BinaryPredictionScreen> {
  int _step = 0;
  int _result = 0;

  List<int> _numbersForStep(int bit) {
    final value = 1 << bit;
    return List<int>.generate(63, (index) => index + 1)
        .where((n) => (n & value) == value)
        .toList();
  }

  void _answer(bool yes) {
    if (yes) {
      _result += 1 << _step;
    }
    if (_step == 5) {
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('I got it!'),
          content: Text('Your number is $_result.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _step = 0;
                  _result = 0;
                });
              },
              child: const Text('Play again'),
            ),
          ],
        ),
      );
      return;
    }
    setState(() => _step++);
  }

  @override
  Widget build(BuildContext context) {
    final numbers = _numbersForStep(_step);
    return Scaffold(
      appBar: AppBar(title: const Text('Binary Number Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                6,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index <= _step ? const Color(0xFFE13CFF) : Colors.white30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Is the number here?',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Expanded(
              child: GridView.builder(
                itemCount: numbers.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (_, index) => Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE13CFF), width: 1.2),
                    color: const Color(0xFF35103D),
                  ),
                  child: Text(
                    '${numbers[index]}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _pillButton('YES', () => _answer(true)),
                _pillButton('NO', () => _answer(false)),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class MagicSquareScreen extends StatefulWidget {
  const MagicSquareScreen({super.key});

  @override
  State<MagicSquareScreen> createState() => _MagicSquareScreenState();
}

class _MagicSquareScreenState extends State<MagicSquareScreen> {
  static const square = [
    [8, 1, 6],
    [3, 5, 7],
    [4, 9, 2],
  ];

  int? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Magic Square Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            SizedBox(
              width: 260,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                ),
                itemBuilder: (_, index) {
                  final row = index ~/ 3;
                  final col = index % 3;
                  final value = square[row][col];
                  final isChosen = selected == value;
                  return InkWell(
                    onTap: () => setState(() => selected = value),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE13CFF), width: 1.4),
                        color: isChosen ? const Color(0xFF622072) : const Color(0xFF11131A),
                      ),
                      child: Text('$value', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 26),
            const Text('Pick a number', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _pillButton('Next', selected == null ? null : () => _showPrediction(context)),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  void _showPrediction(BuildContext context) {
    if (selected == null) return;
    final predicted = 15 - selected!;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('My prediction'),
        content: Text('No matter your choices, the paired total will be 15.\n\nYour complementary number is $predicted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cool')),
        ],
      ),
    );
  }
}

class Always1089Screen extends StatefulWidget {
  const Always1089Screen({super.key});

  @override
  State<Always1089Screen> createState() => _Always1089ScreenState();
}

class _Always1089ScreenState extends State<Always1089Screen> {
  int _step = 0;

  static const instructions = [
    'Think of any 3-digit number where first and last digits differ by at least 2.',
    'Reverse it and subtract the smaller from the larger.',
    'Reverse your result and add them together.',
    'Your final answer is always 1089 🎉',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Always 1089 Trick')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Step ${_step + 1}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1E27),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE13CFF), width: 1),
              ),
              child: Text(
                instructions[_step],
                style: const TextStyle(fontSize: 24, height: 1.35),
              ),
            ),
            const Spacer(),
            _pillButton(
              _step == instructions.length - 1 ? 'Restart' : 'Continue',
              () => setState(() {
                _step = (_step + 1) % instructions.length;
              }),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class MissingCardScreen extends StatefulWidget {
  const MissingCardScreen({super.key});

  @override
  State<MissingCardScreen> createState() => _MissingCardScreenState();
}

class _MissingCardScreenState extends State<MissingCardScreen> {
  final Random _random = Random();

  List<String> _cards = const [
    '7♠',
    '2♦',
    '7♣',
    '4♥',
    'A♣',
    '7♣',
  ];

  bool _revealed = false;
  int _missingIndex = 0;

  void _doTrick() {
    setState(() {
      _revealed = true;
      _missingIndex = _random.nextInt(_cards.length);
    });
  }

  void _reset() {
    setState(() {
      _revealed = false;
      _missingIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('The Missing Card Trick')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              _revealed ? 'Your card is gone ✨' : 'Pick a card in your mind',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            Expanded(
              child: GridView.builder(
                itemCount: _cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (_, index) {
                  if (_revealed && index == _missingIndex) {
                    return const SizedBox.shrink();
                  }
                  return _cardView(_cards[index]);
                },
              ),
            ),
            _pillButton(_revealed ? 'Try Again' : 'I have picked', _revealed ? _reset : _doTrick),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget _cardView(String label) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFFE13CFF), width: 1.5),
      color: const Color(0xFF121521),
    ),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(label, style: const TextStyle(color: Color(0xFFE13CFF), fontSize: 22)),
        ),
        Center(
          child: Text(
            label.characters.first,
            style: const TextStyle(color: Color(0xFFE13CFF), fontSize: 56, fontWeight: FontWeight.bold),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Transform.rotate(
            angle: pi,
            child: Text(label, style: const TextStyle(color: Color(0xFFE13CFF), fontSize: 22)),
          ),
        ),
      ],
    ),
  );
}

Widget _pillButton(String text, VoidCallback? onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFA01DB8),
      foregroundColor: Colors.white,
      disabledBackgroundColor: Colors.white24,
      elevation: 14,
      shadowColor: const Color(0xFFB82BEA),
      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 15),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    ),
    child: Text(text),
  );
}
