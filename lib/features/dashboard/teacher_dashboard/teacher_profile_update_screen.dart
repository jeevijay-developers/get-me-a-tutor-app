import 'package:get_me_a_tutor/import_export.dart';

class TeacherProfileUpdateScreen extends StatefulWidget {
  static const String routeName = '/teacherProfileUpdate';
  const TeacherProfileUpdateScreen({super.key});

  @override
  State<TeacherProfileUpdateScreen> createState() =>
      _TeacherProfileUpdateScreenState();
}

class _TeacherProfileUpdateScreenState
    extends State<TeacherProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  final bioCtrl = TextEditingController();
  final availabilityCtrl = TextEditingController();
  final salaryMinCtrl = TextEditingController();
  final salaryMaxCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final subjectInputCtrl = TextEditingController();
  final classInputCtrl = TextEditingController();
  final languageInputCtrl = TextEditingController();

  double experienceYears = 0;
  bool isPublic = true;

  File? newDemoVideo;
  File? newPhoto;
  File? newResume;

  bool removePhoto = false;
  bool removeResume = false;
  bool removeDemoVideo = false;

  List<String> subjects = [];
  List<int> classes = [];
  List<String> languages = [];
  List<String> tags = [];

  @override
  void initState() {
    super.initState();

    final teacher =
    Provider.of<TeacherProvider>(context, listen: false).teacher!;

    bioCtrl.text = teacher.bio ?? '';
    availabilityCtrl.text = teacher.availability ?? '';
    cityCtrl.text = teacher.city ?? '';
    experienceYears = teacher.experienceYears.toDouble();
    isPublic = teacher.isPublic;

    subjects = List.from(teacher.subjects);
    classes = List.from(teacher.classes);
    languages = List.from(teacher.languages);
    tags = List.from(teacher.tags);

    salaryMinCtrl.text = teacher.expectedSalary?.min?.toString() ?? '';
    salaryMaxCtrl.text = teacher.expectedSalary?.max?.toString() ?? '';
  }

  @override
  void dispose() {
    bioCtrl.dispose();
    availabilityCtrl.dispose();
    salaryMinCtrl.dispose();
    salaryMaxCtrl.dispose();
    subjectInputCtrl.dispose();
    classInputCtrl.dispose();
    languageInputCtrl.dispose();
    cityCtrl.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
    Provider.of<TeacherProfileProvider>(context, listen: false);

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
      tags: tags,
      resume: removeResume ? null : newResume,
      photo: removePhoto ? null : newPhoto,
      demoVideo: removeDemoVideo ? null : newDemoVideo,
      removePhoto: removePhoto,
      removeResume: removeResume,
      removeDemoVideo: removeDemoVideo,
    );

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final teacher =
    Provider.of<TeacherProvider>(context, listen: false).teacher!;

    ImageProvider? profileImage() {
      if (newPhoto != null) return FileImage(newPhoto!);
      if (removePhoto) return null;
      if (teacher.photo?.url != null &&
          teacher.photo!.url!.isNotEmpty) {
        return NetworkImage(teacher.photo!.url!);
      }
      return null;
    }

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const PrimaryText(text: 'Edit Profile', size: 22),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
          const Icon(Icons.chevron_left, size: 36, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<TeacherProfileProvider>(
        builder: (context, provider, _) {

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// PHOTO
                    Center(
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final files =
                              await pickImages(type: FileType.image);
                              if (files.isNotEmpty) {
                                setState(() {
                                  newPhoto = files.first;
                                  removePhoto = false;
                                });
                              }
                            },
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor:
                              GlobalVariables.selectedColor
                                  .withOpacity(0.2),
                              backgroundImage: profileImage(),
                              child: profileImage() == null
                                  ? const Icon(Icons.person, size: 32)
                                  : null,
                            ),
                          ),
                          if (profileImage() != null)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    newPhoto = null;
                                    removePhoto = true;
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.black54,
                                  child: Icon(Icons.close,
                                      size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    _label('City'),
                    CustomTextField(controller: cityCtrl, hintText: 'City'),

                    _gap(),
                    _label('Bio'),
                    CustomTextField(
                      controller: bioCtrl,
                      hintText: 'Short bio',
                      maxLines: 4,
                    ),
                    _gap(),
                    _label('Subjects'),
                    _chipInput(
                      items: subjects,
                      controller: subjectInputCtrl,
                      hint: 'Add subject',
                      onAdd: (v) => setState(() => subjects.add(v)),
                      onRemove: (v) => setState(() => subjects.remove(v)),
                    ),
                    _gap(),
                    _label('Classes'),
                    _chipInput(
                      items: classes.map((e) => e.toString()).toList(),
                      controller: classInputCtrl,
                      hint: 'Add class',
                      onAdd: (v) {
                        final val = int.tryParse(v);
                        if (val != null) {
                          setState(() => classes.add(val));
                        }
                      },
                      onRemove: (v) {
                        final val = int.tryParse(v);
                        if (val != null) {
                          setState(() => classes.remove(val));
                        }
                      },
                    ),

                    _gap(),
                    _label('Languages'),
                    _chipInput(
                      items: languages,
                      controller: languageInputCtrl,
                      hint: 'Add language',
                      onAdd: (v) => setState(() => languages.add(v)),
                      onRemove: (v) => setState(() => languages.remove(v)),
                    ),


                    _gap(),
                    _label('Experience (${experienceYears.toInt()} years)'),
                    Slider(
                      value: experienceYears,
                      min: 0,
                      max: 40,
                      divisions: 40,
                      onChanged: (v) =>
                          setState(() => experienceYears = v),
                    ),

                    _gap(),
                    _label('Availability'),
                    CustomTextField(
                      controller: availabilityCtrl,
                      hintText: 'Availability',
                    ),

                    _gap(),
                    _label('Demo Video'),
                    _filePickerBox(
                      icon: Icons.play_circle_fill,
                      onTap: () async {
                        final files = await pickImages(
                          type: FileType.custom,
                          allowedExtensions: ['mp4', 'mkv', 'webm', 'mov'],
                        );
                        if (files.isNotEmpty) {
                          setState(() {
                            newDemoVideo = files.first;
                            removeDemoVideo = false;
                          });
                        }
                      },
                      onRemove: (teacher.demoVideoUrl != null ||
                          newDemoVideo != null)
                          ? () {
                        setState(() {
                          newDemoVideo = null;
                          removeDemoVideo = true;
                        });
                      }
                          : null,
                    ),
                    Text(
                      removeDemoVideo
                          ? 'No demo video uploaded'
                          : (teacher.demoVideoUrl != null ||
                          newDemoVideo != null)
                          ? 'Demo video uploaded'
                          : 'No demo video uploaded',
                      style: const TextStyle(color: Colors.grey),
                    ),

                    _gap(),
                    _label('Resume'),
                    _filePickerBox(
                      icon: Icons.picture_as_pdf,
                      onTap: () async {
                        final files = await pickImages(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (files.isNotEmpty) {
                          setState(() {
                            newResume = files.first;
                            removeResume = false;
                          });
                        }
                      },
                      onRemove:
                      (teacher.resume?.url != null || newResume != null)
                          ? () {
                        setState(() {
                          newResume = null;
                          removeResume = true;
                        });
                      }
                          : null,
                    ),
                    Text(
                      removeResume
                          ? 'No resume uploaded'
                          : (teacher.resume?.url != null ||
                          newResume != null)
                          ? 'Resume uploaded'
                          : 'No resume uploaded',
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Consumer<TeacherProfileProvider>(
                        builder: (context, provider, _) {
                          return ElevatedButton(
                            onPressed: provider.isLoading ? null : submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GlobalVariables.selectedColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: provider.isLoading
                                ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                                : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: PrimaryText(text: text, size: 16),
  );

  Widget _gap() => const SizedBox(height: 20);

  Widget _filePickerBox({
    required IconData icon,
    required VoidCallback onTap,
    VoidCallback? onRemove,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: GlobalVariables.secondaryTextColor),
          ),
        ),
        if (onRemove != null)
          IconButton(
            icon: const Icon(Icons.close,color: Colors.grey,),
            onPressed: onRemove,
          ),
      ],
    );
  }
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
}
