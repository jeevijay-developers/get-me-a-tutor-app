import 'package:get_me_a_tutor/import_export.dart';

class AllApplicationsScreen extends StatefulWidget {
  static const routeName = '/allApplications';

  final String jobId;
  final String jobTitle;

  const AllApplicationsScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  State<AllApplicationsScreen> createState() =>
      _AllApplicationsScreenState();
}

class _AllApplicationsScreenState
    extends State<AllApplicationsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobApplicationProvider>(
        context,
        listen: false,
      ).fetchApplications(
        context: context,
        jobId: widget.jobId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String timeAgo(DateTime date) {
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
      if (diff.inHours < 24) return '${diff.inHours} hr ago';
      return '${diff.inDays} days ago';
    }
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: PrimaryText(text: 'All Applications', size: 25),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left, color: Colors.black, size: 40),
        ),
      ),
      body: Consumer<JobApplicationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Loader();
          }

          if (provider.applications.isEmpty) {
            return const Center(
              child: Text('No applications yet'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.applications.length,
            itemBuilder: (context, index) {
              final app = provider.applications[index];

              return RecentApplicationCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TutorApplicationScreen(
                        teacherName: app.tutorName,
                        tutorUserId: app.tutorUserId,
                        applicationId: app.id,
                        currentStatus: app.status,
                      ),
                    ),
                  );

                },
                photo: app.tutorPhoto,
                name: app.tutorName,
                role: app.jobTitle,
                time: timeAgo(app.createdAt),
              );
            },
          );
        },
      ),
    );
  }
}
