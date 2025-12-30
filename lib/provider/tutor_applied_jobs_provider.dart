import 'package:get_me_a_tutor/import_export.dart';

class TutorAppliedJobsProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<TutorAppliedJobModel> _applications = [];

  final JobApplicationService _service = JobApplicationService();

  bool get isLoading => _isLoading;
  List<TutorAppliedJobModel> get applications => _applications;

  Future<void> fetchMyApplications(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.token == null) return;

    _isLoading = true;
    notifyListeners();

    _applications = await _service.fetchMyApplications(
      context: context,
      token: auth.token!,
    );

    _isLoading = false;
    notifyListeners();
  }
}
