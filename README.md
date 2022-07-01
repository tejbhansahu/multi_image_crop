# Multi Image Cropper package for Flutter

A flutter package to crop multiple images at a time on iOS and Android.

## Features

![Image Cropping Preview](assets/gif.gif)

The package comes with a `MultiImageCrop.startCropping()` method. The method crop and filter only images.

The package is working with files to avoid passing large amount of data through method channels.
Files are stored in cache folders of iOS and Android. Thus if there is a need to save actual croped image,
ensure to copy the file to other location.

All of the computation intensive work is done off a main thread via dispatch queues on iOS and cache thread pool on Android.

## Credits notice

This package use [image_crop](https://pub.dartlang.org/packages/image_crop) plugin,
original credits goes to him. This plugin fundamentally good in our opinion. The main differences in this package include:

- Multiple image crop
- Image filters

*Note*: This package is still under development, some features are not available yet and testing has been limited.

## Using
Create a method and pass list of image or a single image to crop:
```dart
MultiImageCrop.startCropping(
    context: context,
    aspectRatio: 4 / 3,
    activeColor: Colors.amber,
    pixelRatio: 3,
    files: List.generate(
        receivedFiles!.length, (index) => File(receivedFiles![index].path)),
    callBack: (List<File> images) {
      setState(() {
        croppedFiles = images;
      });
    });
```

## Support

The following support channels are available at your fingertips:

- [Help on Email](mailto:tejbhansahu0.ts@gmail.com)
- [Follow on Twitter](https://twitter.com/imTej_Sahu)

## License

This package is released under [Apache 2.0 License](LICENSE).
