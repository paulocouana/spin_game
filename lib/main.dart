import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const SpinGameApp());
}

class SpinGameApp extends StatelessWidget {
  const SpinGameApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SpinGameAppHomePage(),
    );
  }
}

class SpinGameAppHomePage extends StatefulWidget {
  const SpinGameAppHomePage({super.key});

  @override
  State<SpinGameAppHomePage> createState() => _SpinGameAppHomePageState();
}

final symbols = ['', '', '', '', '', '⭐', '', '7'];
final reels = [
  [0, 1, 2, 1, 0],
  [2, 1, 0, 1, 2],
  [1, 2, 1, 2, 1],
];

class _SpinGameAppHomePageState extends State<SpinGameAppHomePage> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late List<List<int>> _currentReels = reels; // Track current reel positions
  String _winningNumber = ''; // Track winning number

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Adjust spinning duration
    );
  }

  void spin() {
    _controller.forward(from: 0).whenComplete(() {
      setState(() {
        _currentReels = List.generate(reels.length, (index) => reels[index]..shuffle());
        _winningNumber = determineWinningNumber(); // Calculate winning number
      });
    });
  }

  String determineWinningNumber() {
    // Implementation of the logic to determine the winning number based on the final reel positions
    final centerSymbols = _currentReels.map((reel) => reel[2]).toList();
    final winningSymbol = centerSymbols[1]; // Assuming middle reel is the winning symbol
    return symbols[winningSymbol];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lucky Spin')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            reel(0),
            SizedBox(height: 30),
            reel(1),
            SizedBox(height: 30),
            reel(2),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: spin,
              child: Text('Spin'),
            ),
            SizedBox(height: 30),
            Text(
              'Winning Number: $_winningNumber', // Display winning number
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget reel(int index) {
  return AnimatedBuilder(
    animation: _controller,
    builder: (context, child) {
      final rotation = _controller.value * 4 * pi; // Spin multiple times
      return Transform.rotate(
        angle: rotation,
        child: child,
      );
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.circle,
          size: 50,
          color: Colors.grey,
        ),
        for (int i = 0; i < 3; i++)
        Icon(
          // Use a ternary operator to conditionally create IconData
          symbols[reels[index][i]] == ''
              ? Icons.circle  // Use a placeholder for empty symbols
              : IconData(symbols[reels[index][i]] as int, fontFamily: 'MaterialIcons-Regular'),
          size: 80,
        ),
        Icon(
          Icons.circle,
          size: 50,
          color: Colors.grey,
        )
      ],
    ),);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}