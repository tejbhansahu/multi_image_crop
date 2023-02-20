import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_crop/src/common/util/constants.dart';
import '../../util/colors.dart';
import '../available_options_container.dart';
import '../icon_button.dart';

class AddText extends StatefulWidget {
  const AddText({Key? key, required this.activeColor, this.initialData})
      : super(key: key);

  final Color activeColor;
  final Map<TextWidget, dynamic>? initialData;

  @override
  State<AddText> createState() => _AddTextState();
}

class _AddTextState extends State<AddText> {
  /// TextFiled decoration color
  BoxType _boxType = BoxType.white;
  TextDirectionValue _textDirectionValue = TextDirectionValue.center;
  TextEditingController textEditingController = TextEditingController();
  FocusNode textFieldNode = FocusNode();
  int selectedColorIndex = 0, selectedFont = 1;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _boxType = widget.initialData![TextWidget.boxType];
      _textDirectionValue = widget.initialData![TextWidget.align];
      textEditingController.text = widget.initialData![TextWidget.text];
      selectedColorIndex = widget.initialData![TextWidget.boxColorIndex];
    }
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    textFieldNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utilityAppBar(),
      backgroundColor: Colors.black26,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: _boxType == BoxType.white
                        ? CustomColors.allColors[selectedColorIndex]
                        : _boxType == BoxType.faintWhite
                            ? CustomColors.allColors[selectedColorIndex]
                                .withOpacity(0.6)
                            : Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                child: IntrinsicWidth(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    autofocus: true,
                    cursorColor: widget.activeColor,
                    buildCounter: buildEmptyCounter,
                    maxLength: 1000,
                    minLines: 1,
                    maxLines: 10,
                    controller: textEditingController,
                    focusNode: textFieldNode,
                    style: TextStyle(
                        color: _boxType == BoxType.transparent ||
                                selectedColorIndex == 1
                            ? Colors.white
                            : Colors.black,
                        fontSize: 40,
                        package: "multi_image_crop",
                        fontFamily: fonts[selectedFont]),
                    textAlign: _textDirectionValue == TextDirectionValue.left
                        ? TextAlign.left
                        : _textDirectionValue == TextDirectionValue.center
                            ? TextAlign.center
                            : TextAlign.right,
                    textAlignVertical: TextAlignVertical.center,
                    onEditingComplete: () {},
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AvailableOptions(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconButton(
                              icon: (_textDirectionValue ==
                                      TextDirectionValue.left
                                  ? CupertinoIcons.text_alignleft
                                  : (_textDirectionValue ==
                                          TextDirectionValue.center
                                      ? CupertinoIcons.text_aligncenter
                                      : CupertinoIcons.text_alignright)),
                              inActiveColor: CustomColors.secondaryColor,
                              activeColor: widget.activeColor,
                              toolTip: 'Text Alignment',
                              margin: const EdgeInsets.only(
                                  left: 10.0,
                                  top: 0.0,
                                  right: 10.0,
                                  bottom: 0.0),
                              isActive: _textDirectionValue !=
                                  TextDirectionValue.center,
                              onTap: () => setState(() {
                                    if (_textDirectionValue ==
                                        TextDirectionValue.left) {
                                      _textDirectionValue =
                                          TextDirectionValue.center;
                                    } else if (_textDirectionValue ==
                                        TextDirectionValue.center) {
                                      _textDirectionValue =
                                          TextDirectionValue.right;
                                    } else if (_textDirectionValue ==
                                        TextDirectionValue.right) {
                                      _textDirectionValue =
                                          TextDirectionValue.left;
                                    }
                                  })),
                          TextButton(
                              onPressed: () {
                                // if (selectedFont < 6) {
                                //   setState(() => selectedFont++);
                                // } else {
                                //   setState(() => selectedFont = 1);
                                // }
                              },
                              child: Text(
                                fonts[selectedFont]!,
                                style: TextStyle(
                                    fontFamily: fonts[selectedFont], color: Colors.white),
                              )),
                          CustomIconButton(
                              icon: (_boxType == BoxType.white
                                  ? CupertinoIcons.chat_bubble_fill
                                  : (_boxType == BoxType.faintWhite
                                      ? CupertinoIcons.chat_bubble_fill
                                      : CupertinoIcons.chat_bubble)),
                              inActiveColor: _boxType == BoxType.faintWhite
                                  ? CustomColors.secondaryColor.withOpacity(0.6)
                                  : CustomColors.secondaryColor,
                              activeColor: widget.activeColor,
                              toolTip: 'Text Alignment',
                              margin: const EdgeInsets.only(
                                  left: 10.0,
                                  top: 0.0,
                                  right: 10.0,
                                  bottom: 0.0),
                              isActive: false,
                              onTap: () => setState(() {
                                    if (_boxType == BoxType.white) {
                                      _boxType = BoxType.faintWhite;
                                    } else if (_boxType == BoxType.faintWhite) {
                                      _boxType = BoxType.transparent;
                                    } else if (_boxType ==
                                        BoxType.transparent) {
                                      _boxType = BoxType.white;
                                    }
                                  })),
                        ],
                      )),
                  Container(
                      height: 20,
                      margin: const EdgeInsets.only(bottom: 30),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ListView.builder(
                          itemCount: CustomColors.allColors.length,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedColorIndex = index),
                              child: Container(
                                height: 18,
                                width: 18,
                                margin: const EdgeInsets.only(left: 18),
                                decoration: BoxDecoration(
                                    color: CustomColors.allColors[index],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: index == 1 &&
                                                selectedColorIndex != 1
                                            ? 0.5
                                            : 1,
                                        color: selectedColorIndex == index ||
                                                index == 1
                                            ? CustomColors.secondaryColor
                                            : CustomColors.primaryColor)),
                                child: selectedColorIndex == index
                                    ? Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.black26,
                                            shape: BoxShape.circle),
                                        child: const Center(
                                          child: Icon(
                                            CupertinoIcons.checkmark,
                                            size: 11,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            );
                          }))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget utilityAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: CustomColors.primaryColor,
      leading: const SizedBox.shrink(),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(
                  context,
                  textEditingController.text.isNotEmpty
                      ? {
                          TextWidget.key: widget.initialData != null
                              ? widget.initialData![TextWidget.key]
                              : ValueKey(Random().nextInt(100)),
                          TextWidget.text: textEditingController.text,
                          TextWidget.textSize:
                              widget.initialData?[TextWidget.textSize] ?? 40.0,
                          TextWidget.align: _textDirectionValue,
                          TextWidget.boxType: _boxType,
                          TextWidget.borderColorStatus: true,
                          TextWidget.boxColorIndex: selectedColorIndex,
                          TextWidget.visibility: true
                        }
                      : null);
            },
            child: const Text(
              'Done',
              style: TextStyle(
                  color: CustomColors.secondaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ))
      ],
    );
  }

  Widget? buildEmptyCounter(BuildContext context,
          {required int currentLength,
          int? maxLength,
          required bool isFocused}) =>
      null;
}
