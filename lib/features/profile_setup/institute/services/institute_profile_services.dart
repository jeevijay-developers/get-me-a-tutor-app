import 'package:http/http.dart' as http;
import 'package:get_me_a_tutor/import_export.dart';

class InstituteProfileServices {
  final Dio _dio = Dio();
  Future<Map<String, dynamic>?> createInstituteProfile({
    required BuildContext context,
    required String token,
    required String institutionName,
    required String institutionType,
    required String about,
    required String email,
    required String phone,
    required String website,
    required Map<String, String> address,
    required File? logo,
    required List<File> galleryImages,
  }) async {
    try {
      final formData = FormData();

      formData.fields.addAll([
        MapEntry('institutionName', institutionName),
        MapEntry('institutionType', institutionType),
        MapEntry('about', about),
        MapEntry('email', email),
        MapEntry('phone', phone),
        MapEntry('website', website),
        MapEntry('address', jsonEncode(address)),
      ]);

      if (logo != null) {
        formData.files.add(
          MapEntry('logo', await MultipartFile.fromFile(logo.path)),
        );
      }

      for (final img in galleryImages) {
        formData.files.add(
          MapEntry('galleryImages', await MultipartFile.fromFile(img.path)),
        );
      }

      final response = await _dio.post(
        '${GlobalVariables.baseUrl}/api/institution',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      showSnackBar(context, 'Institution profile created');
      return response.data;
    } catch (e) {
      showSnackBar(context, e.toString());
      return null;
    }
  }

}
