import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sudoku/utils/app_strings.dart';
import 'package:flutter_sudoku/constant/enums.dart';
import 'package:flutter_sudoku/models/cell_model.dart';
import 'package:flutter_sudoku/models/game_model.dart';
import 'package:flutter_sudoku/screens/game_screen/game_screen_provider.dart';
import 'package:flutter_sudoku/utils/app_colors.dart';
import 'package:flutter_sudoku/utils/extensions.dart';
import 'package:flutter_sudoku/utils/app_text_styles.dart';
import 'package:flutter_sudoku/utils/utils.dart';
import 'package:flutter_sudoku/widgets/button/action_button/action_button.dart';
import 'package:flutter_sudoku/widgets/button/action_button/action_icon.dart';
import 'package:flutter_sudoku/widgets/button/action_button/hints_amount_circle.dart';
import 'package:flutter_sudoku/widgets/button/action_button/note_switch_widget.dart';
import 'package:flutter_sudoku/widgets/app_bar_action_button.dart';
import 'package:flutter_sudoku/widgets/game_info/game_info_widget.dart';
import 'package:flutter_sudoku/widgets/game_info/pause_button.dart';
import 'package:flutter_sudoku/widgets/sudoku_board/horizontal_lines.dart';
import 'package:flutter_sudoku/widgets/sudoku_board/vertical_lines.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({required this.gameModel, super.key});
  final GameModel gameModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameScreenProvider>(
      create: (context) => GameScreenProvider(gameModel: gameModel),
      child: Consumer<GameScreenProvider>(builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: GameAppBar(
            onBackPressed: provider.onBackPressed,
            onSettingsPressed: provider.onSettingsPressed,
          ),
          body: Column(
            children: [
              GameInfo(provider: provider),
              SudokuBoard(provider: provider),
              const Spacer(),
              ActionButtons(provider: provider),
              const Spacer(),
              NumberButtons(provider: provider),
              const Spacer(flex: 1),
            ],
          ),
        );
      }),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    required this.provider,
    super.key,
  });

  final GameScreenProvider provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionButton(
            title: AppStrings.undo,
            iconWidget: const ActionIcon(Icons.refresh),
            onTap: () => provider.undoOnTap(),
          ),
          ActionButton(
            title: AppStrings.erase,
            iconWidget: const ActionIcon(Icons.delete),
            onTap: () => provider.eraseOnTap(),
          ),
          ActionButton(
            title: AppStrings.notes,
            iconWidget: Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: [
                  const ActionIcon(
                    Icons.drive_file_rename_outline_outlined,
                    rightPadding: 16,
                  ),
                  NotesSwitchWidget(notesOn: provider.notesMode),
                ],
              ),
            ),
            onTap: () => provider.notesOnTap(),
          ),
          ActionButton(
            title: AppStrings.hint,
            iconWidget: Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: [
                  const ActionIcon(Icons.lightbulb_outlined, rightPadding: 12),
                  HintsAmountCircle(hints: provider.hints),
                ],
              ),
            ),
            onTap: () => provider.hintsOnTap(),
          ),
        ],
      ),
    );
  }
}

class NumberButtons extends StatelessWidget {
  const NumberButtons({
    required this.provider,
    super.key,
  });

  final GameScreenProvider provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(9, (index) {
          final bool showButton = provider.isNumberButtonNecessary(index + 1);

          return Opacity(
            opacity: showButton ? 1 : 0,
            child: InkWell(
              onTap: showButton
                  ? () => provider.numberButtonOnTap(index + 1)
                  : null,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                child: Text(
                  (index + 1).toString(),
                  style: provider.notesMode
                      ? AppTextStyles.noteButton
                      : AppTextStyles.numberButton,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class SudokuBoard extends StatelessWidget {
  const SudokuBoard({
    required this.provider,
    super.key,
  });

  final GameScreenProvider provider;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double borderWidth = 2;
    double cellBorderWidth = 1.5;

    return Container(
      width: double.infinity,
      height: screenWidth - 12,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(width: borderWidth),
      ),
      child: Stack(
        children: [
          VerticalLines(
            borderWidth: borderWidth,
            borderColor: AppColors.boardBorder,
          ),
          HorizontalLines(
            borderWidth: borderWidth,
            borderColor: AppColors.boardBorder,
          ),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: borderWidth,
              crossAxisSpacing: borderWidth,
            ),
            itemCount: 9,
            itemBuilder: (context, boxIndex) {
              return Stack(
                children: [
                  VerticalLines(
                    borderWidth: cellBorderWidth,
                    borderColor: AppColors.cellBorder,
                  ),
                  HorizontalLines(
                    borderWidth: cellBorderWidth,
                    borderColor: AppColors.cellBorder,
                  ),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: cellBorderWidth,
                      crossAxisSpacing: cellBorderWidth,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, boxCellIndex) {
                      CellModel cell = provider.sudokuBoard
                          .getCellByBoxIndex(boxIndex, boxCellIndex);

                      return CellWidget(
                        provider: provider,
                        cell: cell,
                        child: (() {
                          if (provider.gamePaused) {
                            return null;
                          } else {
                            if (cell.hasValue) {
                              return CellValueText(cell: cell);
                            } else {
                              return CellNotesGrid(
                                cell: cell,
                                selectedCell: provider.selectedCell,
                              );
                            }
                          }
                        }()),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class CellWidget extends StatelessWidget {
  const CellWidget({
    super.key,
    required this.provider,
    required this.cell,
    required this.child,
  });

  final GameScreenProvider provider;
  final CellModel cell;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => provider.cellOnTap(cell),
      child: Container(
        padding: const EdgeInsets.all(2),
        color: getCellColor(
          cell: cell,
          selectedCell: provider.selectedCell,
          hideCells: provider.gamePaused,
        ),
        child: child,
      ),
    );
  }
}

class CellNotesGrid extends StatelessWidget {
  const CellNotesGrid({
    required this.cell,
    required this.selectedCell,
    super.key,
  });

  final CellModel cell;
  final CellModel selectedCell;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        padding: const EdgeInsets.all(1.5),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        itemBuilder: (_, i) {
          final int number = i + 1;
          if (cell.notesContains(number)) {
            return FittedBox(
              child: Center(
                child: Text(
                  number.toString(),
                  style: number == selectedCell.value
                      ? AppTextStyles.highlightedNoteNumber
                      : AppTextStyles.noteNumber,
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}

class CellValueText extends StatelessWidget {
  const CellValueText({
    required this.cell,
    super.key,
  });

  final CellModel cell;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Center(
        child: Text(
          cell.print(),
          style: getStyle(cell),
        ),
      ),
    );
  }
}

class GameInfo extends StatelessWidget {
  const GameInfo({
    required this.provider,
    super.key,
  });

  final GameScreenProvider provider;

  @override
  Widget build(BuildContext context) {
    final Difficulty difficulty = provider.difficulty;
    final int mistakes = provider.mistakes;
    final int score = provider.score;
    final int time = provider.time;

    final bool isPaused = provider.gamePaused;
    final Function() pauseGame = provider.pauseButtonOnTap;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GameInfoWidget(
                  value: difficulty.name,
                  title: AppStrings.difficulty,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                GameInfoWidget(
                  value: '$mistakes/3',
                  title: AppStrings.mistakes,
                ),
                GameInfoWidget(
                  value: '$score',
                  title: AppStrings.score,
                ),
                GameInfoWidget(
                  value: time.toTimeString(),
                  title: AppStrings.time,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          PauseButton(isPaused: isPaused, onPressed: pauseGame),
        ],
      ),
    );
  }
}

class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GameAppBar({
    required this.onBackPressed,
    required this.onSettingsPressed,
    super.key,
  });

  final Function() onBackPressed;
  final Function() onSettingsPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarBackground,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: true,
      elevation: 0,
      title: Text(
        AppStrings.appBarTitle,
        style: AppTextStyles.appBarTitle,
      ),
      leading: AppBarActionButton(
        icon: Icons.arrow_back_ios_new,
        onPressed: onBackPressed,
      ),
      actions: [
        AppBarActionButton(
          icon: Icons.palette_outlined,
          onPressed: () {},
        ),
        AppBarActionButton(
          icon: Icons.settings_outlined,
          onPressed: onSettingsPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
