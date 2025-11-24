import 'package:http/http.dart' as http;
import 'package:get_me_a_tutor/import_export.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
    case 201:
      onSuccess();
      break;
    case 400:
    case 401:
    case 403:
    case 404:
    case 500:
      final message = jsonDecode(response.body)['message'] ?? 'Error occurred';
      showSnackBar(context, message);
      break;
    default:
      showSnackBar(context, 'An error occurred: ${response.body}');
  }
}