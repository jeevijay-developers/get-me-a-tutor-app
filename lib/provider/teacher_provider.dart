import 'package:get_me_a_tutor/import_export.dart';

class TeacherProvider extends ChangeNotifier {
  final TeacherServices _services = TeacherServices();

  TeacherModel? _teacher;
  bool _isLoading = false;

  TeacherModel? get teacher => _teacher;
  bool get isLoading => _isLoading;

  Future<void> fetchTeacherProfile(BuildContext context,String userId) async {
    _isLoading = true;
    notifyListeners();

    _teacher = await _services.fetchTeacherProfile(
      context: context,
      userId: userId
    );

    _isLoading = false;
    notifyListeners();
  }

  void clearTeacher() {
    _teacher = null;
    notifyListeners();
  }
}
