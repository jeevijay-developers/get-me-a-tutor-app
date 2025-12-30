import 'package:get_me_a_tutor/import_export.dart';

class JobPostingCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;

  const JobPostingCard({
    super.key,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ───── Header (Icon + Title + Salary) ─────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: GlobalVariables.selectedColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school,
                    size: 22,
                    color: GlobalVariables.selectedColor,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: job.title,
                        size: 16,
                      ),
                      const SizedBox(height: 4),
                      if (job.classRange != null)
                        SecondaryText(
                          text: 'Class ${job.classRange}',
                          size: 13,
                        ),
                    ],
                  ),
                ),

                if (job.salary != null)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '₹${job.salary}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),
            SecondaryText(
              text: 'Posted by: ${job.postedByRole}',
              size: 13,
            ),
            const SizedBox(height: 14),

            /// ───── Tags (Subjects + JobType) ─────
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...job.subjects.map(
                      (s) => _chip(
                    text: s,
                    bg: GlobalVariables.selectedColor.withOpacity(0.12),
                    fg: GlobalVariables.selectedColor,
                  ),
                ),
                _chip(
                  text: job.jobType,
                  bg: GlobalVariables.greyBackgroundColor,
                  fg: Colors.black87,
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// ───── Divider ─────
            Divider(
              color: Colors.grey.withOpacity(0.15),
              height: 1,
            ),

            const SizedBox(height: 12),

            /// ───── Footer ─────
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: SecondaryText(
                    text: job.location ?? 'Location not specified',
                    size: 13,
                  ),
                ),
                TextButton(
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

                  child: Text(
                    'Apply',
                    style: TextStyle(
                      color: GlobalVariables.selectedColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip({
    required String text,
    required Color bg,
    required Color fg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: fg,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
