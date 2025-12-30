import 'package:get_me_a_tutor/import_export.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required BuildContext context,
  required http.Response response,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
    case 201:
      onSuccess();
      break;

    case 401:
      _forceLogout(context);
      break;

    default:
      final resBody = jsonDecode(response.body);
      showSnackBar(
        context,
        resBody['message'] ?? 'Something went wrong',
      );
  }
}

void _forceLogout(BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  await authProvider.logout(context: context);

  Navigator.pushNamedAndRemoveUntil(
    context,
    HomeScreenNew.routeName,
        (route) => false,
  );

  showSnackBar(context, 'Session expired. Please login again.');
}
