import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:multi_image_crop/src/common/widgets/available_options_container.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'common/util/colors.dart';
import 'common/util/constants.dart';
import 'dart:math' as math;
import 'common/widgets/swiping_ui.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class FilterImage extends StatefulWidget {
  const FilterImage(
      {Key? key,
      required this.image,
      required this.onFiltered,
      this.activeColor,
      this.pixelRatio})
      : super(key: key);

  final File image;
  final double? pixelRatio;
  final Function onFiltered;
  final Color? activeColor;

  @override
  State<FilterImage> createState() => _FilterImageState();
}

class _FilterImageState extends State<FilterImage> {
  final GlobalKey _globalKey = GlobalKey();
  int selectedFilter = 0, selectedFont = 1;
  ByteData? selectedByteData;
  AutoScrollController? _autoScrollController;
  final ScrollController _rotationController = ScrollController();
  Axis scrollDirection = Axis.horizontal;
  ActionType _selectedAction = ActionType.transform;
  double x1 = 100.0, y1 = 100.0, x1Prev = 100.0, y1Prev = 100.0;
  double rotationValue = 0, absoluteRotation = 0, scaleX = 1, scaleY = 1;
  bool isRotationActive = false, isEditorEnable = false;
  TextDirectionValue _textDirectionValue = TextDirectionValue.center;
  TextEditingController textEditingController = TextEditingController();
  FocusNode textFieldNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _rotationController.addListener(() {
      setState(() {
        rotationValue = _rotationController.offset / 100;
      });
    });
    _autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, MediaQuery.of(context).padding.bottom, 0),
        axis: scrollDirection);
  }

  @override
  void dispose() {
    super.dispose();
    _autoScrollController!.dispose();
    textEditingController.dispose();
    textFieldNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      appBar: utilityAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: RepaintBoundary(
                          key: _globalKey,
                          child: Stack(
                            children: [
                              Transform.rotate(
                                angle: absoluteRotation * math.pi / 180,
                                child: Transform.scale(
                                  scaleX: scaleX,
                                  scaleY: scaleY,
                                  child: Transform.rotate(
                                    angle: rotationValue,
                                    child: ColorFiltered(
                                        colorFilter: ColorFilter.matrix(
                                            filters[selectedFilter]['filter']),
                                        child: Image.file(widget.image)),
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   left: x1,
                              //   top: y1,
                              //   child: GestureDetector(
                              //     onPanDown: (d) {
                              //       x1Prev = x1;
                              //       y1Prev = y1;
                              //     },
                              //     onPanUpdate: (details) {
                              //       setState(() {
                              //         x1 = x1Prev + details.localPosition.dx;
                              //         y1 = y1Prev + details.localPosition.dy;
                              //       });
                              //     },
                              //     child: Container(
                              //       width: 64,
                              //       height: 64,
                              //       color: Colors.amber,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      // Positioned(
                      //     bottom: 0,
                      //     child: swapToFilter(
                      //         title: 'Swipe down to apply filter',
                      //         width: MediaQuery.of(context).size.width,
                      //         height: MediaQuery.of(context).size.height * 0.15,
                      //         direction: DirectionAxis.yNan,
                      //         onTrigger: () {
                      //           if (selectedFilter != 0) {
                      //             _capturePngToByteData().then((value) {
                      //               widget.onFiltered(value);
                      //             });
                      //           }
                      //           Navigator.pop(context);
                      //         })),
                    ],
                  ),
                ),
                allActionUi(),
                bottomActionPane()
              ],
            ),
            Visibility(
              visible: _selectedAction == ActionType.text && isEditorEnable,
              child: addText(size),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget utilityAppBar() {
    return isEditorEnable && _selectedAction == ActionType.text
        ? AppBar(
            elevation: 0,
            backgroundColor: CustomColors.primaryColor,
            leading: const SizedBox.shrink(),
            actions: [
              TextButton(
                  onPressed: () => setState(() {
                        isEditorEnable = false;
                      }),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                        color: CustomColors.secondaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          )
        : AppBar(
            title: const Text(
              'Edit',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            elevation: 0,
            backgroundColor: CustomColors.primaryColor,
            leading: IconButton(
              icon: const Icon(CupertinoIcons.clear, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    if (true) {
                      _capturePngToByteData().then((value) {
                        widget.onFiltered(value);
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        color: CustomColors.secondaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          );
  }

  Widget bottomActionPane() {
    return Visibility(
      visible: !isEditorEnable,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: CustomColors.primaryColorLight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconButton(
                icon: CupertinoIcons.crop_rotate,
                color: CustomColors.secondaryColor,
                toolTip: 'Transform',
                isActive: _selectedAction == ActionType.transform,
                onTap: () =>
                    setState(() => _selectedAction = ActionType.transform)),
            iconButton(
                icon: CupertinoIcons.color_filter,
                color: CustomColors.secondaryColor,
                toolTip: 'Filters',
                isActive: _selectedAction == ActionType.filters,
                onTap: () =>
                    setState(() => _selectedAction = ActionType.filters)),
            // iconButton(
            //     icon: CupertinoIcons.textbox,
            //     color: CustomColors.secondaryColor,
            //     toolTip: 'Text',
            //     isActive: _selectedAction == ActionType.text,
            //     onTap: () => setState(() {
            //           _selectedAction = ActionType.text;
            //           isEditorEnable = true;
            //         })),
            // iconButton(
            //     icon: CupertinoIcons.hand_draw,
            //     color: CustomColors.secondaryColor,
            //     toolTip: 'Draw',
            //     isActive: _selectedAction == ActionType.draw,
            //     onTap: () => setState(() => _selectedAction = ActionType.draw)),
          ],
        ),
      ),
    );
  }

  Widget iconButton(
      {required IconData icon,
      required Color color,
      String toolTip = '',
      required bool isActive,
      EdgeInsets margin = EdgeInsets.zero,
      required VoidCallback onTap}) {
    return Tooltip(
      message: toolTip,
      child: InkWell(
        onTap: () => onTap(),
        highlightColor: CustomColors.primaryColor,
        splashColor: CustomColors.primaryColor,
        child: Container(
            height: 40,
            width: 40,
            margin: margin,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Icon(
              icon,
              color: isActive
                  ? widget.activeColor ?? CustomColors.activeColor
                  : color,
            )),
      ),
    );
  }

  Widget allActionUi() {
    return SizedBox(
      height: 150.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [transform(), allFilters(), text()],
      ),
    );
  }

  Widget transform() {
    return Visibility(
        visible: ActionType.transform == _selectedAction,
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: AvailableOptions(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    iconButton(
                        icon: CupertinoIcons.rotate_right,
                        color: CustomColors.secondaryColor,
                        toolTip: 'Rotate',
                        margin: const EdgeInsets.only(
                            left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
                        isActive: isRotationActive,
                        onTap: () {
                          if (absoluteRotation == 0) {
                            setState(() {
                              absoluteRotation = 90;
                              isRotationActive = true;
                            });
                          } else if (absoluteRotation == 90) {
                            setState(() {
                              absoluteRotation = 180;
                              isRotationActive = true;
                            });
                          } else if (absoluteRotation == 180) {
                            setState(() {
                              absoluteRotation = 270;
                              isRotationActive = true;
                            });
                          } else if (absoluteRotation == 270) {
                            setState(() {
                              absoluteRotation = 360;
                              isRotationActive = false;
                            });
                          } else {
                            setState(() {
                              absoluteRotation = 90;
                              isRotationActive = true;
                            });
                          }
                        }),
                    iconButton(
                        icon: CupertinoIcons.chevron_left_slash_chevron_right,
                        color: CustomColors.secondaryColor,
                        toolTip: 'Flip Horizontal',
                        margin: const EdgeInsets.only(
                            left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
                        isActive: scaleX.isNegative,
                        onTap: () {
                          if (scaleX.isNegative) {
                            setState(() => scaleX = 1);
                          } else {
                            setState(() => scaleX = -1);
                          }
                        }),
                    iconButton(
                        icon: CupertinoIcons.chevron_up_chevron_down,
                        color: CustomColors.secondaryColor,
                        toolTip: 'Flip Vertical',
                        margin: const EdgeInsets.only(
                            left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
                        isActive: scaleY.isNegative,
                        onTap: () {
                          if (scaleY.isNegative) {
                            setState(() => scaleY = 1);
                          } else {
                            setState(() => scaleY = -1);
                          }
                        }),
                  ],
                ),
              ),
            ),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.85,
              margin: const EdgeInsets.only(bottom: 10),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 25,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: 95,
                            controller: _rotationController,
                            itemBuilder: (context, index) => Container(
                                  width: 10,
                                  color: Colors.transparent,
                                  child: const VerticalDivider(
                                    color: Colors.white,
                                    thickness: 1,
                                    indent: 7.5,
                                    endIndent: 7.5,
                                  ),
                                ))),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 50,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${(rotationValue * 57.3).toStringAsFixed(1)}°",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: widget.activeColor ??
                                    CustomColors.activeColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            height: 15,
                            width: 1.5,
                            color:
                                widget.activeColor ?? CustomColors.activeColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          CustomColors.primaryColor.withOpacity(0.9),
                          CustomColors.primaryColor.withOpacity(0.3)
                        ]),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            transform: const GradientRotation(3.14159),
                            colors: [
                              CustomColors.primaryColor.withOpacity(0.9),
                              CustomColors.primaryColor.withOpacity(0.3)
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget allFilters() {
    return Visibility(
      visible: ActionType.filters == _selectedAction,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        height: 70.0,
        color: Colors.black,
        child: ListView.builder(
            itemCount: filters.length,
            scrollDirection: scrollDirection,
            controller: _autoScrollController,
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 10, right: 10),
            physics: const AlwaysScrollableScrollPhysics(),
            addAutomaticKeepAlives: true,
            itemBuilder: (context, index) {
              return AutoScrollTag(
                key: ValueKey(index),
                controller: _autoScrollController!,
                index: index,
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      selectedFilter = index;
                    });
                    await _autoScrollController!.scrollToIndex(selectedFilter,
                        preferPosition: AutoScrollPosition.middle);
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: selectedFilter == index
                                  ? widget.activeColor ??
                                      CustomColors.activeColor
                                  : Colors.transparent),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: ColorFiltered(
                          colorFilter:
                              ColorFilter.matrix(filters[index]['filter']),
                          child: Container(
                            width: 60.0,
                            decoration: BoxDecoration(
                                color: CustomColors.primaryColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                                image: DecorationImage(
                                  image: FileImage(widget.image),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 8,
                          child: Container(
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  spreadRadius: 3,
                                  offset: Offset(0, -2))
                            ]),
                            child: Text(
                              filters[index]['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ))
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget text() {
    return Visibility(
      visible: _selectedAction == ActionType.text && !isEditorEnable,
      child: AvailableOptions(
        child: const Text(
          'Add Text',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        padding:
            const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
        onTap: () => setState(() => isEditorEnable = true),
      ),
    );
  }

  Widget addText(Size size) {
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.black26,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              autofocus: true,
              cursorColor: widget.activeColor ?? CustomColors.activeColor,
              buildCounter: buildEmptyCounter,
              maxLength: 1000,
              minLines: 1,
              maxLines: 10,
              controller: textEditingController,
              focusNode: textFieldNode,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
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
                        iconButton(
                            icon:
                                (_textDirectionValue == TextDirectionValue.left
                                    ? CupertinoIcons.text_alignleft
                                    : (_textDirectionValue ==
                                            TextDirectionValue.center
                                        ? CupertinoIcons.text_aligncenter
                                        : CupertinoIcons.text_alignright)),
                            color: CustomColors.secondaryColor,
                            toolTip: 'Text Alignment',
                            margin: const EdgeInsets.only(
                                left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
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
                              if (selectedFont < 11) {
                                setState(() => selectedFont++);
                              } else {
                                setState(() => selectedFont = 1);
                              }
                            },
                            child: Text(
                              "Font $selectedFont",
                              style: TextStyle(
                                  fontFamily: fonts[selectedFont],
                                  color: Colors.white),
                            ))
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget? buildEmptyCounter(BuildContext context,
          {required int currentLength,
          int? maxLength,
          required bool isFocused}) =>
      null;

  Future<ByteData> _capturePngToByteData() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      boundary = _globalKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary;
      double dpr = ui.window.devicePixelRatio;
      ui.Image image =
          await boundary.toImage(pixelRatio: widget.pixelRatio ?? dpr);
      ByteData? _byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return _byteData!;
    } catch (e) {
      rethrow;
    }
  }
}
