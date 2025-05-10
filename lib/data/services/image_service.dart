import 'dart:io';

import 'package:camera/camera.dart';
import 'package:macromiam/data/services/sqlite_db_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageService {
  final SqliteDbService sqliteDbService;

  ImageService({required this.sqliteDbService});

  Future<File> saveImage({required XFile cacheImage}) async {
    final directory = await getApplicationDocumentsDirectory();

    final String fileName =
        'macromiam_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final String newPath = path.join(directory.path, fileName);

    final File persistentImage = await File(cacheImage.path).copy(newPath);

    await File(cacheImage.path).delete();

    return persistentImage;
  }

  Future<void> deleteImage({required String pathOrUrl}) async {
    if (!pathOrUrl.contains('no_image_placeholder') &&
        pathOrUrl.substring(0, 4) != 'http') {
      bool isPathUsed = await sqliteDbService.isPathUsed(path: pathOrUrl);
      if (!isPathUsed) {
        if (pathOrUrl.contains('file_picker')) {
          final Directory directory = Directory(path.dirname(pathOrUrl));
          if (await directory.exists()) {
            await directory.delete(recursive: true);
          }
        } else {
          final File file = File(pathOrUrl);
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
