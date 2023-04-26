import 'package:flutter_sudoku/models/cell_position_model.dart';

class CellModel {
  int value;
  int realValue;
  bool isGivenNumber;
  bool isHighlighted;
  List<int> notes;
  final CellPositionModel position;

  CellModel({
    this.value = 0,
    required this.realValue,
    required this.position,
    this.isGivenNumber = false,
    this.isHighlighted = false,
    required this.notes,
  });

  bool get hasValue => value != 0;

  bool get hasRealValue => realValue != 0;

  bool get isValueCorrect => hasValue && value == realValue;

  bool get hasNotes => notes.isNotEmpty;

  bool hasIntersectionWith(CellPositionModel cellPosition) =>
      position.x == cellPosition.x ||
      position.y == cellPosition.y ||
      position.boxIndex == cellPosition.boxIndex;

  bool notesContains(int number) => notes.contains(number);

  List<String> stringNotes() => List<String>.from(notes);

  String print() => isGivenNumber
      ? realValue.toString()
      : hasValue
          ? value.toString()
          : ' ';
}
