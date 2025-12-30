import 'package:get_me_a_tutor/import_export.dart';

void showSnackBar(BuildContext context, String text, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: Colors.black,
    ),
  );
}


Future<List<File>> pickImages({int max = 1, required type, List<String>?allowedExtensions}) async {
  List<File> images = [];

  // Permission handling
  if (Platform.isAndroid) {
    final photosStatus = await Permission.photos.request();
    final storageStatus = await Permission.storage.request();

    if (!photosStatus.isGranted && !storageStatus.isGranted) {
      debugPrint('No media permission granted');
      return images;
    }
  }

  if (Platform.isIOS) {
    final photosStatus = await Permission.photos.request();
    if (!photosStatus.isGranted) {
      debugPrint('Photos permission denied');
      return images;
    }
  }

  try {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: allowedExtensions,
      type: type,
      allowMultiple: max>1,
    );

    if (result != null) {
      images = result.files
          .where((f) => f.path != null)
          .map((f) => File(f.path!))
          .take(max)
          .toList();
    }
  } catch (e) {
    debugPrint('File pick error: $e');
  }

  return images;
}

