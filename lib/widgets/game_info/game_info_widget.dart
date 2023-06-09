import 'package:flutter/material.dart';
import 'package:flutter_sudoku/utils/app_text_styles.dart';

class GameInfoWidget extends StatelessWidget {
  const GameInfoWidget({
    required this.title,
    required this.value,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.forPopup = false,
    super.key,
  });

  final String title;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;
  final bool forPopup;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            title,
            style: forPopup
                ? AppTextStyles.popupInfoTitle
                : AppTextStyles.gameInfoTitle,
          ),
          SizedBox(height: forPopup ? 8 : 4),
          Text(
            value,
            style: forPopup
                ? AppTextStyles.popupInfoValue
                : AppTextStyles.gameInfoTitle,
          ),
        ],
      ),
    );
  }
}
