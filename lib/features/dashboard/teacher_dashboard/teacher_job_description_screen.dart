import 'package:get_me_a_tutor/import_export.dart';

class TeacherJobDescriptionScreen extends StatelessWidget {
  static const String routeName = '/teacherJobDescription';

  final JobModel job;

  const TeacherJobDescriptionScreen({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;

    String timeAgo(DateTime date) {
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
      if (diff.inHours < 24) return '${diff.inHours} hr ago';
      return '${diff.inDays} days ago';
    }

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,

      /// ───────── AppBar ─────────
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const PrimaryText(text: 'Job Details', size: 18),
      ),

      /// ───────── Body ─────────
      body: Consumer<TeacherProvider>(
        builder: (context, teacherProvider, _) {
          final credits = teacherProvider.teacher?.credits ?? 0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16 * scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 22),

                /// ───────── Job Title ─────────
                PrimaryText(
                  text: job.title,
                  size: 28 * scale,
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    SecondaryText(
                      text: 'Posted ${timeAgo(job.createdAt)}',
                      size: 13,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                SecondaryText(
                  text: 'Posted by: ${job.postedByRole}',
                  size: 13,
                ),
                const SizedBox(height: 28),

                /// ───────── Salary + Mode Cards ─────────
                Row(
                  children: [
                    _infoCard(
                      icon: Icons.currency_rupee,
                      title: 'Salary',
                      value: job.salary != null
                          ? '₹${job.salary}'
                          : 'Not specified',
                      bg: const Color(0xFFEAF3FF),
                      iconColor: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 14),
                    _infoCard(
                      icon: Icons.work_outline,
                      title: 'Job Type',
                      value: job.jobType,
                      bg: const Color(0xFFF5F5F5),
                      iconColor: Colors.black,
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                /// ───────── Location + Class Range ─────────
                _detailTile(
                  icon: Icons.location_on,
                  title: 'Location',
                  value: job.location ?? 'Not specified',
                ),

                if (job.classRange != null) ...[
                  const SizedBox(height: 16),
                  _detailTile(
                    icon: Icons.school,
                    title: 'Class Range',
                    value: job.classRange!,
                  ),
                ],

                if (job.deadline != null) ...[
                  const SizedBox(height: 16),
                  _detailTile(
                    icon: Icons.event,
                    title: 'Deadline',
                    value:
                    '${job.deadline!.day}/${job.deadline!.month}/${job.deadline!.year}',
                  ),
                ],

                const SizedBox(height: 28),

                /// ───────── Subjects ─────────
                const PrimaryText(text: 'Subjects', size: 18),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: job.subjects.map((subject) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: GlobalVariables.selectedColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Text(
                        subject,
                        style: TextStyle(
                          color: GlobalVariables.selectedColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                /// ───────── Description ─────────
                /// ───────── Description ─────────
                const PrimaryText(text: 'Job Description', size: 18),
                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  decoration: BoxDecoration(
                    color: GlobalVariables.greyBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    job.description?.isNotEmpty == true
                        ? job.description!
                        : 'No description provided.',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6, // 👈 makes long text readable
                      color: Colors.black87,
                    ),
                  ),
                ),


                const SizedBox(height: 140),
              ],
            ),
          );
        },
      ),

      /// ───────── Bottom Apply Section ─────────
      bottomNavigationBar: Consumer<TeacherProvider>(
        builder: (context, teacherProvider, _) {
          final credits = teacherProvider.teacher?.credits ?? 0;

          return Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 14,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Credits Row
                /// Credits Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        SecondaryText(
                          text: 'Balance: $credits Credits',
                          size: 13,
                        ),
                      ],
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: GlobalVariables.selectedColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Cost: 5 Credits',
                        style: TextStyle(
                          color: GlobalVariables.selectedColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 14),

                /// Apply Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      final teacherProvider =
                      Provider.of<TeacherProvider>(context, listen: false);
                      final teacher = teacherProvider.teacher;
                      final credits = teacher?.credits ?? 0;

                      // ❌ Not enough credits
                      if (credits < 5) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => AlertDialog(
                            title: const Text('Not enough credits'),
                            content: const Text(
                              'Applying to a job costs 5 credits. Please buy credits to continue.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Buy credits flow
                                },
                                child: const Text('Buy Credits'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
// ❌ Profile is private
                      if (teacher?.isPublic == false) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => AlertDialog(
                            title: const Text('Profile is Private'),
                            content: const Text(
                              'Please make your profile public to start applying for jobs.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      // ✅ Apply to job
                      final provider =
                      Provider.of<JobApplicationProvider>(context, listen: false);

                      final success = await provider.applyToJob(
                        context: context,
                        jobId: job.id,
                      );

                      if (success) {
                        final auth =
                        Provider.of<AuthProvider>(context, listen: false);
                        // 🔄 refresh teacher data (credits -5, jobsApplied +1)
                        await Provider.of<TeacherProvider>(
                          context,
                          listen: false,
                        ).fetchTeacherProfile(context,auth.userId!);

                        showSnackBar(context, 'Applied successfully');
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalVariables.selectedColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Apply using credits',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ───────── Reusable Widgets ─────────

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color bg,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 26, color: iconColor),
            const SizedBox(height: 14),
            PrimaryText(text: value, size: 22),
            const SizedBox(height: 6),
            SecondaryText(text: title, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _detailTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SecondaryText(text: title, size: 12),
              const SizedBox(height: 4),
              PrimaryText(text: value, size: 14),
            ],
          ),
        ],
      ),
    );
  }
}
