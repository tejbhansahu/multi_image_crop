import 'package:flutter/material.dart';
import 'package:multi_image_crop/src/common/util/constants.dart';

Widget swapToFilter(
    {required String title,
    required DirectionAxis direction,
    required double width,
    double? height,
    required VoidCallback onTrigger}) {
  return Visibility(
    child: GestureDetector(
      onPanUpdate: (details) {
        int sensitivity = 8;

        if (details.delta.dy > sensitivity) {
          // Down Swipe
          if (direction == DirectionAxis.yNan) {
            onTrigger();
          }
        } else if (details.delta.dy < -sensitivity) {
          // Up Swipe
          if (direction == DirectionAxis.y) {
            onTrigger();
          }
        }
        // Swiping in right direction.
        if (details.delta.dx > 0) {
          if (direction == DirectionAxis.x) {
            onTrigger();
          }
        }
        // Swiping in left direction.
        if (details.delta.dx < 0) {
          if (direction == DirectionAxis.xNan) {
            onTrigger();
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.transparent,
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: direction == DirectionAxis.y,
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: direction == DirectionAxis.xNan,
                  child: const Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      spreadRadius: 15,
                    )
                  ]),
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Visibility(
                  visible: direction == DirectionAxis.x,
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: direction == DirectionAxis.yNan,
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
