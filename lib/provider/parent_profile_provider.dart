import 'package:get_me_a_tutor/import_export.dart';

class ParentProfileProvider extends ChangeNotifier {
  final ParentProfileServices _services = ParentProfileServices();

  ParentModel? _parent;
  bool _isLoading = false;

  ParentModel? get parent => _parent;
  bool get isLoading => _isLoading;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<bool> createParentProfile({
    required BuildContext context,
    required Map<String, dynamic> body,
  }) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.token == null) return false;

    _setLoading(true);

    final result = await _services.createParentProfile(
      context: context,
      token: auth.token!,
      body: body,
    );

    _setLoading(false);

    if (result != null) {
      _parent = result;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> fetchMyParentProfile(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.token == null) return;

    _setLoading(true);
    _parent = await _services.getMyParentProfile(
      context: context,
      token: auth.token!,
    );
    _setLoading(false);
  }
  Future<bool> updateParentProfile({
    required BuildContext context,
    required Map<String, dynamic> body,
  }) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.token == null) return false;

    _setLoading(true);

    final updated = await _services.updateParentProfile(
      context: context,
      token: auth.token!,
      body: body,
    );

    _setLoading(false);

    if (updated != null) {
      _parent = updated;
      notifyListeners();
      return true;
    }
    return false;
  }
  void clearParent() {
    _parent = null;
    notifyListeners();
  }
}
