library imageutils;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  ///  `final File file = await ImageUtils.urlToFile('https://blabla');`
  static Future<File> urlToFile(String imageUrl) async {
    try {
      // get temporary directory of device.
      Directory tempDir = await getTemporaryDirectory();

      // get temporary path from temporary directory.
      String tempPath = tempDir.path;

      // create a new file in temporary path with random file name.
      File file = new File('$tempPath' + (DateTime.now().millisecondsSinceEpoch.toString()) + '.png');

      // call http.get method and pass imageUrl into it to get response.
      http.Response response = await http.get(imageUrl);

      // write bodyBytes received in response to file.
      await file.writeAsBytes(response.bodyBytes);

      // now return the file which is created with random name in
      // temporary directory and image bytes from response is written to // that file.
      return file;
    } catch (e) {
      return null;
    }
  }

  /// `String base64 = ImageConfig.fileToBase64(file);`
  static Future<String> fileToBase64(File file) async {
    try {
      String base64Image = base64Encode(file.readAsBytesSync());
      return base64Image;
    } catch (e) {
      return null;
    }
  }

  static Future<File> base64ToFile(String base64) async {
    try {
      Uint8List uint8list = base64Decode(base64);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File("$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
      return await file.writeAsBytes(uint8list);
    } catch (e) {
      return null;
    }
  }

  /// Convert string base64 to Image -> `Container(child: Image)`
  static Future<Image> base64ToImage(String base64) async {
    try {
      Uint8List uint8list = base64Decode(base64);
      return Image.memory(uint8list);
    } catch (e) {
      return null;
    }
  }

  // Convert image to file
  // static Future<File> imageToFile({String imageName, String ext}) async {
  //   var bytes = await rootBundle.load('assets/$imageName.$ext');
  //   String tempPath = (await getTemporaryDirectory()).path;
  //   File file = File('$tempPath/profile.png');
  //   await file.writeAsBytes(
  //       bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
  //   return file;
  // }

  /// `final File file = await ImageConfig.resize(file);`
  ///
  /// `size: [width, height]`
  static Future<File> resize(File file, {int quality: 90, List<int> size: const [500, 500]}) async {
    try {
      File compressedFile = await FlutterNativeImage.compressImage(file.path, quality: 90, targetWidth: size[0], targetHeight: size[1]);
      return compressedFile;
    } catch (e) {
      return null;
    }
  }

  /// ambil informasi gambar (height, width, orientasi), fungsi ini akan mengembalikan data `{'height': int, 'width': int, 'orientation': ImageOrientation}`
  static Future<Map> imageProperties(File file) async {
    try {
      ImageProperties properties = await FlutterNativeImage.getImageProperties(file.path);
      return {'width': properties.width, 'height': properties.height, 'orientation': properties.orientation};
    } catch (e) {
      return {'width': null, 'height': null, 'orientation': null};
    }
  }
}
