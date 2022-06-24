library multi_image_crop;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:multi_image_crop/src/multi_image_crop.dart';

class MultiImageCrop {
  static startCropping({required BuildContext context,
    required List<File> files,
    required double aspectRatio,
    required Function callBack}) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MultiImageCropService(
                  files: files,
                  aspectRatio: aspectRatio,
                ))).then((value) {
      if (value != null) {
        callBack(value);
      }
    });
  }
}
