import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<void> selectFile({required Function(XFile) onFilePicked}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        XFile cacheImage = result.xFiles.single;
        onFilePicked(cacheImage);
      }
    } catch (e) {
      throw Exception("File picking cancelled or failed");
    }
  }

  Future<void> clearCache() async {
    await FilePicker.platform.clearTemporaryFiles();
  }
}
