import 'package:get_me_a_tutor/import_export.dart';

class SignUpDetailsScreen extends StatefulWidget {
  static const String routeName = '/signUpDetailsScreen';
  final String? selectedRole;
  const SignUpDetailsScreen({super.key, this.selectedRole});

  @override
  State<SignUpDetailsScreen> createState() => _SignUpDetailsScreenState();
}

class _SignUpDetailsScreenState extends State<SignUpDetailsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 393;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
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
                    // Back arrow
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.black,size: 40,),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(height: 24 * scaleFactor),
                    // Title
                    PrimaryText(
                      text: "Let's get started",
                      size: 28 * scaleFactor,
                    ),
                    SizedBox(height: 8 * scaleFactor),
                    // Subtitle
                    SecondaryText(
                      text: "Create an account to find the perfect tutor.",
                      size: 14 * scaleFactor,
                    ),
                    SizedBox(height: 32 * scaleFactor),

                    // Role field
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SecondaryText(text: "Role", size: 14 * scaleFactor),
                          SizedBox(height: 6 * scaleFactor),
                          PrimaryText(
                            text: widget.selectedRole ?? "Student",
                            size: 16 * scaleFactor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20 * scaleFactor),
                    // Full Name field
                    CustomTextField(
                      controller: _nameController,
                      hintText: "Full Name",
                      prefixIcon: Icons.person,
                    ),
                    SizedBox(height: 20 * scaleFactor),
                    // Email Address field
                    CustomTextField(
                      controller: _emailController,
                      hintText: "Email Address",
                      prefixIcon: Icons.email,
                    ),
                    SizedBox(height: 20 * scaleFactor),
                    // Phone Number field
                    CustomTextField(
                      controller: _phoneController,
                      hintText: "Phone Number",
                      prefixIcon: Icons.phone,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Enter your phone number";
                        }
                        if (val.length != 10) {
                          return "Phone number must be exactly 10 digits";
                        }
                        if (!RegExp(r'^\d+$').hasMatch(val)) {
                          return "Phone number must contain only digits";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20 * scaleFactor),
                    // Password field
                    CustomTextField(
                      controller: _passwordController,
                      hintText: "Password",
                      prefixIcon: Icons.lock,
                      isPassword: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Enter your password";
                        }
                        if (val.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20 * scaleFactor),
                    // Confirm Password field
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: "Confirm Password",
                      prefixIcon: Icons.lock,
                      isPassword: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please confirm your password";
                        }
                        if (val != _passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16 * scaleFactor),
                    // Terms and Privacy Policy
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          SecondaryText(
                            text: "By signing up, you agree to our ",
                            size: 12 * scaleFactor,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Terms of Service",
                              style: GoogleFonts.roboto(
                                fontSize: 12 * scaleFactor,
                                fontWeight: FontWeight.w400,
                                color: GlobalVariables.selectedColor,
                              ),
                            ),
                          ),
                          SecondaryText(text: " & ", size: 12 * scaleFactor),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Privacy Policy",
                              style: GoogleFonts.roboto(
                                fontSize: 12 * scaleFactor,
                                fontWeight: FontWeight.w400,
                                color: GlobalVariables.selectedColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24 * scaleFactor),
                    // Sign Up button
                    Center(
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          return authProvider.isLoading
                              ? const Loader()
                              : CustomButton(
                                  text: "Sign Up",
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();

                                    if (_formKey.currentState!.validate()) {
                                      final authProvider =
                                          Provider.of<AuthProvider>(
                                            context,
                                            listen: false,
                                          );

                                      bool success = await authProvider.signUp(
                                        name: _nameController.text.trim(),
                                        email: _emailController.text.trim(),
                                        phone: _phoneController.text.trim(),
                                        password: _passwordController.text
                                            .trim(),
                                        role: widget.selectedRole!,
                                        context: context,
                                      );

                                      if (success) {
                                        Navigator.pushNamed(
                                          context,
                                          OtpVerifyScreen.routeName,
                                          arguments: _emailController.text.trim(),
                                        );

                                      }
                                    }
                                  },
                                );
                        },
                      ),
                    ),
                    SizedBox(height: 24 * scaleFactor),
                    // Divider with "Or sign up with"
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
                            text: "Or sign up with",
                            size: 12 * scaleFactor,
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey[300], thickness: 1),
                        ),
                      ],
                    ),
                    SizedBox(height: 24 * scaleFactor),
                    // Google and Apple buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Handle Google sign up
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
                                    'assets/images/google_logo.png',
                                    height: 20 * scaleFactor,
                                    width: 20 * scaleFactor,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Text(
                                        'G',
                                        style: GoogleFonts.roboto(
                                          fontSize: 18 * scaleFactor,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
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
                              // Handle Apple sign up
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
                    // Already have an account
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SecondaryText(
                            text: "Already have an account? ",
                            size: 14 * scaleFactor,
                          ),
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Navigator.pushNamed(context, LoginScreenNew.routeName);
                            },
                            child: Text(
                              "Log In",
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
