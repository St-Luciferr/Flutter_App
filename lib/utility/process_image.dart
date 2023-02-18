import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image/image.dart' as img;

Future<XFile> resizeImage(img) async {
  final File compressedFile;
  ImageProperties properties =
      await FlutterNativeImage.getImageProperties(img.path);
  if (properties.orientation == ImageOrientation.undefined ||
      properties.orientation == ImageOrientation.normal) {
    compressedFile = await FlutterNativeImage.compressImage(img.path,
        quality: 90, targetWidth: 392, targetHeight: 524);
  } else if (properties.orientation == ImageOrientation.rotate90) {
    compressedFile = await FlutterNativeImage.compressImage(img.path,
        quality: 90, targetWidth: 524, targetHeight: 392);
  } else {
    compressedFile = await FlutterNativeImage.compressImage(img.path,
        quality: 90, targetWidth: 392, targetHeight: 524);
  }
  debugPrint('\n${properties.orientation.toString()}\n');

  // delete original file
  try {
    if (await img.exists()) {
      await img.delete();
    }
  } catch (e) {
    debugPrint("\nError in deleting original image\n");
    // Error in getting access to the file.
  }

  return XFile(compressedFile.path);
}

Future<XFile> rotateImg(imagePath) async {
  final originalFile = File(imagePath);
  ImageProperties properties =
      await FlutterNativeImage.getImageProperties(imagePath);
  List<int> imageBytes;
  final img.Image? originalImage;

  // Let's check 'Image Orientation'

  img.Image fixedImage;

  // Let's check for the image orientation
  // This will be true also for landscape image but leave it for now
  if (properties.orientation == ImageOrientation.normal ||
      properties.orientation == ImageOrientation.undefined) {
    // just return orignal image
    return XFile(originalFile.path);
  } else {
    debugPrint('Rotating image necessary');
    // We'll use the exif package to read exif data
    // This is map of several exif properties
    imageBytes = await originalFile.readAsBytes();
    originalImage = img.decodeImage(Uint8List.fromList(imageBytes));
    // rotate
    if (properties.orientation == ImageOrientation.rotate90) {
      fixedImage = img.copyRotate(originalImage!, angle: 0);
    } else if (properties.orientation == ImageOrientation.rotate180) {
      fixedImage = img.copyRotate(originalImage!, angle: 0);
    } else if (properties.orientation == ImageOrientation.rotate270) {
      fixedImage = img.copyRotate(originalImage!, angle: 0);
    } else {
      fixedImage = img.copyRotate(originalImage!, angle: 0);
    }
  }

  // Here you can select whether you'd like to save it as png
  // or jpg with some compression
  // I choose jpg with 100% quality
  final fixedFile = await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

  return XFile(fixedFile.path);
}
