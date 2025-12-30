import 'package:get_me_a_tutor/import_export.dart';

class TutorSearchProvider extends ChangeNotifier {
  final TutorSearchServices _services = TutorSearchServices();

  List<TutorSearchModel> _tutors = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  List<TutorSearchModel> get tutors => _tutors;
  bool get isLoading => _isLoading;
  bool get hasSearched => _hasSearched;

  Future<void> search(BuildContext context, {String? query}) async {
    if (query == null || query.trim().isEmpty) {
      _tutors = [];
      _hasSearched = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _hasSearched = true;
    notifyListeners();

    _tutors = await _services.searchTeachers(
      context: context,
      q: query.trim(),
    );

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _tutors = [];
    _hasSearched = false;
    notifyListeners();
  }
}
