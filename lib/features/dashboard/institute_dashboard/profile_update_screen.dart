import 'package:get_me_a_tutor/import_export.dart';

class InstituteProfileUpdateScreen extends StatefulWidget {
  const InstituteProfileUpdateScreen({super.key});

  @override
  State<InstituteProfileUpdateScreen> createState() =>
      _InstituteProfileUpdateScreenState();
}

class _InstituteProfileUpdateScreenState
    extends State<InstituteProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  // dropdown
  String? institutionType;
  final institutionTypes = [
    'School',
    'College',
    'Coaching Institute',
    'Training Center',
    'Online Academy',
  ];

  // controllers
  final nameCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();

  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();

  // media
  File? newLogo;
  bool removeLogo = false;

  final List<String> existingGalleryImages = [];
  final List<File> newGalleryImages = [];

  @override
  void initState() {
    super.initState();

    final institute =
    Provider.of<InstituteProvider>(context, listen: false).institution!;

    nameCtrl.text = institute.institutionName;
    institutionType = institute.institutionType;
    aboutCtrl.text = institute.about ?? '';
    phoneCtrl.text = institute.phone ?? '';
    websiteCtrl.text = institute.website ?? '';

    streetCtrl.text = institute.address?.street ?? '';
    cityCtrl.text = institute.address?.city ?? '';
    stateCtrl.text = institute.address?.state ?? '';
    pincodeCtrl.text = institute.address?.pincode ?? '';

    existingGalleryImages.addAll(institute.galleryImages);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    aboutCtrl.dispose();
    phoneCtrl.dispose();
    websiteCtrl.dispose();
    streetCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    pincodeCtrl.dispose();
    super.dispose();
  }

  // ───────── SUBMIT ─────────
  void submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<InstituteProvider>(context, listen: false);

    final body = {
      'institutionName': nameCtrl.text.trim(),
      'institutionType': institutionType,
      'about': aboutCtrl.text.trim(),
      'phone': phoneCtrl.text.trim(),
      'website': websiteCtrl.text.trim(),
      'address': {
        'street': streetCtrl.text.trim(),
        'city': cityCtrl.text.trim(),
        'state': stateCtrl.text.trim(),
        'pincode': pincodeCtrl.text.trim(),
      },
      'galleryImages':existingGalleryImages,
    };

    final success = await provider.updateInstituteProfile(
      context: context,
      body: body,
      logo: newLogo,
      galleryImages: newGalleryImages,
    );

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final institute =
    Provider.of<InstituteProvider>(context, listen: false).institution!;

    ImageProvider? logoImage() {
      if (newLogo != null) return FileImage(newLogo!);
      if (removeLogo) return null;
      if (institute.logo != null && institute.logo!.isNotEmpty) {
        return NetworkImage(institute.logo!);
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
                /// ───────── LOGO ─────────
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final files =
                          await pickImages(type: FileType.image);
                          if (files.isNotEmpty) {
                            setState(() {
                              newLogo = files.first;
                              removeLogo = false;
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor:
                          GlobalVariables.selectedColor.withOpacity(0.2),
                          backgroundImage: logoImage(),
                          child: logoImage() == null
                              ? const Icon(Icons.school, size: 32)
                              : null,
                        ),
                      ),

                      if (logoImage() != null)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                newLogo = null;
                                removeLogo = true;
                              });
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _label('Institution Name'),
                CustomTextField(
                  controller: nameCtrl,
                  hintText: 'Institution Name',
                ),

                _gap(),
                _label('Institution Type'),
                CustomDropdown<String>(
                  value: institutionType,
                  items: institutionTypes,
                  hintText: 'Institution Type',
                  itemLabel: (e) => e,
                  onChanged: (val) => setState(() => institutionType = val),
                ),

                _gap(),
                _label('About'),
                CustomTextField(
                  controller: aboutCtrl,
                  hintText: 'About institution',
                  maxLines: 4,
                ),

                _gap(),
                _label('Phone'),
                CustomTextField(
                  controller: phoneCtrl,
                  hintText: 'Phone',
                  keyboardType: TextInputType.phone,
                ),

                _gap(),
                _label('Website'),
                CustomTextField(
                  controller: websiteCtrl,
                  hintText: 'Website',
                ),

                _gap(),
                _label('Address'),
                CustomTextField(controller: streetCtrl, hintText: 'Street'),
                const SizedBox(height: 12),
                CustomTextField(controller: cityCtrl, hintText: 'City'),
                const SizedBox(height: 12),
                CustomTextField(controller: stateCtrl, hintText: 'State'),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: pincodeCtrl,
                  hintText: 'Pincode',
                  keyboardType: TextInputType.number,
                ),

                _gap(),
                _label('Gallery'),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ...existingGalleryImages.map(
                          (img) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
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
                                setState(() =>
                                    existingGalleryImages.remove(img));
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
                      ),
                    ),
                    ...newGalleryImages.map(
                          (img) => Stack(
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
                                setState(() =>
                                    newGalleryImages.remove(img));
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
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final images = await pickImages(
                          max: 6,
                          type: FileType.image,
                        );
                        if (images.isNotEmpty) {
                          setState(() =>
                              newGalleryImages.addAll(images));
                        }
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 28,
                          color: GlobalVariables.secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                Consumer<InstituteProvider>(
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

  // ───────── HELPERS ─────────
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: PrimaryText(text: text, size: 16),
  );

  Widget _gap() => const SizedBox(height: 20);
}
