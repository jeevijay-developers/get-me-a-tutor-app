import 'package:get_me_a_tutor/import_export.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/homeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Base design width is 393px, calculate responsive dimensions
    final scaleFactor = screenWidth / 393;
    // Text column dimensions
    final textColumnPadding = 20 * scaleFactor;
    final textGap = 12 * scaleFactor;
    final textInnerWidth = 329 * scaleFactor;
    // Button row dimensions
    final buttonRowGap = 7 * scaleFactor;
    final bottomPadding = 20 * scaleFactor;
    final imageTopPadding = 12 * scaleFactor;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text Column
            Padding(
              padding: EdgeInsets.all(textColumnPadding),
              child: SizedBox(
                width: textInnerWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main text
                    PrimaryText(
                      text:
                          "Empower teachers.\nTransform\neducation. Grow\ntogether.",
                      size: 36 * scaleFactor,
                    ),
                    SizedBox(height: textGap),
                    // Secondary text
                    SecondaryText(
                      text:
                          "A revolutionary platform connecting\neducators worldwide. Earn credits, showcase\nexpertise, and unlock new teaching\nopportunities.",
                      size: 16 * scaleFactor,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: imageTopPadding),

            // Image - takes remaining space
            Expanded(
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Image.asset('assets/teacher.png', fit: BoxFit.cover),
              ),
            ),

            // Button Row
            Padding(
              padding: EdgeInsets.only(
                top: 12 * scaleFactor,
                bottom: bottomPadding,
                left: textColumnPadding,
                right: textColumnPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: "Login",
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onTap: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                  ),
                  SizedBox(width: buttonRowGap),
                  CustomButton(
                    text: "Register",
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    onTap: () {
                      Navigator.pushNamed(context, SignUpScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
