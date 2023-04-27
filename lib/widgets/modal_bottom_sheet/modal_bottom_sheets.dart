import 'package:flutter/material.dart';
import 'package:flutter_sudoku/models/option_button_model.dart';
import 'package:flutter_sudoku/services/navigation_service.dart';
import 'package:flutter_sudoku/utils/app_colors.dart';
import 'package:flutter_sudoku/widgets/widget_divider.dart';

class ModalBottomSheets {
  static Future<dynamic> showOptions({
    required List<OptionButtonModel> options,
  }) {
    const double radius = 28;
    const double leadingWidth = 72;

    final bool leading = options.any((element) => element.selected);

    return showModalBottomSheet(
      context: NavigationService.navigatorKey.currentContext!,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: WidgetDivider(
            leftPadding: leading ? leadingWidth - 3 : 0,
            children: List.generate(
              options.length,
              (index) {
                final OptionButtonModel optionButton = options[index];

                BorderRadius borderRadius = BorderRadius.zero;
                if (index == 0) {
                  borderRadius = const BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    topRight: Radius.circular(radius),
                  );
                } else if (index == options.length - 1) {
                  borderRadius = const BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                  );
                }

                return Material(
                  borderRadius: BorderRadius.circular(28),
                  child: InkWell(
                    highlightColor: AppColors.whiteButtonForeground,
                    onTap: () {
                      Navigator.pop(context, optionButton.onTap);
                    },
                    borderRadius: borderRadius,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        children: [
                          if (leading) ...[
                            SizedBox(
                              width: leadingWidth,
                              child: Center(
                                child: Icon(Icons.done,
                                    color: AppColors.roundedButton),
                              ),
                            ),
                          ],
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: leading
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.center,
                              children: [
                                Text(
                                  optionButton.title,
                                  style: TextStyle(
                                      color: AppColors.roundedButton,
                                      fontSize: 20.toDouble(),
                                      fontWeight: FontWeight.w400),
                                ),
                                if (optionButton.subTitle != null) ...[
                                  Text(
                                    optionButton.title,
                                    style: TextStyle(
                                        color: AppColors.roundedButton,
                                        fontSize: 20.toDouble(),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
