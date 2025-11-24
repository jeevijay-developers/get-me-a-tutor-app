import 'package:get_me_a_tutor/import_export.dart';

class OtpVerifyScreen extends StatefulWidget {
  static const String routeName = '/otpVerifyScreen';
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _phoneOtpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _phoneOtpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  final List<TextEditingController> _emailOtpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _emailOtpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _phoneOtpControllers) {
      controller.dispose();
    }
    for (var focusNode in _phoneOtpFocusNodes) {
      focusNode.dispose();
    }
    for (var controller in _emailOtpControllers) {
      controller.dispose();
    }
    for (var focusNode in _emailOtpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onPhoneOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _phoneOtpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _phoneOtpFocusNodes[index - 1].requestFocus();
    }
  }

  void _onEmailOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _emailOtpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _emailOtpFocusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Base design width is 393px, calculate responsive dimensions
    final scaleFactor = screenWidth / 393;

    // Icon dimensions
    final iconSize = 180 * scaleFactor;

    // Text dimensions
    final primaryTextSize = 25 * scaleFactor;
    final secondaryTextSize = 18 * scaleFactor;
    final instructionTextSize = 15 * scaleFactor;

    // OTP box dimensions
    final otpBoxSize = 40 * scaleFactor;

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
                padding: EdgeInsets.symmetric(horizontal: 25 * scaleFactor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    // Icon
                    Center(
                      child: Image.asset(
                        'assets/otp.png',
                        width: iconSize,
                        height: iconSize,
                      ),
                    ),

                    // Title
                    Center(
                      child: PrimaryText(
                        text: "Otp Verification",
                        size: primaryTextSize,
                      ),
                    ),

                    SizedBox(height: 10),
                    // Subtitle
                    Center(
                      child: SecondaryText(
                        text: "Verify your contact information",
                        size: secondaryTextSize,
                      ),
                    ),

                    SizedBox(height: 30),
                    // Instruction text
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SecondaryText(
                        text: "Enter the otp sent on your number",
                        size: instructionTextSize,
                      ),
                    ),
                    SizedBox(height: 20),
                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: otpBoxSize,
                          height: otpBoxSize,
                          child: TextFormField(
                            controller: _phoneOtpControllers[index],
                            focusNode: _phoneOtpFocusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: 24 * scaleFactor,
                              fontWeight: FontWeight.bold,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ''; // triggers red border without text
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              counterText: '',
                              isDense: true,
                              errorStyle: const TextStyle(
                                fontSize: 0,
                                height: 0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  8 * scaleFactor,
                                ),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  8 * scaleFactor,
                                ),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  8 * scaleFactor,
                                ),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  8 * scaleFactor,
                                ),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),

                            onChanged: (value) =>
                                _onPhoneOtpChanged(index, value),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {},
                        child: SecondaryText(
                          text: "Resend OTP",
                          size: 15 * scaleFactor,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SecondaryText(
                        text: "Enter the otp sent on your Email",
                        size: instructionTextSize,
                      ),
                    ),
                    SizedBox(height: 20),
                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: otpBoxSize,
                          height: otpBoxSize,
                          child: TextFormField(
                            controller: _emailOtpControllers[index],
                            focusNode: _emailOtpFocusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: 24 * scaleFactor,
                              fontWeight: FontWeight.bold,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ''; // triggers red border without text
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              counterText: '',
                              isDense: true,
                              errorStyle: const TextStyle(
                                fontSize: 0,
                                height: 0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  8 * scaleFactor,
                                ),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  8 * scaleFactor,
                                ),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  8 * scaleFactor,
                                ),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  8 * scaleFactor,
                                ),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),

                            onChanged: (value) =>
                                _onEmailOtpChanged(index, value),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {},
                        child: SecondaryText(
                          text: "Resend OTP",
                          size: 15 * scaleFactor,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    // Verify Button
                    Center(
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          return authProvider.isLoading
                              ? const Loader()
                              : CustomButton(
                                  text: "Verify",
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();

                                    if (_formKey.currentState!.validate()) {
                                      // Combine OTP digits
                                      final otp = _emailOtpControllers
                                          .map((c) => c.text)
                                          .join();

                                      final authProvider =
                                          Provider.of<AuthProvider>(
                                            context,
                                            listen: false,
                                          );
                                      final success = await authProvider
                                          .verifyEmailOtp(
                                            otp: otp,
                                            context: context,
                                          );

                                      if (success) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          LoginScreen.routeName,
                                              (route) => false,
                                        );

                                      }
                                    }
                                  },
                                );
                        },
                      ),
                    ),
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
