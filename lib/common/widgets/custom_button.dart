import 'package:get_me_a_tutor/import_export.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 393;
    final buttonHeight = 56 * scaleFactor;
    
    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: GlobalVariables.selectedColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30 * scaleFactor),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 18 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}