import 'package:flutter/material.dart';
import '../util/colors.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {Key? key,
      required this.icon,
      required this.inActiveColor,
      required this.activeColor,
      this.toolTip = '',
      this.labelText = '',
      required this.isActive,
      this.margin = EdgeInsets.zero,
      required this.onTap})
      : super(key: key);

  final IconData icon;
  final Color inActiveColor, activeColor;
  final String toolTip, labelText;
  final bool isActive;
  final EdgeInsets margin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: toolTip,
      child: InkWell(
        onTap: () => onTap(),
        highlightColor: CustomColors.primaryColor,
        splashColor: CustomColors.primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 40,
                width: 40,
                margin: margin,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Icon(
                  icon,
                  color: isActive ? activeColor : inActiveColor,
                )),
            Visibility(
              visible: labelText.isNotEmpty,
              child: Padding(
                padding: labelText.isNotEmpty
                    ? const EdgeInsets.only(bottom: 5)
                    : EdgeInsets.zero,
                child: Text(
                  labelText,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
