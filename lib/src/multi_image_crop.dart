import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_crop/image_crop.dart';
import 'package:multi_image_crop/src/common/util/colors.dart';
import 'package:multi_image_crop/src/common/util/fade_page_route.dart';
import 'package:multi_image_crop/src/edit_image.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'common/util/colors.dart';
import 'common/widgets/icon_button.dart';
import 'common/widgets/loader_widget.dart';

class MultiImageCropService extends StatefulWidget {
  const MultiImageCropService(
      {Key? key,
      required this.files,
      required this.aspectRatio,
      this.activeColor,
      required this.alwaysShowGrid,
      this.pixelRatio, 
      this.titleVisible = true})
      : super(key: key);

  final List<File> files;
  final double aspectRatio;
  final double? pixelRatio;
  final Color? activeColor;
  final bool alwaysShowGrid;
  final bool titleVisible;

  @override
  State<MultiImageCropService> createState() =>
      _MultiImageCropServiceState(files);
}

class _MultiImageCropServiceState extends State<MultiImageCropService>
    with SingleTickerProviderStateMixin {
  /// [cropKeyList] contains Global key of each crop ui.
  late List<GlobalObjectKey<CropState>> cropKeyList = [];

  /// package [PreloadPageController] is used to preload all images to save time
  /// of rendering each crop ui.
  final PreloadPageController _pageController = PreloadPageController();

  /// [AnimationController] is used to make smooth transition effect while
  /// switching between images.
  AnimationController? controller;

  /// [AutoScrollController] is used to scroll thumbnail image without user scroll.
  AutoScrollController? _autoScrollController;

  /// Default scrollDirection is Horizontal.
  final scrollDirection = Axis.horizontal;

  /// Variable [currentPage] holds the value of current crop ui.
  int currentPage = 0;

  /// [cropFiles] holds the cropped images.
  List<File> cropFiles = [];
  String? mediaType;
  bool isIos = false;

  List<File> files;

  _MultiImageCropServiceState(this.files);

  @override
  void initState() {
    super.initState();
    isIos = Platform.isIOS;

    /// Generates key for each crop ui.
    cropKeyList = List.generate(
        files.length, (index) => GlobalObjectKey<CropState>(index));

    /// Finds extension of file, weather it's a image or anything else.
    mediaType = files[0].path.split('.').last;

    /// define animation duration.
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    /// define viewPort and scrollDirection.
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
    cropKeyList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utilityAppBar(),
      backgroundColor: CustomColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [croppingView(), thumbnailsControl(), actionBar()],
        ),
      ),
    );
  }

  PreferredSizeWidget utilityAppBar() {
    return AppBar(
      title: widget.titleVisible ? Text(
        files.length.toString(),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ) : null,
      elevation: 0,
      backgroundColor: CustomColors.primaryColor,
      leading: IconButton(
        icon: Icon(isIos ? CupertinoIcons.back : Icons.arrow_back,
            color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Crop ui [croppingView] shows all selected images to crop.
  Widget croppingView() {
    // String extension = files.isNotEmpty
    //     ? files[currentPage].path.split('.').last.toLowerCase()
    //     : '';
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
          onPageChanged: (page) async {
            await _autoScrollController!
                .scrollToIndex(page, preferPosition: AutoScrollPosition.middle);
            setState(() {
              currentPage = page;
              mediaType = files[page].path.split('.').last;
            });
          },
          itemBuilder: (context, index) {
            return Crop(
              image: FileImage(File(files[index].path)),
              key: cropKeyList[index],
              alwaysShowGrid: widget.alwaysShowGrid,
              aspectRatio: widget.aspectRatio,
            );
          },
        ),
      ],
    ));
  }

  /// [thumbnailsControl] shows image preview of all selected images.
  Widget thumbnailsControl() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      height: 90.0,
      color: CustomColors.primaryColor,
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
                      color: CustomColors.primaryColor,
                      border: Border.all(
                          color: currentPage == index
                              ? widget.activeColor ?? CustomColors.activeColor
                              : CustomColors.primaryColor)),
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

  /// Main method [cropImage] responsible for cropping all images.
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
      cropFiles.add(file);
    }
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pop(cropFiles);
  }

  /// List of available options perform on current position image.
  Widget actionBar() {
    return Container(
      color: CustomColors.primaryColorLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomIconButton(
            onTap: () {
              files.removeAt(currentPage);
              cropKeyList.removeAt(currentPage);
              if (files.isNotEmpty) {
                currentPage = 0;
              }
              setState(() {});
              if (files.isEmpty) Navigator.pop(context);
            },
            toolTip: 'Delete',
            labelText: 'Delete',
            activeColor: CustomColors.secondaryColor,
            isActive: false,
            inActiveColor: CustomColors.secondaryColor,
            icon: isIos ? CupertinoIcons.delete : Icons.delete,
          ),
          CustomIconButton(
            onTap: () {
              Navigator.push(
                  context,
                  FadePageRoute(
                      fullscreenDialog: true,
                      builder: (_) => EditImage(
                            image: files[currentPage],
                            pixelRatio: widget.pixelRatio,
                            activeColor:
                                widget.activeColor ?? CustomColors.activeColor,
                            onFiltered: (ByteData imageMemory) async {
                              final buffer = imageMemory.buffer;
                              await File(files[currentPage].path).writeAsBytes(
                                  buffer.asUint8List(imageMemory.offsetInBytes,
                                      imageMemory.lengthInBytes));
                              if (kDebugMode) {
                                print('Filter applied successfully...');
                              }
                              imageCache.clearLiveImages();
                              imageCache.clear();
                              setState(() {});
                            },
                          )));
            },
            toolTip: 'Edit',
            labelText: 'Edit',
            activeColor: CustomColors.secondaryColor,
            isActive: false,
            inActiveColor: CustomColors.secondaryColor,
            icon: isIos ? CupertinoIcons.pencil : Icons.edit,
          ),
          CustomIconButton(
              onTap: () => cropImage(),
              toolTip: 'Crop',
              labelText: 'Crop',
              activeColor: CustomColors.secondaryColor,
              isActive: false,
              inActiveColor: CustomColors.secondaryColor,
              icon: Icons.check),
        ],
      ),
    );
  }
}
