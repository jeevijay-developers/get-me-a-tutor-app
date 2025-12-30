import 'package:get_me_a_tutor/import_export.dart';

class SignupSuccessScreen extends StatefulWidget {
  static const String routeName = '/SignUpSuccess';
  final String role;
  const SignupSuccessScreen({super.key, required this.role});

  @override
  State<SignupSuccessScreen> createState() => _SignupSuccessScreenState();
}

class _SignupSuccessScreenState extends State<SignupSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = size.width / 393; // base design width
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24 * scale),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 160 * scale,
                    width: 160 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: GlobalVariables.selectedColor.withOpacity(0.15),
                    ),
                  ),
                  Container(
                    height: 110 * scale,
                    width: 110 * scale,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: GlobalVariables.selectedColor,
                    ),
                    child: const Center(
                      child: Icon(Icons.check, size: 48, color: Colors.white),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32 * scale),
              PrimaryText(text: "You're all set!", size: 28 * scale),
              SizedBox(height: 12 * scale),
              SecondaryText(
                align: TextAlign.center,
                text:
                    "Your profile has been successfully created.\n"
                    "Let's find the perfect match for your\nlearning goals.",
                size: 16 * scale,
              ),
              const Spacer(flex: 3),
              CustomButton(
                text: "Continue to Dashboard",
                onTap: () {
                  switch (widget.role) {
                    case 'institute':
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        InstituteProfileCreateScreen.routeName,
                        (route) => false,
                      );
                      break;

                    case 'student':
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        StudentProfileScreen.routeName,
                        (route) => false,
                      );
                      break;

                    case 'tutor':
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        TeacherProfileCreateScreen.routeName,
                        (route) => false,
                      );
                      break;

                    case 'parent':
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        ParentProfileCreateScreen.routeName,
                        (route) => false,
                      );
                      break;
                  }
                },
              ),

              SizedBox(height: 32 * scale),
            ],
          ),
        ),
      ),
    );
  }
}
