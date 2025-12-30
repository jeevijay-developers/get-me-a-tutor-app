import 'package:get_me_a_tutor/import_export.dart';

class RecentApplicationCard extends StatelessWidget {
  final String name;
  final String role;
  final String time;
  final String? photo;
  final  VoidCallback onTap;
  const RecentApplicationCard({
    super.key,
    this.photo,
    required this.name,
    required this.role,
    required this.time,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: GlobalVariables.selectedColor.withOpacity(0.15),
              backgroundImage: photo != null &&
                  photo!.isNotEmpty
                  ? NetworkImage(photo!)
                  : null,
              child: (photo == null || photo!.isEmpty)
                  ? const Icon(Icons.person, color: Colors.black)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'Applied for $role',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(time, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
