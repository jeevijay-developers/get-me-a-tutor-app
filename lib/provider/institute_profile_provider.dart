import 'package:get_me_a_tutor/import_export.dart';

class InstituteProfileProvider extends ChangeNotifier {
  bool _isLoading = false;

  final InstituteProfileServices _services =
  InstituteProfileServices();

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> createInstituteProfile({
    required BuildContext context,

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
    final authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) {
      showSnackBar(context, 'User not authenticated');
      return false;
    }

    setLoading(true);

    final result = await _services.createInstituteProfile(
      context: context,
      token: authProvider.token!,

      institutionName: institutionName,
      institutionType: institutionType,
      about: about,

      email: email,
      phone: phone,
      website: website,

      address: address,

      logo: logo,
      galleryImages: galleryImages,
    );

    setLoading(false);

    return result != null;
  }
}
