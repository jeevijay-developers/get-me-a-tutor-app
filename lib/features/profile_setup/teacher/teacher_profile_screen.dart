import 'package:get_me_a_tutor/import_export.dart';

class TeacherProfileCreateScreen extends StatefulWidget {
  static const String routeName = '/teacherProfile';
  const TeacherProfileCreateScreen({super.key});

  @override
  State<TeacherProfileCreateScreen> createState() => _TeacherProfileCreateScreenState();
}

class _TeacherProfileCreateScreenState extends State<TeacherProfileCreateScreen> {
  int currentStep = 0;

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();

  // controllers
  final bioCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final qualificationCtrl = TextEditingController();
  final availabilityCtrl = TextEditingController();

  final subjectInputCtrl = TextEditingController();
  final classInputCtrl = TextEditingController();
  final languageInputCtrl = TextEditingController();

  final salaryMinCtrl = TextEditingController();
  final salaryMaxCtrl = TextEditingController();

  // state
  double experienceYears = 0;
  bool isPublic = true;

  List<String> subjects = [];
  List<int> classes = [];
  List<String> languages = [];

  File? resume;
  File? photo;
  File? demoVideo;

  Future<void> onContinue() async {
    final keys = [_step1Key, _step2Key, _step3Key];

    if (currentStep < 3) {
      if (!keys[currentStep].currentState!.validate()) return;
      setState(() => currentStep++);
    } else {
      final provider = Provider.of<TeacherProfileProvider>(
        context,
        listen: false,
      );

      final success = await provider.upsertTeacherProfile(
        context: context,
        bio: bioCtrl.text.trim(),
        experienceYears: experienceYears.toInt(),
        subjects: subjects,
        classes: classes,
        languages: languages,
        city: cityCtrl.text.trim(),
        expectedSalary: {
          'min': int.tryParse(salaryMinCtrl.text) ?? 0,
          'max': int.tryParse(salaryMaxCtrl.text) ?? 0,
        },
        availability: availabilityCtrl.text.trim(),
        isPublic: isPublic,
        tags: [],
        resume: resume,
        photo: photo,
        demoVideo: demoVideo,
        removeDemoVideo: false,
        removePhoto: false,
        removeResume: false,
      );

      if (success) {
        showSnackBar(context, "Profile created sucessfully");
        context.read<AuthProvider>().setHasTeacherProfile(true);

        Navigator.pushNamedAndRemoveUntil(
          context,
          TeacherDashboard.routeName,
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
              _stepIndicator(),
              const SizedBox(height: 24),
              Expanded(child: SingleChildScrollView(child: _buildStep())),
              Consumer<TeacherProfileProvider>(
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

  // ───────────────────────── UI HELPERS ─────────────────────────

  Widget _stepIndicator() {
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

  Widget _header(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SecondaryText(text: 'Step ${currentStep + 1} of 4', size: 14),
        const SizedBox(height: 8),
        PrimaryText(text: title, size: 26),
        const SizedBox(height: 8),
        SecondaryText(text: subtitle, size: 14),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return _stepBasic();
      case 1:
        return _stepProfessional();
      case 2:
        return _stepAvailability();
      case 3:
        return _stepMedia();
      default:
        return const SizedBox();
    }
  }

  // ───────────────────────── STEP 1 ─────────────────────────

  Widget _stepBasic() {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header('Teacher Profile', 'Tell students a bit about yourself.'),
          CustomTextField(
            controller: bioCtrl,
            hintText: 'Short bio',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          CustomTextField(controller: cityCtrl, hintText: 'City'),
        ],
      ),
    );
  }

  // ───────────────────────── STEP 2 ─────────────────────────

  Widget _stepProfessional() {
    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(
            'Professional Details',
            'Tell us about your expertise to match you with the right students.',
          ),

          CustomTextField(
            controller: qualificationCtrl,
            hintText: 'Highest Qualification',
          ),
          const SizedBox(height: 24),

          const PrimaryText(text: 'Subjects You Teach', size: 16),
          const SizedBox(height: 12),
          _chipInput(
            items: subjects,
            controller: subjectInputCtrl,
            hint: 'Add subject',
            onAdd: (val) => setState(() => subjects.add(val)),
            onRemove: (val) => setState(() => subjects.remove(val)),
          ),
          const SizedBox(height: 24),

          const PrimaryText(text: 'Languages You Teach', size: 16),
          const SizedBox(height: 12),
          _chipInput(
            items: languages,
            controller: languageInputCtrl,
            hint: 'Add language',
            onAdd: (val) => setState(() => languages.add(val)),
            onRemove: (val) => setState(() => languages.remove(val)),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PrimaryText(text: 'Years of Experience', size: 16),
              Text(
                '${experienceYears.toInt()} Years',
                style: TextStyle(
                  color: GlobalVariables.selectedColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: experienceYears,
            min: 0,
            max: 40,
            divisions: 40,
            onChanged: (v) => setState(() => experienceYears = v),
          ),

          const SizedBox(height: 24),
          const PrimaryText(text: 'Teaching Mode', size: 16),
          const SizedBox(height: 8),
          _lockedBox('Online only'),
        ],
      ),
    );
  }

  // ───────────────────────── STEP 3 ─────────────────────────

  Widget _stepAvailability() {
    return Form(
      key: _step3Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header('Availability & Pricing', 'Set your teaching preferences.'),

          const PrimaryText(text: 'Classes You Teach', size: 16),
          const SizedBox(height: 12),
          _chipInput(
            items: classes.map((e) => e.toString()).toList(),
            controller: classInputCtrl,
            hint: 'Add class',
            onAdd: (val) => setState(() => classes.add(int.tryParse(val) ?? 0)),
            onRemove: (val) =>
                setState(() => classes.remove(int.tryParse(val))),
          ),

          const SizedBox(height: 16),
          CustomTextField(
            controller: availabilityCtrl,
            hintText: 'Availability (e.g. Weekends)',
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: salaryMinCtrl,
                  hintText: 'Min Salary',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  controller: salaryMaxCtrl,
                  hintText: 'Max Salary',
                ),
              ),
            ],
          ),

          SwitchListTile(
            value: isPublic,
            onChanged: (v) => setState(() => isPublic = v),
            title: const Text('Make profile public',style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── STEP 4 ─────────────────────────

  Widget _stepMedia() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header('Media', 'Upload supporting documents and profile photo.'),

          const SizedBox(height: 24),
          const PrimaryText(text: 'Demo Video', size: 16),
          const SizedBox(height: 8),
          _filePickerBox(
            file: demoVideo,
            icon: Icons.play_circle_fill,
            onTap: () async {
              final files = await pickImages(type: FileType.custom,allowedExtensions: ['mp4','mkv','webm','3gp','mov','avi','flv','mpeg','mpg','wmv','m4v']);
              if (files.isNotEmpty) {
                setState(() => demoVideo = files.first);
              }
            },
          ),

          const SizedBox(height: 24),

          const PrimaryText(text: 'Resume', size: 16),
          const SizedBox(height: 8),
          _filePickerBox(
            file: resume,
            icon: Icons.picture_as_pdf,
            onTap: () async {
              final files = await pickImages(type:FileType.custom,allowedExtensions: ['pdf']);
              if (files.isNotEmpty) setState(() => resume = files.first);
            },
          ),

          const SizedBox(height: 24),
          const PrimaryText(text: 'Profile Photo', size: 16),
          const SizedBox(height: 8),
          _filePickerBox(
            file: photo,
            icon: Icons.camera_alt,
            onTap: () async {
              final files = await pickImages(type: FileType.image);
              if (files.isNotEmpty) setState(() => photo = files.first);
            },
          ),
        ],
      ),
    );
  }

  // ───────────────────────── SMALL WIDGETS ─────────────────────────

  Widget _chipInput({
    required List<String> items,
    required TextEditingController controller,
    required String hint,
    required Function(String) onAdd,
    required Function(String) onRemove,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...items.map(
          (e) => Chip(
            label: Text(e,style: TextStyle(color: Colors.black),),
            deleteIcon: const Icon(Icons.close, size: 18,color: Colors.black,),
            onDeleted: () => onRemove(e),
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(hint),
                content: TextField(controller: controller),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        onAdd(controller.text.trim());
                        controller.clear();
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: GlobalVariables.selectedColor),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 16),
                SizedBox(width: 6),
                Text('Add'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _lockedBox(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.laptop),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
          const Icon(Icons.lock),
        ],
      ),
    );
  }

  Widget _filePickerBox({
    required File? file,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: file == null
            ? Icon(icon, color: GlobalVariables.secondaryTextColor)
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
