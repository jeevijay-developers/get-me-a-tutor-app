import 'package:get_me_a_tutor/import_export.dart';

class AppliedJobsScreen extends StatefulWidget {
  static const routeName = '/appliedJobs';

  const AppliedJobsScreen({super.key});

  @override
  State<AppliedJobsScreen> createState() => _AppliedJobsScreenState();
}

class _AppliedJobsScreenState extends State<AppliedJobsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TutorAppliedJobsProvider>()
          .fetchMyApplications(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PrimaryText(text: 'Applied Jobs', size: 22),
        centerTitle: true,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.chevron_left,color: Colors.black,size: 40,)),
      ),
      body: Consumer<TutorAppliedJobsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Loader();
          }

          if (provider.applications.isEmpty) {
            return const Center(child: Text('No applications yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.applications.length,
            itemBuilder: (context, index) {
              final app = provider.applications[index];

              return AppliedJobCard(
                app: app,
                onTap: () {
                  // optional: navigate to job details
                },
              );
            },
          );
        },
      ),
    );
  }
}
