import 'package:get_me_a_tutor/import_export.dart';

class PrimaryText extends StatelessWidget {
  final String text;
  final double size;
  const PrimaryText({
    super.key,
    required this.text,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: GlobalVariables.primaryTextColor,
      ),
    );
  }
}

