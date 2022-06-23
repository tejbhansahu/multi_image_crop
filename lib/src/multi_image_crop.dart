import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_crop/image_crop.dart';
import 'package:multi_image_crop/src/common/util/constants.dart';
import 'package:multi_image_crop/src/common/util/fade_page_route.dart';
import 'package:multi_image_crop/src/filter_image.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'common/util/colors.dart';
import 'common/widgets/loader_widget.dart';
import 'common/widgets/swiping_ui.dart';

class MultiImageCropService extends StatefulWidget {
  const MultiImageCropService(
      {Key? key, required this.files, required this.aspectRatio})
      : super(key: key);

  final List<File> files;
  final double aspectRatio;

  @override
  State<MultiImageCropService> createState() =>
      _MultiImageCropServiceState(files);
}

class _MultiImageCropServiceState extends State<MultiImageCropService>
    with SingleTickerProviderStateMixin {
  late List<GlobalObjectKey<CropState>> cropKeyList = [];

  final PreloadPageController _pageController = PreloadPageController();
  AnimationController? controller;
  AutoScrollController? _autoScrollController;

  final scrollDirection = Axis.horizontal;
  int currentPage = 0;
  File? _lastCropped;
  List<File> cropFiles = [];
  String? mediaType;

  List<File> files;

  _MultiImageCropServiceState(this.files);

  @override
  void initState() {
    super.initState();
    cropKeyList = List.generate(
        files.length, (index) => GlobalObjectKey<CropState>(index));
    mediaType = files[0].path.split('.').last;
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, MediaQuery.of(context).padding.bottom, 0),
        axis: scrollDirection);
  }

  @override
  void dispose() {
    controller!.dispose();
    _pageController.dispose();
    _autoScrollController!.dispose();
    // _lastCropped?.delete();
    cropKeyList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utilityAppBar(),
      backgroundColor: Colors.black,
      floatingActionButton: fab(),
      body: Column(
        children: [
          croppingView(),
          thumbnailsControl(),
        ],
      ),
    );
  }

  PreferredSizeWidget utilityAppBar() {
    return AppBar(
      title: Text(
        files.length.toString(),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      elevation: 0,
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(CupertinoIcons.clear, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            files.removeAt(currentPage);
            cropKeyList.removeAt(currentPage);
            if (files.isNotEmpty) {
              currentPage = 0;
            }
            setState(() {});
            if (files.isEmpty) Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.delete, color: Colors.white),
        ),
      ],
    );
  }

  Widget fab() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0),
      child: FloatingActionButton(
        heroTag: const ValueKey('fab'),
        onPressed: () => cropImage(),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 3.0,
        child: const Icon(
          Icons.done,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget croppingView() {
    String extension = files.isNotEmpty
        ? files[currentPage].path.split('.').last.toLowerCase()
        : '';
    return Expanded(
        child: Stack(
      children: [
        PreloadPageView.builder(
          controller: _pageController,
          itemCount: files.length,
          preloadPagesCount: files.length,
          physics: files.length > 1
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          // allowImplicitScrolling: true,
          onPageChanged: (page) async {
            await _autoScrollController!
                .scrollToIndex(page, preferPosition: AutoScrollPosition.middle);
            setState(() {
              currentPage = page;
              mediaType = files[page].path.split('.').last;
            });
          },
          itemBuilder: (context, index) {
            return Material(
              type: MaterialType.transparency,
              child: Hero(
                tag: const ValueKey('crop'),
                child: Crop(
                  image: FileImage(File(files[index].path)),
                  key: cropKeyList[index],
                  aspectRatio: widget.aspectRatio,
                ),
              ),
            );
          },
        ),
        Positioned(
            bottom: 0,
            child: Visibility(
              visible: extension != 'mp4' ||
                  extension != 'mov' ||
                  extension != '3gp' ||
                  extension != 'm3u8' ||
                  extension != 'avi',
              child: swapToFilter(
                  title: 'Swipe up to add filters',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.15,
                  direction: DirectionAxis.y,
                  onTrigger: () => Navigator.push(
                      context,
                      FadePageRoute(
                          fullscreenDialog: true,
                          builder: (_) => FilterImage(
                                image: files[currentPage],
                                onFiltered: (ByteData imageMemory) async {
                                  final buffer = imageMemory.buffer;
                                  File tempFile =
                                      await File(files[currentPage].path)
                                          .writeAsBytes(buffer.asUint8List(
                                              imageMemory.offsetInBytes,
                                              imageMemory.lengthInBytes));
                                  if (kDebugMode) {
                                    print('Filter applied successfully...');
                                  }
                                  setState(() {
                                    files[currentPage] = tempFile;
                                  });
                                  imageCache!.clearLiveImages();
                                  imageCache!.clear();
                                  setState(() {});
                                },
                              )))),
            ))
      ],
    ));
  }

  Widget thumbnailsControl() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      height: 90.0,
      color: Colors.black,
      child: ListView.builder(
          itemCount: files.length,
          scrollDirection: scrollDirection,
          shrinkWrap: true,
          controller: _autoScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          addAutomaticKeepAlives: true,
          itemBuilder: (context, index) {
            return AutoScrollTag(
              key: ValueKey(index),
              controller: _autoScrollController!,
              index: index,
              child: InkWell(
                onTap: () {
                  controller!.reverse();
                  _pageController.animateToPage(index,
                      duration: const Duration(seconds: 1),
                      curve: Curves.linearToEaseOut);
                },
                child: Container(
                  width: 70.0,
                  margin: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(
                          color: currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.black)),
                  child: Image.file(
                    File(files[index].path),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                          height: 90,
                          child: Icon(
                            Icons.video_call,
                            color: Colors.white,
                          ));
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }

  cropImage() async {
    showLoaderDialog(context, title: "Please wait..");
    for (int i = 0; i < files.length; i++) {
      double scale = cropKeyList[i].currentState!.scale;
      Rect? area = cropKeyList[i].currentState!.area;
      if (area == null) {
        area = const Rect.fromLTRB(0.0, 0.3, 1.0, 0.7);
        scale = 0.4756620523623232;
      }
      final sample = await ImageCrop.sampleImage(
        file: File(files[i].path),
        preferredSize: (2000 / scale).round(),
      );
      final file = await ImageCrop.cropImage(
        file: sample,
        area: area,
      );
      sample.delete();
      // _lastCropped?.delete();
      _lastCropped = file;
      cropFiles.add(file);
    }
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pop(cropFiles);
  }
}
