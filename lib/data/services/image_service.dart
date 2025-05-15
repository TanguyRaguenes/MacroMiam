import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:macromiam/data/services/sqlite_db_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageService {
  final SqliteDbService sqliteDbService;

  ImageService({required this.sqliteDbService});

  Future<File> saveImage({required XFile cacheImage}) async {
    final directory = await getApplicationDocumentsDirectory();

    XFile compressedCacheImage = await compressImage(cacheImage);

    final String fileName =
        'macromiam_${DateTime.now().millisecondsSinceEpoch}.webp';

    final String newPath = path.join(directory.path, fileName);

    final File persistentImage = await File(
      compressedCacheImage.path,
    ).copy(newPath);

    return persistentImage;
  }

  Future<XFile> compressImage(XFile image) async {
    final targetPath = '${image.path}_compressed.webp';

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      format: CompressFormat.webp,
      quality: 30,
    );

    if (compressedFile == null) {
      throw Exception("Error when trying to compress image");
    }

    return compressedFile;
  }

  Future<void> deleteImage({required String imageSource}) async {
    if (!imageSource.contains('no_image_placeholder') &&
        imageSource.substring(0, 4) != 'http') {
      bool isPathUsed = await sqliteDbService.isPathUsed(path: imageSource);
      if (!isPathUsed) {
        if (imageSource.contains('file_picker')) {
          final Directory directory = Directory(path.dirname(imageSource));
          if (await directory.exists()) {
            await directory.delete(recursive: true);
          }
        } else {
          final File file = File(imageSource);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
    }
  }

  Future<void> clearCache() async {
    final Directory cacheDirectory = await getTemporaryDirectory();

    if (await cacheDirectory.exists()) {
      final List<FileSystemEntity> files = cacheDirectory.listSync();
      for (var file in files) {
        try {
          if (file is File) {
            await file.delete();
          } else if (file is Directory) {
            await file.delete(recursive: true);
          }
        } catch (e) {
          print("Error when trying to suppress ${file.path} : $e");
        }
      }
    }
  }
}
