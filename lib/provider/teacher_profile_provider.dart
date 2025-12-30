import 'package:get_me_a_tutor/import_export.dart';

class TeacherProfileProvider extends ChangeNotifier {
  bool _isLoading = false;

  final TeacherProfileServices _services = TeacherProfileServices();

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> upsertTeacherProfile({
    required BuildContext context,
    required bool removePhoto,
    required bool removeResume,
    required bool removeDemoVideo,
    required String bio,
    required int experienceYears,
    required List<String> subjects,
    required List<int> classes,
    required List<String> languages,
    required String city,
    required Map<String, int>? expectedSalary,
    required String availability,
    required bool isPublic,
    required List<String> tags,
    required File? resume,
    required File? photo,
    required File? demoVideo,
  }) async {
    final authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) {
      showSnackBar(context, 'User not authenticated');
      return false;
    }

    setLoading(true);

    final result = await _services.upsertTeacherProfile(
      context: context,
      token: authProvider.token!,

      bio: bio,
      experienceYears: experienceYears,
      subjects: subjects,
      classes: classes,
      languages: languages,
      city: city,
      expectedSalary: expectedSalary,
      availability: availability,
      isPublic: isPublic,
      tags: tags,
removeDemoVideo: removeDemoVideo,
      removePhoto: removePhoto,
      removeResume: removeResume,
      resume: resume,
      photo: photo,
      demoVideo: demoVideo,
    );

    setLoading(false);
    if (result != null) {
      final auth =
      Provider.of<AuthProvider>(context, listen: false);
      // 🔥 THIS IS THE MISSING PIECE
      await Provider.of<TeacherProvider>(
        context,
        listen: false,
      ).fetchTeacherProfile(context, auth.userId!);
      return true;
    }
    return false;
  }
}
