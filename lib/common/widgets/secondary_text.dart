import 'package:get_me_a_tutor/import_export.dart';

class SecondaryText extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  const SecondaryText({
    super.key,
    required this.text,
    required this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color ?? GlobalVariables.secondaryTextColor,
      ),
    );
  }
}
