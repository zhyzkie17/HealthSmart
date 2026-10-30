import 'package:flutter/material.dart';
import '../../screens/ai_assistant_screen.dart';

class AIFloatingButton extends StatefulWidget {
  final double contentWidth;
  final double contentHeight;

  const AIFloatingButton({
    super.key,
    required this.contentWidth,
    required this.contentHeight,
  });

  @override
  State<AIFloatingButton> createState() => _AIFloatingButtonState();
}

class _AIFloatingButtonState extends State<AIFloatingButton> {
  Offset position = const Offset(20, 100);

  static const double buttonSize = 56;
  static const double margin = 10;
  static const double visiblePart = 18;

  @override
  Widget build(BuildContext context) {

    final double normalMaxX =
        widget.contentWidth - buttonSize - margin;

    final double maxY =
        widget.contentHeight - buttonSize - margin;

    final double hiddenLeft =
        -(buttonSize - visiblePart);

    final double hiddenRight =
        widget.contentWidth - visiblePart;

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            double newX =
                position.dx + details.delta.dx;

            double newY =
                position.dy + details.delta.dy;

            newX = newX.clamp(
              hiddenLeft,
              hiddenRight,
            );

            newY = newY.clamp(
              margin,
              maxY,
            );

            position = Offset(
              newX,
              newY,
            );
          });
        },

        onPanEnd: (details) {
          final double center =
              widget.contentWidth / 2;

          setState(() {
            if (position.dx < 0) {
              position = Offset(
                hiddenLeft,
                position.dy,
              );
            } else if (position.dx > normalMaxX) {
              position = Offset(
                hiddenRight,
                position.dy,
              );
            } else {
              position = Offset(
                position.dx < center
                    ? margin
                    : normalMaxX,
                position.dy,
              );
            }
          });
        },

        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const AIAssistantScreen(),
              ),
            );
          },
          child: const Icon(Icons.smart_toy),
        ),
      ),
    );
  }
}
