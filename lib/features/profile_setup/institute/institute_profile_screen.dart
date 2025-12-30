import 'package:get_me_a_tutor/import_export.dart';

class InstituteProfileCreateScreen extends StatefulWidget {
  static const String routeName = '/instituteProfile';
  const InstituteProfileCreateScreen({super.key});

  @override
  State<InstituteProfileCreateScreen> createState() =>
      _InstituteProfileCreateScreenState();
}

class _InstituteProfileCreateScreenState
    extends State<InstituteProfileCreateScreen> {
  int currentStep = 0;
  static const int maxGalleryImages = 10;

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();

  // controllers
  final institutionNameCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();

  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();

  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();

  String? institutionType;

  File? logo;
  List<File> galleryImages = [];

  final institutionTypes = [
    'School',
    'College',
    'Coaching Institute',
    'Training Center',
    'Online Academy',
  ];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    emailCtrl.text = authProvider.email ?? '';
    phoneCtrl.text = authProvider.phone ?? '';
  }

  Future<void> onContinue() async {
    final keys = [_step1Key, _step2Key, _step3Key];

    if (currentStep < 3) {
      if (currentStep < keys.length &&
          !keys[currentStep].currentState!.validate()) return;
      setState(() => currentStep++);
    } else {
      final provider =
      Provider.of<InstituteProfileProvider>(context, listen: false);

      final success = await provider.createInstituteProfile(
        context: context,
        institutionName: institutionNameCtrl.text.trim(),
        institutionType: institutionType!,
        about: aboutCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        website: websiteCtrl.text.trim(),
        address: {
          'street': streetCtrl.text.trim(),
          'city': cityCtrl.text.trim(),
          'state': stateCtrl.text.trim(),
          'pincode': pincodeCtrl.text.trim(),
        },
        logo: logo,
        galleryImages: galleryImages,
      );

      if (success) {
        showSnackBar(context, 'Institution profile created');
        context.read<AuthProvider>().setHasInstituteProfile(true);
        Navigator.pushNamedAndRemoveUntil(
          context,
          InstituteDashboard.routeName,
              (route) => false,
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _progressBar(),
              const SizedBox(height: 24),
              Expanded(child: _buildStep()),
              Consumer<InstituteProfileProvider>(
                builder: (context, provider, _) {
                  return provider.isLoading
                      ? const Loader()
                      : CustomButton(
                    text: currentStep == 3 ? 'Finish' : 'Continue',
                    onTap: onContinue,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressBar() {
    return Row(
      children: List.generate(
        4,
            (index) => Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: index <= currentStep
                  ? GlobalVariables.selectedColor
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return _stepBasicInfo();
      case 1:
        return _stepContact();
      case 2:
        return _stepAddress();
      case 3:
        return _stepMedia();
      default:
        return const SizedBox();
    }
  }

  // STEP 1
  Widget _stepBasicInfo() {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PrimaryText(text: 'Institution Details', size: 22),
          const SizedBox(height: 24),
          CustomTextField(
            controller: institutionNameCtrl,
            hintText: 'Institution Name',
            prefixIcon: Icons.business,
          ),
          const SizedBox(height: 16),
          CustomDropdown<String>(
            value: institutionType,
            items: institutionTypes,
            hintText: 'Institution Type',
            prefixIcon: Icons.school,
            itemLabel: (e) => e,
            onChanged: (val) => setState(() => institutionType = val),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: aboutCtrl,
            hintText: 'About Institution',
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  // STEP 2
  Widget _stepContact() {
    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PrimaryText(text: 'Contact Information', size: 22),
          const SizedBox(height: 24),
          CustomTextField(
            readonly: true,
            controller: emailCtrl,
            hintText: 'Email',
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            readonly: true,
            controller: phoneCtrl,
            hintText: 'Phone',
            prefixIcon: Icons.phone,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: websiteCtrl,
            hintText: 'Website',
            prefixIcon: Icons.language,
          ),
        ],
      ),
    );
  }

  // STEP 3
  Widget _stepAddress() {
    return Form(
      key: _step3Key,
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

  // STEP 4 – ONLY REQUIRED CHANGES HERE
  Widget _stepMedia() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PrimaryText(text: 'Media', size: 22),
          const SizedBox(height: 24),

          GestureDetector(
            onTap: () async {
              final files = await pickImages(type: FileType.image);
              if (files.isNotEmpty) {
                setState(() => logo = files.first);
              }
            },
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
                image: logo != null
                    ? DecorationImage(
                  image: FileImage(logo!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: logo == null
                  ? Icon(Icons.camera_alt,
                  size: 32,
                  color: GlobalVariables.secondaryTextColor)
                  : null,
            ),
          ),

          const SizedBox(height: 32),
          const PrimaryText(text: 'Gallery Images', size: 16),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...galleryImages.asMap().entries.map((entry) {
                final index = entry.key;
                final img = entry.value;
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        img,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => galleryImages.removeAt(index));
                        },
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.close,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              GestureDetector(
                onTap: () async {
                  final remaining =
                      maxGalleryImages - galleryImages.length;

                  if (remaining <= 0) {
                    _showLimitDialog(context);
                    return;
                  }

                  final images = await pickImages(
                    type: FileType.image,
                    max: remaining, // 👈 THIS enables multiple selection
                  );                  if (images.isEmpty) return;

                  if (images.length > remaining) {
                    _showLimitDialog(context);
                  }

                  setState(() {
                    galleryImages.addAll(images.take(remaining));
                  });
                },
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: galleryImages.length >= maxGalleryImages
                        ? Colors.grey.shade300
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 28,
                    color: galleryImages.length >= maxGalleryImages
                        ? Colors.grey
                        : GlobalVariables.secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLimitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Limit reached'),
        content:
        const Text('Only 10 images can be selected in the gallery.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
