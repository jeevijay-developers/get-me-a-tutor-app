import 'package:get_me_a_tutor/import_export.dart';

class ParentProfileUpdateScreen extends StatefulWidget {
  static const String routeName = '/parentProfileUpdate';
  const ParentProfileUpdateScreen({super.key});

  @override
  State<ParentProfileUpdateScreen> createState() =>
      _ParentProfileUpdateScreenState();
}

class _ParentProfileUpdateScreenState extends State<ParentProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cityCtrl = TextEditingController();

  final streetCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    final parent = Provider.of<ParentProfileProvider>(
      context,
      listen: false,
    ).parent!;

    nameCtrl.text = parent.name;
    phoneCtrl.text = parent.phone ?? '';
    cityCtrl.text = parent.city ?? '';

    streetCtrl.text = parent.address?.street ?? '';
    stateCtrl.text = parent.address?.state ?? '';
    pincodeCtrl.text = parent.address?.pincode ?? '';
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
    Provider.of<ParentProfileProvider>(context, listen: false);

    final success = await provider.updateParentProfile(
      context: context,
      body: {
        'name': nameCtrl.text.trim(),
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

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const PrimaryText(text: 'Edit Profile', size: 22),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 36, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ───────── AVATAR ─────────
                const Center(
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: Color(0xFFEAEAEA),
                    child: Icon(Icons.person, size: 36),
                  ),
                ),

                const SizedBox(height: 32),

                _label('Full Name'),
                CustomTextField(
                  controller: nameCtrl,
                  hintText: 'Enter your name',
                ),

                _gap(),
                _label('Phone Number'),
                CustomTextField(
                  controller: phoneCtrl,
                  hintText: 'Enter phone number',
                  keyboardType: TextInputType.phone,
                ),

                _gap(),
                _label('Street'),
                CustomTextField(
                  controller: streetCtrl,
                  hintText: 'Street address',
                ),

                _gap(),
                _label('City'),
                CustomTextField(
                  controller: cityCtrl,
                  hintText: 'City',
                ),

                _gap(),
                _label('State'),
                CustomTextField(
                  controller: stateCtrl,
                  hintText: 'State',
                ),

                _gap(),
                _label('Pincode'),
                CustomTextField(
                  controller: pincodeCtrl,
                  hintText: 'Pincode',
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 32),

                Consumer<ParentProfileProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(child: Loader());
                    }
                    return CustomButton(
                      text: 'Save Changes',
                      onTap: submit,
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ───────── HELPERS ─────────
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: PrimaryText(text: text, size: 16),
  );

  Widget _gap() => const SizedBox(height: 20);
}
