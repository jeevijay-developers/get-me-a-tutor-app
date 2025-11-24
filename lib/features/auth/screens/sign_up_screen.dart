import 'package:get_me_a_tutor/import_export.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signUpScreen';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedRole;
  final _formKey = GlobalKey<FormState>();
  final List<String> _roles = ['Student', 'Parent', 'Teacher', 'Institution'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
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
                        text: "Get Me A Tutor",
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
                        text: "Sign up & begin your journey",
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
                                      "Sign up with Google",
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
                          // Name Field
                          SecondaryText(text: "Name", size: 14 * scaleFactor),
                          SizedBox(height: 6),
                          CustomTextField(
                            controller: _nameController,
                            hintText: "Enter your name",
                          ),

                          SizedBox(height: detailsSectionGap),

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
                          SecondaryText(
                            text: "Phone Number",
                            size: 14 * scaleFactor,
                          ),
                          SizedBox(height: 6),

                          CustomTextField(
                            controller: _phoneController,
                            hintText: "Enter your contact number",
                            prefixIcon: Icons.phone,
                            validator: (val) {
                              if (val == null || val.isEmpty)
                                return "Enter your phone number";
                              if (val.length < 10)
                                return "Enter a valid 10 digit phone number";
                              return null;
                            },
                          ),

                          SizedBox(height: detailsSectionGap),
                          // Role Dropdown
                          SecondaryText(
                            text: "Select your role",
                            size: 14 * scaleFactor,
                          ),
                          SizedBox(height: 6),

                          CustomDropdown(
                            value: _selectedRole,
                            items: _roles,
                            hintText: "Select your role",
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value;
                              });
                            },
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
                            hintText: "Create a strong password",
                            prefixIcon: Icons.lock,
                            isPassword: true,
                            validator: (val) {
                              if (val == null || val.isEmpty)
                                return "Enter your password";
                              if (val.length < 6)
                                return "Password must be at least 6 characters";
                              return null;
                            },
                          ),

                          SizedBox(height: detailsSectionGap),

                          // Confirm Password Field
                          SecondaryText(
                            text: "Confirm Password",
                            size: 14 * scaleFactor,
                          ),
                          SizedBox(height: 6),

                          CustomTextField(
                            controller: _confirmPasswordController,
                            hintText: "Re-type your password",
                            prefixIcon: Icons.lock,
                            isPassword: true,
                            validator: (val) {
                              if (val == null || val.isEmpty)
                                return "Confirm your password";
                              if (val != _passwordController.text)
                                return "Passwords do not match";
                              return null;
                            },
                          ),
                          SizedBox(height: detailsSectionGap),
                          Center(
                            child: Consumer<AuthProvider>(
                              builder: (context, authProvider, _) {
                                return authProvider.isLoading
                                    ? const Loader()
                                    : CustomButton(
                                        text: "Sign up",
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

                                            bool success = await authProvider
                                                .signUp(
                                                  name: _nameController.text
                                                      .trim(),
                                                  email: _emailController.text
                                                      .trim(),
                                                  phone: _phoneController.text
                                                      .trim(),
                                                  password: _passwordController
                                                      .text
                                                      .trim(),
                                                  role: _selectedRole ?? '',
                                                  context: context,
                                                );

                                            if (success) {
                                              Navigator.pushNamed(
                                                context,
                                                OtpVerifyScreen.routeName,
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
