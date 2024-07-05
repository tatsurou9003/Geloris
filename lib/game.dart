import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'block.dart';
import 'dart:async';
import 'dart:math';

class TetrisGame extends StatefulWidget {
  @override
  _TetrisGameState createState() => _TetrisGameState();
}

class _TetrisGameState extends State<TetrisGame> {
  final int rows = 20;
  final int columns = 10;
  late List<List<Color>> grid;
  late Block currentBlock;
  late Timer timer;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    grid = List.generate(
        rows,
        (i) => List.generate(
              columns,
              (j) => Color.fromARGB(255, 237, 233, 116),
            ));
    spawnBlock();
    startGame();
  }

  void spawnBlock() {
    setState(() {
      currentBlock = blocks[random.nextInt(blocks.length)];
      currentBlock.y = 0;
      currentBlock.x = (columns / 2 - 1).toInt();
    });
  }

  void startGame() {
    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        moveBlockDown();
      });
    });
  }

  void moveBlockDown() {
    setState(() {
      if (checkCollision(currentBlock, currentBlock.x, currentBlock.y + 1)) {
        mergeBlockToGrid();
        checkForFullRows();
        spawnBlock();
        if (checkCollision(currentBlock, currentBlock.x, currentBlock.y)) {
          timer.cancel();
          // ゲームオーバー処理
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Game Over'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        grid = List.generate(
                            rows,
                            (i) => List.generate(columns,
                                (j) => Color.fromARGB(255, 237, 233, 116)));
                        spawnBlock();
                        startGame();
                      });
                    },
                    child: Text('Restart'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        currentBlock.y += 1;
      }
    });
  }

  void moveBlockHorizontally(int direction) {
    int newX = currentBlock.x + direction;
    if (!checkCollision(currentBlock, newX, currentBlock.y)) {
      setState(() {
        currentBlock.x = newX;
      });
    }
  }

  void rotateBlock() {
    setState(() {
      currentBlock.rotate();
      if (checkCollision(currentBlock, currentBlock.x, currentBlock.y)) {
        currentBlock.undoRotate();
      }
    });
  }

  bool checkCollision(Block block, int newX, int newY) {
    for (int i = 0; i < block.currentShape.length; i++) {
      for (int j = 0; j < block.currentShape[i].length; j++) {
        if (block.currentShape[i][j] == 1) {
          int newBlockX = newX + j;
          int newBlockY = newY + i;

          if (newBlockX < 0 ||
              newBlockX >= columns ||
              newBlockY >= rows ||
              (newBlockY >= 0 &&
                  grid[newBlockY][newBlockX] !=
                      Color.fromARGB(255, 237, 233, 116))) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void mergeBlockToGrid() {
    for (int i = 0; i < currentBlock.currentShape.length; i++) {
      for (int j = 0; j < currentBlock.currentShape[i].length; j++) {
        if (currentBlock.currentShape[i][j] == 1) {
          int gridX = currentBlock.x + j;
          int gridY = currentBlock.y + i;
          if (gridY >= 0 && gridY < rows && gridX >= 0 && gridX < columns) {
            grid[gridY][gridX] = currentBlock.currentColors[i][j];
          }
        }
      }
    }
  }

  void checkForFullRows() {
    setState(() {
      for (int y = rows - 1; y >= 0; y--) {
        bool fullRow = true;
        for (int x = 0; x < columns; x++) {
          if (grid[y][x] == Color.fromARGB(255, 237, 233, 116)) {
            fullRow = false;
            break;
          }
        }
        if (fullRow) {
          for (int row = y; row > 0; row--) {
            for (int col = 0; col < columns; col++) {
              grid[row][col] = grid[row - 1][col];
            }
          }
          for (int col = 0; col < columns; col++) {
            grid[0][col] = Color.fromARGB(255, 237, 233, 116);
          }
          y++; // 同じ行を再チェックする
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 140, 108, 4),
      appBar: AppBar(
        title: Text('Geloris'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < rows; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int j = 0; j < columns; j++)
                          Container(
                            width: 28,
                            height: 28,
                            color: getColor(i, j),
                            margin: EdgeInsets.all(1),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => moveBlockHorizontally(-1),
                  child: Icon(Icons.arrow_left),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => moveBlockDown(),
                  child: Icon(Icons.arrow_drop_down),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => moveBlockHorizontally(1),
                  child: Icon(Icons.arrow_right),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => rotateBlock(),
                  child: Icon(Icons.rotate_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color getColor(int row, int col) {
    for (int i = 0; i < currentBlock.currentShape.length; i++) {
      for (int j = 0; j < currentBlock.currentShape[i].length; j++) {
        if (currentBlock.currentShape[i][j] == 1) {
          if (row == currentBlock.y + i && col == currentBlock.x + j) {
            return currentBlock.currentColors[i][j];
          }
        }
      }
    }
    return grid[row][col];
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
