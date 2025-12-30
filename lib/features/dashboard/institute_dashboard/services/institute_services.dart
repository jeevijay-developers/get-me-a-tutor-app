import 'package:http/http.dart' as http;
import 'package:get_me_a_tutor/import_export.dart';

class InstituteServices {
  // GET MY INSTITUTE PROFILE
  Future<Map<String, dynamic>?> getMyInstitute({
    required BuildContext context,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${GlobalVariables.baseUrl}/api/institution/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic>? result;

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          result = jsonDecode(response.body);
        },
      );

      return result;
    } catch (e) {
      return null;
    }
  }
  Future<bool> updateInstituteProfile({
    required BuildContext context,
    required String instituteId,
    required String token,
    required Map<String, dynamic> body,
    File? logo,
    List<File>? galleryImages,
  }) async {
    try {
      final formData = FormData();

      // 1️⃣ Add normal fields
      body.forEach((key, value) {
        if (value == null) return;

        if (value is Map) {
          // keep your address logic AS IS
          value.forEach((k, v) {
            formData.fields.add(MapEntry('$key[$k]', v.toString()));
          });
        } else if (value is List) {
          for (var v in value) {
            formData.fields.add(MapEntry('$key[]', v.toString()));
          }
        } else {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      // 2️⃣ Logo
      if (logo != null) {
        formData.files.add(
          MapEntry(
            'logo',
            await MultipartFile.fromFile(
              logo.path,
              filename: logo.path.split('/').last,
            ),
          ),
        );
      }

      // 3️⃣ Gallery images
      if (galleryImages != null && galleryImages.isNotEmpty) {
        for (final img in galleryImages) {
          formData.files.add(
            MapEntry(
              'galleryImages',
              await MultipartFile.fromFile(
                img.path,
                filename: img.path.split('/').last,
              ),
            ),
          );
        }
      }

      final dio = Dio();

      final response = await dio.put(
        '${GlobalVariables.baseUrl}/api/institution/$instituteId',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        showSnackBar(context, 'Profile updated successfully');
        return true;
      }

      return false;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

// DELETE INSTITUTE PROFILE
  Future<bool> deleteInstituteProfile({
    required BuildContext context,
    required String instituteId,
    required String token,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('${GlobalVariables.baseUrl}/api/institution/$instituteId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      bool success = false;

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          success = true;
          showSnackBar(context, 'Institution profile deleted');
        },
      );

      return success;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

}
