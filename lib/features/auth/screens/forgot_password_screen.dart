import 'package:get_me_a_tutor/import_export.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgotPasswordScreen';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
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
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    SizedBox(height: 24 * scaleFactor),

                    /// Title
                    PrimaryText(
                      text: "Forgot password",
                      size: 28 * scaleFactor,
                    ),

                    SizedBox(height: 8 * scaleFactor),

                    /// Subtitle
                    SecondaryText(
                      text:
                      "Enter your registered email address and we’ll send you a password reset link.",
                      size: 14 * scaleFactor,
                    ),

                    SizedBox(height: 32 * scaleFactor),

                    /// Email field
                    CustomTextField(
                      controller: _emailController,
                      hintText: "Email Address",
                      prefixIcon: Icons.email,
                    ),

                    SizedBox(height: 32 * scaleFactor),

                    /// Send reset link button
                    Center(
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          return authProvider.isLoading
                              ? const Loader()
                              : CustomButton(
                            text: "Send Reset Link",
                            onTap: () async {
                              FocusScope.of(context).unfocus();

                              if (_formKey.currentState!.validate()) {
                                final success =
                                await authProvider.forgotPassword(
                                  email:
                                  _emailController.text.trim(),
                                  context: context,
                                );

                                if (success) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                          );
                        },
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
