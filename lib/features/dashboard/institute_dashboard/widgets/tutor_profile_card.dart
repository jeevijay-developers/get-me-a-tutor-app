import 'package:get_me_a_tutor/import_export.dart';

class TutorProfileCard extends StatelessWidget {
  final TutorSearchModel tutor;
  final VoidCallback onViewProfile;

  const TutorProfileCard({
    super.key,
    required this.tutor,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(text: 'Tutor', size: 16),
          const SizedBox(height: 6),
          SecondaryText(
            text: tutor.bio,
            size: 13,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            children: tutor.subjects
                .map((s) => Chip(label: Text(s,style: TextStyle(color: Colors.black),)))
                .toList(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SecondaryText(
                text: '${tutor.experienceYears} yrs experience',
                size: 12,
              ),
              TextButton(
                onPressed: onViewProfile,
                child: Text(
                  'View Profile',
                  style: TextStyle(
                    color: GlobalVariables.selectedColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
