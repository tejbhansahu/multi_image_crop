import 'package:flutter/material.dart';
import '../util/colors.dart';

class AvailableOptions extends StatelessWidget {
  const AvailableOptions(
      {Key? key,
      required this.child,
      required this.onTap,
      this.padding = EdgeInsets.zero})
      : super(key: key);

  final Widget child;
  final VoidCallback onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: padding,
        decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border:
                Border.all(width: 1, color: CustomColors.primaryColorLight)),
        child: child,
      ),
    );
  }
}
