import 'package:flutter/material.dart';
import 'dart:math';

class Block {
  List<List<List<int>>> shape;
  late List<List<List<Color>>> colors; // 修正：List<List<List<Color>>>に変更
  int rotationIndex;
  int x, y;

  Block(this.shape, {this.rotationIndex = 0, this.x = 3, this.y = 0}) {
    colors = [];
    for (var rotation in shape) {
      List<List<Color>> rotationColors = [];
      for (var row in rotation) {
        List<Color> rowColors = [];
        for (var cell in row) {
          rowColors.add(cell == 1 ? _getRandomColor() : Colors.transparent);
        }
        rotationColors.add(rowColors);
      }
      colors.add(rotationColors);
    }
  }

  List<List<int>> get currentShape => shape[rotationIndex];
  List<List<Color>> get currentColors =>
      colors[rotationIndex]; // 修正：List<List<Color>>を返す

  void rotate() {
    rotationIndex = (rotationIndex + 1) % shape.length;
  }

  void undoRotate() {
    rotationIndex = (rotationIndex - 1 + shape.length) % shape.length;
  }

  Color _getRandomColor() {
    List<Color> colorOptions = [
      const Color.fromARGB(255, 167, 119, 102),
      Color.fromARGB(255, 203, 164, 22),
      Color.fromARGB(255, 190, 180, 38),
    ];
    return colorOptions[Random().nextInt(colorOptions.length)];
  }
}

final List<Block> blocks = [
  Block([
    [
      [1, 1, 1, 1],
    ],
    [
      [1],
      [1],
      [1],
      [1],
    ],
  ]), // I形

  Block([
    [
      [1, 1, 0],
      [0, 1, 1],
    ],
    [
      [0, 1],
      [1, 1],
      [1, 0],
    ],
  ]), // Z形

  Block([
    [
      [0, 1, 1],
      [1, 1, 0],
    ],
    [
      [1, 0],
      [1, 1],
      [0, 1],
    ],
  ]), // S形

  Block([
    [
      [1, 1],
      [1, 1],
    ],
  ]), // O形

  Block([
    [
      [1, 1, 1],
      [0, 1, 0],
    ],
    [
      [1, 0],
      [1, 1],
      [1, 0],
    ],
    [
      [0, 1, 0],
      [1, 1, 1],
    ],
    [
      [0, 1],
      [1, 1],
      [0, 1],
    ],
  ]), // T形

  Block([
    [
      [1, 1, 1],
      [1, 0, 0],
    ],
    [
      [1, 1],
      [0, 1],
      [0, 1],
    ],
    [
      [0, 0, 1],
      [1, 1, 1],
    ],
    [
      [1, 0],
      [1, 0],
      [1, 1],
    ],
  ]), // L形

  Block([
    [
      [1, 1, 1],
      [0, 0, 1],
    ],
    [
      [0, 1],
      [0, 1],
      [1, 1],
    ],
    [
      [1, 0, 0],
      [1, 1, 1],
    ],
    [
      [1, 1],
      [1, 0],
      [1, 0],
    ],
  ]), // J形
];
