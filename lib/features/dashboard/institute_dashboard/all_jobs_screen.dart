import 'package:get_me_a_tutor/import_export.dart';

class AllJobsScreen extends StatefulWidget {
  final int jobsPosted;
  static const routeName = '/allJobs';
  const AllJobsScreen({super.key, required this.jobsPosted});

  @override
  State<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends State<AllJobsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobProvider>(context, listen: false).fetchMyJobs(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: PrimaryText(text: 'My Jobs', size: 25),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left, color: Colors.black, size: 40),
        ),
      ),
      body: Consumer<JobProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const Loader();
          if (widget.jobsPosted == 0) {
            return const Center(child: Text('No jobs posted yet'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: provider.jobs.where((job)=>job.status!='closed').map((job) {
              return JobCard(
                job: job,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllApplicationsScreen(
                        jobId: job.id,
                        jobTitle: job.title,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
