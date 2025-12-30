import 'package:get_me_a_tutor/import_export.dart';

class ParentProfileCreateScreen extends StatefulWidget {
  static const String routeName = '/parentProfileCreateScreen';

  const ParentProfileCreateScreen({super.key});

  @override
  State<ParentProfileCreateScreen> createState() =>
      _ParentProfileCreateScreenState();
}

class _ParentProfileCreateScreenState extends State<ParentProfileCreateScreen> {
  int currentStep = 0;

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    emailCtrl.text = auth.email ?? '';
    phoneCtrl.text = auth.phone ?? '';
  }

  Future<void> onContinue() async {
    if (currentStep == 0 && !_step1Key.currentState!.validate()) return;
    if (currentStep == 1 && !_step2Key.currentState!.validate()) return;

    if (currentStep < 1) {
      setState(() => currentStep++);
    } else {
      final provider =
      Provider.of<ParentProfileProvider>(context, listen: false);

      final success = await provider.createParentProfile(
        context: context,
        body: {
          'name': nameCtrl.text.trim(),
          'email': emailCtrl.text.trim(),
          'phone': phoneCtrl.text.trim(),
          'city': cityCtrl.text.trim(),
          'address': {
            'street': streetCtrl.text.trim(),
            'city': cityCtrl.text.trim(),
            'state': stateCtrl.text.trim(),
            'pincode': pincodeCtrl.text.trim(),
          },
        },
      );

      if (success) {
        showSnackBar(context, 'Parent profile created');
        context.read<AuthProvider>().setHasParentProfile(true);
        Navigator.pushNamedAndRemoveUntil(
          context,
          ParentDashboard.routeName,
              (_) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: currentStep > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => setState(() => currentStep--),
        )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: _buildStep()),
            Consumer<ParentProfileProvider>(
              builder: (context, provider, _) {
                return provider.isLoading
                    ? const Loader()
                    : CustomButton(
                  text: currentStep == 1 ? 'Finish' : 'Continue',
                  onTap: onContinue,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    if (currentStep == 0) {
      return Form(
        key: _step1Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PrimaryText(text: 'Parent Details', size: 22),
            const SizedBox(height: 24),
            CustomTextField(
              controller: nameCtrl,
              hintText: 'Parent Name',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: emailCtrl,
              readonly: true,
              hintText: 'Email',
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: phoneCtrl,
              readonly: true,
              hintText: 'Phone',
              prefixIcon: Icons.phone,
            ),
          ],
        ),
      );
    }

    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PrimaryText(text: 'Address', size: 22),
          const SizedBox(height: 24),
          CustomTextField(controller: streetCtrl, hintText: 'Street'),
          const SizedBox(height: 16),
          CustomTextField(controller: cityCtrl, hintText: 'City'),
          const SizedBox(height: 16),
          CustomTextField(controller: stateCtrl, hintText: 'State'),
          const SizedBox(height: 16),
          CustomTextField(controller: pincodeCtrl, hintText: 'Pincode'),
        ],
      ),
    );
  }
}
