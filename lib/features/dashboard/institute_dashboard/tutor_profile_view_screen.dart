import 'package:get_me_a_tutor/import_export.dart';

class TutorProfileViewScreen extends StatefulWidget {
  static const routeName = '/tutorProfileView';
  final String userId;
  const TutorProfileViewScreen({super.key, required this.userId});

  @override
  State<TutorProfileViewScreen> createState() => _TutorProfileViewScreenState();
}

class _TutorProfileViewScreenState extends State<TutorProfileViewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TeacherProvider>().fetchTeacherProfile(context, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tutor Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left, color: Colors.black, size: 40),
        ),
      ),
      body: Consumer<TeacherProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const Loader();

          final t = provider.teacher;
          if (t == null) {
            return const Center(child: Text('Profile not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PHOTO
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: t.photo?.url != null
                        ? NetworkImage(t.photo!.url!)
                        : null,
                    child: t.photo == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                ),

                const SizedBox(height: 20),

                PrimaryText(text: t.bio ?? '', size: 16),

                const SizedBox(height: 12),
                Text('Experience: ${t.experienceYears} years'),

                const SizedBox(height: 12),
                Text('City: ${t.city}'),

                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: t.subjects
                      .map(
                        (s) => Chip(
                          label: Text(s, style: TextStyle(color: Colors.black)),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 12),
                if (t.expectedSalary != null)
                  Text(
                    'Expected Salary: ₹${t.expectedSalary!.min} - ₹${t.expectedSalary!.max}',
                  ),

                const SizedBox(height: 12),
                if (t.demoVideoUrl != null && t.demoVideoUrl!.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.play_circle_fill, color: Colors.red),
                    title: const Text('Watch Demo Video',style: TextStyle(color: Colors.black),),
                    onTap: () async {
                      final uri = Uri.parse(t.demoVideoUrl!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        showSnackBar(context, 'Could not open video');
                      }
                    },
                  ),


                const SizedBox(height: 12),
                if (t.resume?.url == null) Text('Resume: Not uploaded'),
                if (t.resume?.url != null)
                  TextButton(
                    onPressed: () {
                      launchUrl(Uri.parse(t.resume!.url!));
                    },
                    child: const Text('View Resume'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
