import 'package:flutter/material.dart';
import 'package:quiz/models/card.dart';


void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Grid',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const QuizScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<GameCard> shuffledCards;
  List<int> selectedIndex = [];

  late Player jim;
  late Player tom;
  bool isOnFire = true;
  bool isactive=true;
bool get allCardsRevealed => shuffledCards.every((card) => card.title != 'assets/images/back.png');

  Player playerPlays() => isOnFire ? jim : tom;

  @override
  void initState() {
    super.initState();
    shuffledCards = getShuffledCards();
    jim = Player(name: 'Jimmi');
    tom = Player(name: 'Tom');
  }
  
 
void endGame() async {
  Player theWinner;
  if (jim.wins > tom.wins) {
    theWinner = jim;
  } else if (tom.wins > jim.wins) {
    theWinner = tom;
  } else {
    theWinner = Player(name: 'Κανείς (ισοπαλία)');
  }

  // Δείξε μήνυμα για τον νικητή (προαιρετικό)
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Έχουμε νικητή τον ${theWinner.name}!'),
      duration: const Duration(seconds: 2),
    ),
  );

  await Future.delayed(const Duration(seconds: 2));

  setState(() {
    // Μηδενισμός σκορ
    jim.wins = 0;
    tom.wins = 0;

    // Reset καρτών (με back face)
    for (int i = 0; i < shuffledCards.length; i++) {
      shuffledCards[i].title = 'assets/images/back.png';
    }

    // Reset σειράς και επιλογών
    isOnFire = true;
    selectedIndex.clear();

    // Μπορείς και να ξανα-ανακατέψεις τις κάρτες αν θες:
    shuffledCards.shuffle();
  });
}

  void openCard(int index) {
    setState(() {
      final original = originalCards.firstWhere(
          (c) => c.id == shuffledCards[index].id,
          orElse: () => GameCard(id: '', title: ''));
      shuffledCards[index].title = original.title;
    });
  }

  Future<void> playGame(int index) async {
    if (selectedIndex.length >= 2 ||
        shuffledCards[index].title != 'assets/images/back.png') return;

    setState(() {
      openCard(index);
     
      selectedIndex.add(index);
    });

    if (selectedIndex.length == 2) {
      final first = shuffledCards[selectedIndex[0]];
      final second = shuffledCards[selectedIndex[1]];

      if (first.title != second.title) {
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          for (final i in selectedIndex) {
            shuffledCards[i].title = 'assets/images/back.png';
          }
          selectedIndex.clear();
          isOnFire = !isOnFire;
        });
      } else {
        setState(() {
          playerPlays().wins += 1;
          selectedIndex.clear();
          isOnFire = !isOnFire;
        });
      }if (allCardsRevealed) {
  await Future.delayed(const Duration(seconds: 2));
  endGame();
      }
  }}
Player? get theWinner {
  if (!allCardsRevealed) return null;

  if (jim.wins > tom.wins) return jim;
  if (tom.wins > jim.wins) return tom;
  return Player(name: 'Κανείς (ισοπαλία)');
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card Grid')),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 10 / 9,
                crossAxisSpacing: 40,
                mainAxisSpacing: 40,
              ),
              itemCount: shuffledCards.length,
              itemBuilder: (context, index) {
                final card = shuffledCards[index];
                return InkWell(
                  onTap: () => playGame(index),
                  child: Container(
                    color: Colors.black,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        card.title,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
  flex: 1,
  child: allCardsRevealed
      ? Text(
          'Έχουμε νικητή τον ${theWinner?.name}',
          style: const TextStyle(fontSize: 22),
          textAlign: TextAlign.center,
        )
      : Text(
          '${jim.name}: ${jim.wins} wins   |   ${tom.name}: ${tom.wins} wins\nCurrent: ${playerPlays().name}',
          style: const TextStyle(fontSize: 22),
          textAlign: TextAlign.center,
        ),
),

        ],
      ),
    );
  }
}
  