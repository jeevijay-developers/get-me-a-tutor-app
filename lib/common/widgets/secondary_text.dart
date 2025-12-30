import 'package:get_me_a_tutor/import_export.dart';

class SecondaryText extends StatelessWidget {
  final String text;
  final double size;
  final TextAlign align;
  const SecondaryText({
    super.key,
    required this.text,
    required this.size,
    this.align = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.roboto(
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: GlobalVariables.secondaryTextColor,
      ),
    );
  }
}
