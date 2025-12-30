import 'package:get_me_a_tutor/import_export.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String deadlineText() {
      if (job.deadline == null) return 'No deadline';
      final d = job.deadline!;
      return '${d.day}/${d.month}/${d.year}';
    }

    Color statusColor() {
      switch (job.status) {
        case 'active':
          return Colors.green;
        case 'closed':
          return Colors.red;
        default:
          return Colors.orange;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GlobalVariables.greyBackgroundColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───────── HEADER ─────────
            Row(
              children: [
                const Icon(Icons.work_outline, size: 20),
                const SizedBox(width: 10),

                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        const TextSpan(
                          text: 'Role: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: job.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor().withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    job.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ───────── SUBJECTS ─────────
            if (job.subjects.isNotEmpty) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Subjects:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: job.subjects
                        .map(
                          (s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          s,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],

            // ───────── GRID ROW 1 ─────────
            Row(
              children: [
                Expanded(
                  child: _infoTile(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: job.location ?? 'Not specified',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoTile(
                    icon: Icons.work_history_outlined,
                    label: 'Job Type',
                    value:
                    job.jobType.replaceAll('-', ' ').toUpperCase(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ───────── GRID ROW 2 ─────────
            Row(
              children: [
                Expanded(
                  child: _infoTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'Deadline',
                    value: deadlineText(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoTile(
                    icon: Icons.currency_rupee,
                    label: 'Salary',
                    value: job.salary != null
                        ? '₹${job.salary}'
                        : 'Not specified',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ───────── INFO TILE ─────────
  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SecondaryText(text: label, size: 11),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
