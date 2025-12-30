import 'package:get_me_a_tutor/import_export.dart';
class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: GlobalVariables.selectedColor,
      ),
    );
  }
}
