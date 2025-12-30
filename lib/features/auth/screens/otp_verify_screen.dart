import 'package:get_me_a_tutor/import_export.dart';

class OtpVerifyScreen extends StatefulWidget {
  static const String routeName = '/otpVerifyScreen';
  final String email;
  const OtpVerifyScreen({super.key, required this.email});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isResendingOtp = false;
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
    for (var controller in _emailOtpControllers) {
      controller.dispose();
    }
    for (var focusNode in _emailOtpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
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
    final scaleFactor = screenWidth / 393;

    // OTP box dimensions
    final otpBoxSize = 50 * scaleFactor;

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
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
                    // Back Button
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        size: 32 * scaleFactor,
                        color: GlobalVariables.primaryTextColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(height: 24 * scaleFactor),
                    // Title
                    PrimaryText(
                      text: 'OTP Verification',
                      size: 28 * scaleFactor,
                    ),
                    SizedBox(height: 8 * scaleFactor),
                    // Subtitle
                    SecondaryText(
                      text:
                          'Enter the OTP sent to your email address to verify your account.',
                      size: 14 * scaleFactor,
                    ),
                    SizedBox(height: 40 * scaleFactor),
                    // Instruction text
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SecondaryText(
                        text: 'Enter the OTP sent on your email',
                        size: 14 * scaleFactor,
                      ),
                    ),
                    SizedBox(height: 16 * scaleFactor),
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
                            cursorColor: GlobalVariables.secondaryTextColor,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: 24 * scaleFactor,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.primaryTextColor,
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
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12 * scaleFactor,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12 * scaleFactor,
                                ),
                                borderSide: BorderSide(
                                  color: GlobalVariables.selectedColor,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12 * scaleFactor,
                                ),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12 * scaleFactor,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) =>
                                _onEmailOtpChanged(index, value),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 8 * scaleFactor),
                    // Resend OTP
                    Align(
                      alignment: Alignment.centerRight,
                      child: _isResendingOtp
                          ? const Loader()
                          : TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () async {
                          setState(() {
                            _isResendingOtp = true;
                          });

                          final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);

                          await authProvider.resendEmailOtp(
                            context: context,
                          );

                          setState(() {
                            _isResendingOtp = false;
                          });
                        },
                        child: Text(
                          'Resend OTP',
                          style: GoogleFonts.roboto(
                            fontSize: 14 * scaleFactor,
                            fontWeight: FontWeight.w400,
                            color: GlobalVariables.selectedColor,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32 * scaleFactor),
                    // Verify Button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return authProvider.isLoading
                            ? const Loader()
                            : CustomButton(
                                text: 'Verify',
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
                                    final role = await authProvider
                                        .verifyEmailOtp(
                                          otp: otp,
                                          context: context,
                                        );

                                    if (role!=null) {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        SignupSuccessScreen.routeName,
                                        (route) => false,
                                        arguments: role,
                                      );
                                    }
                                  }
                                },
                              );
                      },
                    ),
                    SizedBox(height: 24 * scaleFactor),
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
