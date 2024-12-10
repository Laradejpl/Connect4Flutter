// main.dart
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:math';  // Ajout de l'import pour min()

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puissance 4',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late IO.Socket socket;
  List<List<int>> board = List.generate(6, (_) => List.filled(7, 0));
  bool isMyTurn = false;
  int myColor = 1; // 1 pour rouge, 2 pour jaune
  bool gameStarted = false;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    
    socket.on('connect', (_) {
      print('Connected to server');
    });

    socket.on('game_start', (data) {
      setState(() {
        gameStarted = true;
        myColor = data['player'];
        isMyTurn = data['player'] == 1;
      });
    });

    socket.on('move', (data) {
      setState(() {
        board[data['row']][data['col']] = data['player'];
        isMyTurn = data['nextPlayer'] == myColor;
      });
      
      if (checkWin(data['row'], data['col'], data['player'])) {
        showGameOverDialog(data['player']);
      }
    });
  }

  void makeMove(int col) {
    if (!isMyTurn || !gameStarted) return;

    int row = getLowestEmptyRow(col);
    if (row == -1) return;

    socket.emit('make_move', {
      'col': col,
      'player': myColor,
    });
  }

  int getLowestEmptyRow(int col) {
    for (int row = 5; row >= 0; row--) {
      if (board[row][col] == 0) return row;
    }
    return -1;
  }

  bool checkWin(int row, int col, int player) {
    // Vérification horizontale
    int count = 0;
    for (int c = 0; c < 7; c++) {
      if (board[row][c] == player) {
        count++;
        if (count == 4) return true;
      } else {
        count = 0;
      }
    }

    // Vérification verticale
    count = 0;
    for (int r = 0; r < 6; r++) {
      if (board[r][col] == player) {
        count++;
        if (count == 4) return true;
      } else {
        count = 0;
      }
    }

    // Vérification diagonale descendante
    count = 0;
    int startRow = row - min(row, col);  // Modifié ici
    int startCol = col - min(row, col);  // Modifié ici
    while (startRow < 6 && startCol < 7) {
      if (board[startRow][startCol] == player) {
        count++;
        if (count == 4) return true;
      } else {
        count = 0;
      }
      startRow++;
      startCol++;
    }

    // Vérification diagonale montante
    count = 0;
    startRow = row + min(5 - row, col);  // Modifié ici
    startCol = col - min(5 - row, col);  // Modifié ici
    while (startRow >= 0 && startCol < 7) {
      if (board[startRow][startCol] == player) {
        count++;
        if (count == 4) return true;
      } else {
        count = 0;
      }
      startRow--;
      startCol++;
    }

    return false;
  }

  void showGameOverDialog(int winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Partie terminée !'),
        content: Text(winner == myColor ? 'Vous avez gagné !' : 'Vous avez perdu !'),
        actions: [
          TextButton(
            child: const Text('Nouvelle partie'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                board = List.generate(6, (_) => List.filled(7, 0));
                gameStarted = false;
              });
              socket.emit('new_game');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puissance 4'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              gameStarted 
                ? (isMyTurn ? 'À votre tour' : "Au tour de l'adversaire")
                : 'En attente d\'un autre joueur...',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(10),
                
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemCount: 42,
                itemBuilder: (context, index) {
                  int row = index ~/ 7;
                  int col = index % 7;
                  return GestureDetector(
                    onTap: () => makeMove(col),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: board[row][col] == 0
                            ? Colors.white
                            : board[row][col] == 1
                                ? Colors.red
                                : Colors.yellow,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }
}