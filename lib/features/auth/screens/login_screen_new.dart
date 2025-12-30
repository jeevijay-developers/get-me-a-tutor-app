import 'package:get_me_a_tutor/import_export.dart';

class LoginScreenNew extends StatefulWidget {
  static const String routeName = '/loginScreenNew';
  const LoginScreenNew({super.key});

  @override
  State<LoginScreenNew> createState() => _LoginScreenNewState();
}

class _LoginScreenNewState extends State<LoginScreenNew> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 393;

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16 * scaleFactor),

                    /// Back arrow
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.black,
                        size: 40,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    SizedBox(height: 24 * scaleFactor),

                    /// Title
                    PrimaryText(text: "Welcome back", size: 28 * scaleFactor),

                    SizedBox(height: 8 * scaleFactor),

                    /// Subtitle
                    SecondaryText(
                      text: "Login to continue your learning journey.",
                      size: 14 * scaleFactor,
                    ),

                    SizedBox(height: 32 * scaleFactor),

                    /// Email
                    CustomTextField(
                      controller: _emailController,
                      hintText: "Email Address",
                      prefixIcon: Icons.email,
                    ),

                    SizedBox(height: 20 * scaleFactor),

                    /// Password
                    CustomTextField(
                      controller: _passwordController,
                      hintText: "Password",
                      prefixIcon: Icons.lock,
                      isPassword: true,
                    ),

                    SizedBox(height: 12 * scaleFactor),

                    /// Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ForgotPasswordScreen.routeName,
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: GoogleFonts.roboto(
                            fontSize: 13 * scaleFactor,
                            fontWeight: FontWeight.w400,
                            color: GlobalVariables.selectedColor,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24 * scaleFactor),

                    /// Login button
                    Center(
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          return authProvider.isLoading
                              ? const Loader()
                              : CustomButton(
                                  text: "Log In",
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();

                                    if (_formKey.currentState!.validate()) {
                                      final authProvider =
                                          Provider.of<AuthProvider>(
                                            context,
                                            listen: false,
                                          );

                                      final role = await authProvider.login(
                                        identifier: _emailController.text
                                            .trim(),
                                        password: _passwordController.text
                                            .trim(),
                                        context: context,
                                      );
                                      if (role != null) {
                                        switch (role) {
                                          case 'student':
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              StudentDashboard.routeName,
                                              (route) => false,
                                            );
                                            break;
                                          case 'tutor':
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              TeacherDashboard.routeName,
                                              (route) => false,
                                            );
                                            break;

                                          case 'parent':
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              ParentDashboard.routeName,
                                              (route) => false,
                                            );
                                            break;

                                          case 'institute':
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              InstituteDashboard.routeName,
                                              (route) => false,
                                            );
                                            break;
                                        }
                                      }
                                    }
                                  },
                                );
                        },
                      ),
                    ),

                    SizedBox(height: 24 * scaleFactor),

                    /// Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey[300], thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16 * scaleFactor,
                          ),
                          child: SecondaryText(
                            text: "Or sign in with",
                            size: 12 * scaleFactor,
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey[300], thickness: 1),
                        ),
                      ],
                    ),

                    SizedBox(height: 24 * scaleFactor),

                    /// Google & Apple
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Google login
                            },
                            child: Container(
                              height: 50 * scaleFactor,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/google.png',
                                    height: 20 * scaleFactor,
                                    width: 20 * scaleFactor,
                                    errorBuilder: (_, __, ___) {
                                      return Text(
                                        'G',
                                        style: GoogleFonts.roboto(
                                          fontSize: 18 * scaleFactor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 8 * scaleFactor),
                                  PrimaryText(
                                    text: "Google",
                                    size: 14 * scaleFactor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12 * scaleFactor),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Apple login
                            },
                            child: Container(
                              height: 50 * scaleFactor,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.apple,
                                    size: 20 * scaleFactor,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 8 * scaleFactor),
                                  PrimaryText(
                                    text: "Apple",
                                    size: 14 * scaleFactor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32 * scaleFactor),

                    /// Sign up redirect
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SecondaryText(
                            text: "Don’t have an account? ",
                            size: 14 * scaleFactor,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                SelectRoleScreen.routeName,
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.roboto(
                                fontSize: 14 * scaleFactor,
                                fontWeight: FontWeight.w400,
                                color: GlobalVariables.selectedColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32 * scaleFactor),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
