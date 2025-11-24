import 'package:get_me_a_tutor/import_export.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/loginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    // Base design width is 393px, calculate responsive dimensions
    final scaleFactor = screenWidth / 393;

    // Logo dimensions
    final logoSize = 120 * scaleFactor;
    final logoBorderRadius = 24 * scaleFactor;

    // Text dimensions
    final primaryTextWidth = 297 * scaleFactor;
    final primaryTextHeight = 36 * scaleFactor;
    final secondaryTextWidth = 297 * scaleFactor;
    final secondaryTextHeight = 24 * scaleFactor;

    // Details section dimensions
    final detailsSectionGap = 17 * scaleFactor;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top padding
                  SizedBox(height: 40 * scaleFactor),
                  // Logo
                  Container(
                    width: logoSize,
                    height: logoSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5DC),
                      borderRadius: BorderRadius.circular(logoBorderRadius),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.school,
                        size: logoSize * 0.5,
                        color: const Color(0xFF1E3A8A), // Dark blue
                      ),
                    ),
                  ),

                  SizedBox(height: 24 * scaleFactor),

                  // Title
                  SizedBox(
                    width: primaryTextWidth,
                    child: Center(
                      child: PrimaryText(
                        text: "Welcome Back",
                        size: primaryTextHeight * 0.8,
                      ),
                    ),
                  ),

                  SizedBox(height: 8 * scaleFactor),

                  // Subtitle
                  SizedBox(
                    width: secondaryTextWidth,
                    child: Center(
                      child: SecondaryText(
                        text: "Login to continue",
                        size: secondaryTextHeight * 0.8,
                      ),
                    ),
                  ),

                  SizedBox(height: 32 * scaleFactor),

                  // Form Section
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25 * scaleFactor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Google Sign Up Button
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4285F4),
                              borderRadius: BorderRadius.circular(7.69),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(7.69),
                              onTap: () {},
                              child: Row(
                                children: [
                                  const SizedBox(width: 5),

                                  // Google white box
                                  Container(
                                    height: 46,
                                    width: 46,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7.69),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/google_logo.png',
                                        height: 30,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      "Login with Google",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: detailsSectionGap),

                          // OR text
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: SecondaryText(
                                  text: "or",
                                  size: 15 * scaleFactor,
                                ),
                              ),

                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: detailsSectionGap,
                          ), // same as detailsSectionGap
                          // Email Field
                          SecondaryText(
                            text: "Email Address",
                            size: 14 * scaleFactor,
                          ),
                          SizedBox(height: 6),

                          CustomTextField(
                            controller: _emailController,
                            hintText: "Enter your email address",
                            prefixIcon: Icons.email,
                          ),

                          SizedBox(height: detailsSectionGap),

                          // Password field
                          SecondaryText(
                            text: "Password",
                            size: 14 * scaleFactor,
                          ),
                          SizedBox(height: 6),

                          CustomTextField(
                            controller: _passwordController,
                            hintText: "Enter your password",
                            prefixIcon: Icons.lock,
                            isPassword: true,
                          ),

                          SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {},
                              child: SecondaryText(
                                text: "Forgot password?",
                                size: 15 * scaleFactor,
                              ),
                            ),
                          ),
                          Center(
                            child: Consumer<AuthProvider>(
                              builder: (context, authProvider, _) {
                                return authProvider.isLoading
                                    ? const Loader()
                                    : CustomButton(
                                        text: "Login",
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();

                                          if (_formKey.currentState!
                                              .validate()) {
                                            final authProvider =
                                                Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false,
                                                );

                                            final success = await authProvider
                                                .login(
                                                  identifier: _emailController
                                                      .text
                                                      .trim(),
                                                  password: _passwordController
                                                      .text
                                                      .trim(),
                                                  context: context,
                                                );

                                            if (success) {
                                              // Navigate to Dashboard and remove all previous routes
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Dashboard.routeName,
                                                (route) => false,
                                              );
                                            }
                                          }
                                        },
                                      );
                              },
                            ),
                          ),
                          SizedBox(height: detailsSectionGap),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
