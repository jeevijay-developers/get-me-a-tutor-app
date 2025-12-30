import 'package:get_me_a_tutor/import_export.dart';

class HomeScreenNew extends StatelessWidget {
  static const String routeName = '/homeScreenNew';
  const HomeScreenNew({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // Base design width is 393px, calculate responsive dimensions
    final scaleFactor = screenWidth / 393;

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                
                // Graduation Cap Icon
                Icon(
                  Icons.school,
                  size: 60 * scaleFactor,
                  color: const Color(0xFF4285F4), // Bright blue
                ),
                
                SizedBox(height: 12 * scaleFactor),
                
                // Tagline "GET ME A TUTOR"
                SecondaryText(
                  text: "GET ME A TUTOR",
                  size: 15 * scaleFactor,
                ),
                
                SizedBox(height: 24 * scaleFactor),
                
                // Main Headline "Hire. Teach. Grow."
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 36 * scaleFactor,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(
                        text: "Hire. Teach.\n",
                        style: const TextStyle(color: Color(0xFF1A1A1A)), // Dark gray/black
                      ),
                      TextSpan(
                        text: "Grow.",
                        style: const TextStyle(color: Color(0xFF999999)), // Lighter gray
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24 * scaleFactor),
                
                // Abstract Geometric Network Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12 * scaleFactor),
                  child: Image.asset(
                    'assets/home.png', // Replace with your image URL
                    width: double.infinity,
                    height: 200 * scaleFactor,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 250 * scaleFactor,
                        color: const Color(0xFF1B998B),
                        child: const Center(
                          child: Icon(Icons.image, color: Colors.white70),
                        ),
                      );
                    },
                  ),
                ),
                
                SizedBox(height: 70 * scaleFactor),
                
                // "Join Get me a Tutor" Button
                CustomButton(
                  text: "Join Get me a Tutor",
                  onTap: () {
                    Navigator.pushNamed(context, SelectRoleScreen.routeName);
                  },
                ),
                
                SizedBox(height: 24 * scaleFactor),
                
                // "Already have an account? Login"
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SecondaryText(
                      text: "Already have an account? ",
                      size: 14 * scaleFactor,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, LoginScreenNew.routeName);
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.inter(
                          fontSize: 14 * scaleFactor,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4285F4), // Bright blue
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: screenHeight * 0.05),
                
                // Privacy Policy and Terms of Service links
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Navigate to privacy policy
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8 * scaleFactor,
                          vertical: 4 * scaleFactor,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: SecondaryText(
                        text: "Privacy Policy",
                        size: 12 * scaleFactor,
                      ),
                    ),
                    Text(
                      "  •  ",
                      style: GoogleFonts.inter(
                        fontSize: 12 * scaleFactor,
                        color: const Color(0xFF999999),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to terms of service
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8 * scaleFactor,
                          vertical: 4 * scaleFactor,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: SecondaryText(
                        text: "Terms of Service",
                        size: 12 * scaleFactor,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 20 * scaleFactor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
