import 'package:get_me_a_tutor/import_export.dart';

class JobDescriptionScreen extends StatelessWidget {
  static const String routeName = '/jobDescription';

  final JobModel job;

  const JobDescriptionScreen({
    super.key,
    required this.job,
  });

  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 36, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const PrimaryText(text: 'Job Details', size: 20),
      ),

      bottomNavigationBar: _bottomActions(context),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ───── TITLE ─────
            PrimaryText(text: job.title, size: 30),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                SecondaryText(
                  text: 'Posted ${timeAgo(job.createdAt)}',
                  size: 13,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ───── INFO CARDS ─────
            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    icon: Icons.currency_rupee,
                    title: 'Hourly Rate',
                    value: '₹${job.salary ?? 0}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoCard(
                    icon: Icons.work_outline,
                    title: 'Job Type',
                    value: job.jobType.replaceAll('-', ' ').toUpperCase(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ───── SUBJECTS ─────
            _listTile(
              icon: Icons.menu_book,
              title: job.subjects.join(', '),
              subtitle: 'Subjects',
            ),

            _listTile(
              icon: Icons.school,
              title: job.classRange ?? 'Not specified',
              subtitle: 'Class Range',
            ),

            _listTile(
              icon: Icons.location_on,
              title: job.location ?? 'Not specified',
              subtitle: 'Location',
            ),

            _listTile(
              icon: Icons.calendar_today,
              title:
              '${job.deadline!.day}/${job.deadline!.month}/${job.deadline!.year}',
              subtitle: 'Application Deadline',
            ),

            const SizedBox(height: 28),

            /// ───── DESCRIPTION ─────
            const PrimaryText(text: 'Job Description', size: 20),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: GlobalVariables.greyBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SecondaryText(
                text: job.description?.isNotEmpty == true
                    ? job.description!
                    : 'No description provided.',
                size: 14,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// ─────────────────────────────────────────

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GlobalVariables.greyBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: GlobalVariables.selectedColor),
          const SizedBox(height: 10),
          PrimaryText(text: value, size: 18),
          const SizedBox(height: 4),
          SecondaryText(text: title, size: 13),
        ],
      ),
    );
  }

  Widget _listTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GlobalVariables.greyBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(text: title, size: 16),
              SecondaryText(text: subtitle, size: 13),
            ],
          ),
        ],
      ),
    );
  }

  /// ─────────────────────────────────────────

  Widget _bottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Update Job',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JobUpdateScreen(
                      job: job,
                    ),
                  ),
                );              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              text: 'Close Job',
              onTap: () => _confirmClose(context),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClose(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Close Job'),
        content: const Text(
          'Are you sure you want to close this job? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider =
              Provider.of<JobProvider>(context, listen: false);
              final auth = Provider.of<AuthProvider>(context, listen: false);

              final success = await provider.closeJob(
                context: context,
                jobId: job.id,
              );

              if (success) {
                if (auth.role == 'institute') {
                  await Provider.of<InstituteProvider>(
                    context,
                    listen: false,
                  ).fetchMyInstitute(context);
                }

                if (auth.role == 'parent') {
                  await Provider.of<ParentProfileProvider>(
                    context,
                    listen: false,
                  ).fetchMyParentProfile(context);
                }

                Navigator.pop(context);
              }

            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
