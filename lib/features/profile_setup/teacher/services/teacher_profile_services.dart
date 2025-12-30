import 'package:get_me_a_tutor/import_export.dart';

class TeacherProfileServices {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> upsertTeacherProfile({
    required BuildContext context,
    required String token,
    required String bio,
    required int experienceYears,
    required List<String> subjects,
    required List<int> classes,
    required List<String> languages,
    required String city,
    required bool removePhoto,
    required bool removeResume,
    required bool removeDemoVideo,
    required Map<String, int>? expectedSalary,
    required String availability,

    required bool isPublic,
    required List<String> tags,

    required File? resume,
    required File? photo,
    required File? demoVideo,
  }) async {
    try {
      final formData = FormData();

      // ───────── TEXT FIELDS ─────────
      formData.fields
        ..add(MapEntry('bio', bio))
        ..add(MapEntry('experienceYears', experienceYears.toString()))
        ..add(MapEntry('city', city))
        ..add(MapEntry('availability', availability))
        ..add(MapEntry('isPublic', isPublic.toString()));

      for (final s in subjects) {
        formData.fields.add(MapEntry('subjects[]', s));
      }

      for (final c in classes) {
        formData.fields.add(MapEntry('classes[]', c.toString()));
      }

      for (final l in languages) {
        formData.fields.add(MapEntry('languages[]', l));
      }

      for (final t in tags) {
        formData.fields.add(MapEntry('tags[]', t));
      }

      if (expectedSalary != null) {
        formData.fields.add(
          MapEntry('expectedSalary[min]', expectedSalary['min'].toString()),
        );
        formData.fields.add(
          MapEntry('expectedSalary[max]', expectedSalary['max'].toString()),
        );
      }
      formData.fields.add(MapEntry('removePhoto', removePhoto.toString()));
      formData.fields.add(MapEntry('removeResume', removeResume.toString()));
      formData.fields.add(MapEntry('removeDemoVideo', removeDemoVideo.toString()));

      // ───────── FILES ─────────
      if (resume != null) {
        formData.files.add(
          MapEntry(
            'resume',
            await MultipartFile.fromFile(resume.path),
          ),
        );
      }

      if (photo != null) {
        formData.files.add(
          MapEntry(
            'photo',
            await MultipartFile.fromFile(photo.path),
          ),
        );
      }

      if (demoVideo != null) {
        formData.files.add(
          MapEntry(
            'demoVideo',
            await MultipartFile.fromFile(demoVideo.path),
          ),
        );
      }

      // ───────── REQUEST ─────────
      final response = await _dio.post(
        '${GlobalVariables.baseUrl}/profile/teacher',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      print(response.data);
      showSnackBar(
        context,
        response.data['message'] ?? 'Profile saved',
      );

      return response.data;
    } catch (e) {

      showSnackBar(context, 'Error: ${e.toString()}');
      return null;
    }
  }
}
