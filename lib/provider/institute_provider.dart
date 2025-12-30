import 'package:get_me_a_tutor/import_export.dart';

class InstituteProvider extends ChangeNotifier {
  bool _isLoading = false;
  InstitutionModel? _institution;

  final InstituteServices _services = InstituteServices();

  bool get isLoading => _isLoading;
  InstitutionModel? get institution => _institution;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Fetch logged-in institute profile
  Future<void> fetchMyInstitute(
      BuildContext context, {
        bool silent = false,
      }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // 🔴 ADD THIS
    if (authProvider.role != 'institute') {
      return;
    }

    if (authProvider.token == null) {
      showSnackBar(context, 'User not authenticated');
      return;
    }

    setLoading(true);

    final result = await _services.getMyInstitute(
      context: context,
      token: authProvider.token!,
    );

    setLoading(false);

    if (result == null || result['institution'] == null) {
      if (!silent) {
        showSnackBar(context, 'Institute profile not found');
      }
      _institution = null;
      notifyListeners();
      return;
    }

    _institution = InstitutionModel.fromJson(result['institution']);
    authProvider.setHasInstituteProfile(true);
    notifyListeners();
  }

  /// Clear on logout
  void clearInstitute() {
    _institution = null;
    notifyListeners();
  }

  Future<bool> updateInstituteProfile({
    required BuildContext context,
    required Map<String, dynamic> body,
    File? logo,
    List<File>? galleryImages,
  }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) return false;

    setLoading(true);

    final success = await _services.updateInstituteProfile(
      instituteId: _institution!.id,
      context: context,
      token: authProvider.token!,
      body: body,
      logo: logo,
      galleryImages: galleryImages,

    );

    if (success) {
      await fetchMyInstitute(context);
    }

    setLoading(false);
    return success;
  }
  Future<bool> deleteInstitute({
    required BuildContext context,
  }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) return false;

    setLoading(true);

    final success = await _services.deleteInstituteProfile(
      instituteId: _institution!.id,
      context: context,
      token: authProvider.token!,
    );

    if (success) {
      _institution = null;
      notifyListeners();
    }

    setLoading(false);
    return success;
  }

}
