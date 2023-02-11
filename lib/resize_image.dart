import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

Future<XFile> resizeImage(img) async {
  // ImageProperties properties =
  //     await FlutterNativeImage.getImageProperties(img.path);

  File compressedFile = await FlutterNativeImage.compressImage(img.path,
      quality: 90, targetWidth: 300, targetHeight: 300);

  // delete original file
  try {
    if (await img.exists()) {
      await img.delete();
    }
  } catch (e) {
    // Error in getting access to the file.
  }

  return XFile(compressedFile.path);
}
