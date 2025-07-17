import 'package:flutter/material.dart';

class GameCard {
  String id;
  String title;
  bool isopened;

  GameCard({
    required this.id,
    required this.title,
    this.isopened = true,
  });
}

final List<GameCard> originalCards = [
  GameCard(id: 'c1', title: 'assets/images/book.png'),
  GameCard(id: 'c2', title: 'assets/images/book.png'),
  GameCard(id: 'c3', title: 'assets/images/ginaika.jpg'),
  GameCard(id: 'c4', title: 'assets/images/ginaika.jpg'),
  GameCard(id: 'c5', title: 'assets/images/mobile.jpg'),
  GameCard(id: 'c6', title: 'assets/images/mobile.jpg'),
  GameCard(id: 'c7', title: 'assets/images/news.png'),
  GameCard(id: 'c8', title: 'assets/images/news.png'),
];

List<GameCard> getShuffledCards() {
  final shuffled = originalCards
      .map((card) => GameCard(id: card.id, title: 'assets/images/back.png'))
      .toList();
  shuffled.shuffle();
  return shuffled;
}

class Player {
  String name;
  int wins;

  Player({
    required this.name,
    this.wins = 0,
  });
}
