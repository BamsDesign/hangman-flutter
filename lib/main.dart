import 'package:flutter/material.dart';

void main() {
  runApp(const HangmanApp());
}

class HangmanApp extends StatelessWidget {
  const HangmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HangmanGame(),
    );
  }
}

class HangmanGame extends StatefulWidget {
  const HangmanGame({super.key});

  @override
  State<HangmanGame> createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  final int _maxTries = 5;
  int _remainingTries = 5;

  String _word = '';
  String _hint = '';
  List<String> _guessedLetters = [];

  bool _gameOver = false;
  bool _won = false;

  final List<Map<String, String>> _words = [
    {'word': 'BONJOU', 'hint': 'Se yon mo ki itilize pou salye moun'},
    {'word': 'REJWE', 'hint': 'Eksprime kontantman'},
    {'word': 'ED', 'hint': 'Asistans'},
    {'word': 'KITE', 'hint': 'Ale oswa pèmèt'},
    {'word': 'LAVI', 'hint': 'Sa ki fè yon moun egziste'},
    {'word': 'MANJE', 'hint': 'Aksyon pou pran nouriti'},
  ];

  final List<String> _keyboard = [
    'Q','W','E','R','T','Y','U','I','O','P',
    'A','S','D','F','G','H','J','K','L',
    'Z','X','C','V','B','N','M'
  ];

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _newGame() {
    final random = DateTime.now().millisecondsSinceEpoch % _words.length;
    setState(() {
      _word = _words[random]['word']!;
      _hint = _words[random]['hint']!;
      _remainingTries = _maxTries;
      _guessedLetters.clear();
      _gameOver = false;
      _won = false;
    });
  }

  void _guess(String letter) {
    if (_gameOver || _guessedLetters.contains(letter)) return;

    setState(() {
      _guessedLetters.add(letter);

      if (!_word.contains(letter)) {
        _remainingTries--;
      }

      if (_remainingTries == 0) {
        _gameOver = true;
        _won = false;
      }

      if (_checkWin()) {
        _gameOver = true;
        _won = true;
      }
    });
  }

  bool _checkWin() {
    for (var c in _word.split('')) {
      if (!_guessedLetters.contains(c)) return false;
    }
    return true;
  }

  String _displayWord() {
    return _word
        .split('')
        .map((c) => _guessedLetters.contains(c) ? c : '_')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    if (_gameOver) {
      return _buildResultScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hangman'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 6),
                Text(
                  '$_remainingTries',
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Hangman',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              _hint,
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 30),

            Text(
              _displayWord(),
              style: const TextStyle(
                fontSize: 36,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Expanded(child: _buildKeyboard()),

            ElevatedButton.icon(
              onPressed: _newGame,
              icon: const Icon(Icons.refresh),
              label: const Text('Rejwe'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    return GridView.builder(
      itemCount: _keyboard.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        final letter = _keyboard[index];
        final used = _guessedLetters.contains(letter);

        return ElevatedButton(
          onPressed: used ? null : () => _guess(letter),
          child: Text(letter),
        );
      },
    );
  }

  Widget _buildResultScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _won ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 100,
              color: _won ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              _won ? 'GENYEN!' : 'PÈDI!',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Mo a se: $_word',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _newGame,
              child: const Text('Rejwe'),
            ),
          ],
        ),
      ),
    );
  }
}
