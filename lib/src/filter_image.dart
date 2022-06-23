import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:multi_image_crop/src/common/util/filters.dart';
import 'common/util/colors.dart';
import 'common/util/constants.dart';
import 'common/widgets/swiping_ui.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class FilterImage extends StatefulWidget {
  const FilterImage({Key? key, required this.image, required this.onFiltered})
      : super(key: key);

  final File image;
  final Function onFiltered;

  @override
  State<FilterImage> createState() => _FilterImageState();
}

class _FilterImageState extends State<FilterImage> {
  final GlobalKey _globalKey = GlobalKey();
  int selectedFilter = 0;
  ByteData? selectedByteData;

  List<dynamic> filters = [
    FilterType.NO_FILTER,
    FilterType.PURPLE,
    FilterType.YELLOW,
    FilterType.CYAN,
    FilterType.BLACK_WHITE,
    FilterType.OLD_TIMES,
    FilterType.COLD_LIFE,
    FilterType.SEPIUM,
    FilterType.MILK,
    FilterType.SEPIA_MATRIX,
    FilterType.GREYSCALE_MATRIX,
    FilterType.VINTAGE_MATRIX,
    FilterType.FILTER_1,
    FilterType.FILTER_2,
    FilterType.FILTER_3,
    FilterType.FILTER_4,
    FilterType.FILTER_5
  ];

  PreferredSizeWidget utilityAppBar() {
    return AppBar(
      title: const Text(
        'Filters',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      elevation: 0,
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(CupertinoIcons.clear, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: utilityAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Hero(
                      tag: const ValueKey('crop'),
                      child: RepaintBoundary(
                        key: _globalKey,
                        child: ColorFiltered(
                            colorFilter:
                                ColorFilter.matrix(filters[selectedFilter]),
                            child: Image.file(widget.image)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: swapToFilter(
                        title: 'Swipe down to apply filter',
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.15,
                        direction: DirectionAxis.yNan,
                        onTrigger: () {
                          if (selectedFilter != 0) {
                            _capturePngToByteData().then((value) {
                              widget.onFiltered(value);
                            });
                          }
                          Navigator.pop(context);
                        })),
              ],
            ),
          ),
          allFilters(),
        ],
      ),
    );
  }

  Widget allFilters() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      height: 90.0,
      color: Colors.black,
      child: ListView.builder(
          itemCount: filters.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 10, right: 10),
          physics: const AlwaysScrollableScrollPhysics(),
          addAutomaticKeepAlives: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedFilter = index;
                });
              },
              child: Container(
                width: 70.0,
                margin: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    color: primaryColor,
                    border: Border.all(
                        color: selectedFilter == index
                            ? Theme.of(context).primaryColor
                            : Colors.black)),
                child: ColorFiltered(
                    colorFilter: ColorFilter.matrix(filters[index]),
                    child: Image.file(
                      widget.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                            height: 90,
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.white,
                            ));
                      },
                    )),
              ),
            );
          }),
    );
  }

  Future<ByteData> _capturePngToByteData() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      boundary = _globalKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary;
      double dpr = ui.window.devicePixelRatio;
      ui.Image image = await boundary.toImage(pixelRatio: dpr);
      ByteData? _byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return _byteData!;
    } catch (e) {
      rethrow;
    }
  }
}
