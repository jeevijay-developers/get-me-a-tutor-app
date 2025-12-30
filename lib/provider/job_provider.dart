import 'package:get_me_a_tutor/import_export.dart';

class JobProvider extends ChangeNotifier {
  final JobServices _services = JobServices();

  bool _isLoading = false;
  List<JobModel> _jobs = [];
  List<JobModel> _tutorJobs = [];

  bool get isLoading => _isLoading;
  List<JobModel> get jobs => _jobs;
  List<JobModel> get tutorJobs => _tutorJobs;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  /// CREATE JOB
  Future<bool> createJob({
    required BuildContext context,
    required Map<String, dynamic> body,
  }) async {
    final authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) {
      showSnackBar(context, 'Not authenticated');
      return false;
    }

    _setLoading(true);

    final success = await _services.createJob(
      context: context,
      token: authProvider.token!,
      body: body,
    );

    _setLoading(false);
    return success;
  }

  /// FETCH MY JOBS
  Future<void> fetchMyJobs(BuildContext context) async {
    final authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) return;

    _setLoading(true);

    _jobs = await _services.getMyJobs(
      context: context,
      token: authProvider.token!,
    );

    _setLoading(false);
  }
  Future<bool> closeJob({
    required BuildContext context,
    required String jobId,
  }) async {
    final authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) {
      showSnackBar(context, 'Not authenticated');
      return false;
    }

    _setLoading(true);

    final success = await _services.closeJob(
      context: context,
      token: authProvider.token!,
      jobId: jobId,
    );

    if (success) {
      _jobs.removeWhere((j) => j.id == jobId);
      notifyListeners();
    }

    _setLoading(false);
    return success;
  }
  Future<bool> updateJob({
    required BuildContext context,
    required String jobId,
    required Map<String, dynamic> body,
  }) async {
    final authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) {
      showSnackBar(context, 'Not authenticated');
      return false;
    }

    _setLoading(true);

    final success = await _services.updateJob(
      context: context,
      token: authProvider.token!,
      jobId: jobId,
      body: body,
    );

    if (success) {
      final index = _jobs.indexWhere((j) => j.id == jobId);
      if (index != -1) {
        _jobs[index] = _jobs[index].copyWith(
          title: body['title'],
          location: body['location'],
          status: body['status'],
        );
      }
      notifyListeners();
    }

    _setLoading(false);
    return success;
  }
  Future<void> fetchTutorJobs(BuildContext context) async {
    final auth =
    Provider.of<AuthProvider>(context, listen: false);

    final token = auth.token;
    _isLoading = true;
    notifyListeners();

    _tutorJobs = await _services.getTutorJobs(
      context: context,
      token: token??'',
    );

    _isLoading = false;
    notifyListeners();
  }

  void clearTutorJobs() {
    _tutorJobs = [];
    notifyListeners();
  }
}
