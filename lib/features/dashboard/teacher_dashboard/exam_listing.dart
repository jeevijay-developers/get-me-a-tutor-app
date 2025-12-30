import 'package:get_me_a_tutor/import_export.dart';

class ExamListingScreen extends StatelessWidget {
  static const String routeName = '/examListing';

  const ExamListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;

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
        title: const PrimaryText(text: 'Exam Center', size: 18),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.help_outline, color: Colors.black),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            /// ───────── Top Stats ─────────
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: Colors.blue,
                    value: '120',
                    label: 'CREDITS BALANCE',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    icon: Icons.star,
                    iconColor: Colors.orange,
                    value: '4.8',
                    label: 'CURRENT RATING',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ───────── Filters ─────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip('All Subjects', selected: true),
                  _filterChip('Mathematics'),
                  _filterChip('Science'),
                  _filterChip('Languages'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const PrimaryText(text: 'Available Now', size: 18),
            const SizedBox(height: 12),

            /// ───────── Exam Cards ─────────
            _examCard(
              level: 'ADVANCED',
              duration: '2H',
              title: 'Calculus II Final',
              subtitle: 'University of California • Math Dept',
              credits: '+50 Credits',
              rating: 'High',
              primaryAction: 'Start Exam',
              highlight: true,
            ),

            _examCard(
              level: 'INTERMEDIATE',
              duration: '1.5H',
              title: 'Organic Chemistry 101',
              subtitle: 'Science Academy • Chem Dept',
              credits: '+35 Credits',
              rating: 'Normal',
              primaryAction: 'View Details',
            ),

            _examCard(
              level: 'BEGINNER',
              duration: '45M',
              title: 'Intro to Spanish',
              subtitle: 'Language Center • Spanish Dept',
              credits: '+15 Credits',
              rating: 'Normal',
              primaryAction: 'View Details',
            ),

            _examCard(
              level: 'ADVANCED',
              duration: '3H',
              title: 'Quantum Physics A',
              subtitle: 'Tech Institute • Physics Dept',
              credits: '+80 Credits',
              rating: 'High',
              primaryAction: 'View Details',
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ───────────────── Widgets ─────────────────

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: iconColor),
          const SizedBox(height: 10),
          PrimaryText(text: value, size: 22),
          const SizedBox(height: 4),
          SecondaryText(text: label, size: 12),
        ],
      ),
    );
  }

  Widget _filterChip(String text, {bool selected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? GlobalVariables.selectedColor : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: selected
              ? GlobalVariables.selectedColor
              : Colors.grey.shade300,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _examCard({
    required String level,
    required String duration,
    required String title,
    required String subtitle,
    required String credits,
    required String rating,
    required String primaryAction,
    bool highlight = false,
  }) {
    Color levelColor;
    switch (level) {
      case 'ADVANCED':
        levelColor = Colors.purple;
        break;
      case 'INTERMEDIATE':
        levelColor = Colors.blue;
        break;
      default:
        levelColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: levelColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  level,
                  style: TextStyle(
                    color: levelColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              SecondaryText(text: duration, size: 12),
            ],
          ),

          const SizedBox(height: 12),

          PrimaryText(text: title, size: 18),
          const SizedBox(height: 4),
          SecondaryText(text: subtitle, size: 13),

          const SizedBox(height: 16),

          /// Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SecondaryText(text: 'EARN', size: 11),
                  PrimaryText(text: credits, size: 14),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SecondaryText(text: 'RATING', size: 11),
                  Text(
                    rating,
                    style: TextStyle(
                      color:
                      rating == 'High' ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: highlight
                      ? GlobalVariables.selectedColor
                      : GlobalVariables.greyBackgroundColor,
                  foregroundColor:
                  highlight ? Colors.white : Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(primaryAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
