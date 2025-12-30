import 'package:get_me_a_tutor/import_export.dart';
class TutorApplicationScreen extends StatefulWidget {
  static const String routeName = '/tutorApplication';
  final String tutorUserId;
  final String applicationId;
  final String currentStatus;
final String teacherName;
  const TutorApplicationScreen({
    super.key,
    required this.teacherName,
    required this.tutorUserId,
    required this.applicationId,
    required this.currentStatus,
  });

  @override
  State<TutorApplicationScreen> createState() =>
      _TutorApplicationScreenState();
}

class _TutorApplicationScreenState extends State<TutorApplicationScreen> {
  String _currentStatus = '';
  String _selectedStatus = '';
  @override
  void initState() {
    super.initState();
    _currentStatus =
    widget.currentStatus.isNotEmpty ? widget.currentStatus : 'applied';
    _selectedStatus = _currentStatus;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeacherProvider>(
        context,
        listen: false,
      ).fetchTeacherProfile(context, widget.tutorUserId);
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,

      appBar: AppBar(
        title: const PrimaryText(text: 'Tutor Profile', size: 22),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 34, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Consumer<TeacherProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: Loader());
          }

          final teacher = provider.teacher;
          if (teacher == null) {
            return const Center(child: Text('Tutor profile not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerCard(teacher, widget.teacherName),

                const SizedBox(height: 24),

                _sectionWrapper(
                  children: [
                    _infoCard(
                      icon: Icons.info_outline,
                      color: Colors.blue,
                      title: 'Bio',
                      value: teacher.bio ?? 'No bio provided',
                    ),

                    const SizedBox(height: 12),

                    _doubleInfoRow(
                      left: _smallCard(
                        Icons.badge,
                        Colors.orange,
                        'Experience',
                        '${teacher.experienceYears} yrs',
                      ),
                      right: _smallCard(
                        Icons.schedule,
                        Colors.green,
                        'Availability',
                        teacher.availability ?? 'Not specified',
                      ),
                    ),

                    if (teacher.expectedSalary != null) ...[
                      const SizedBox(height: 12),
                      _infoCard(
                        icon: Icons.currency_rupee,
                        color: Colors.purple,
                        title: 'Expected Salary',
                        value:
                        '₹${teacher.expectedSalary!.min} - ₹${teacher.expectedSalary!.max}',
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 24),

                _sectionWrapper(
                  title: 'Teaching Details',
                  children: [
                    _chipSection('Subjects', teacher.subjects),
                    _chipSection(
                      'Classes',
                      teacher.classes.map((e) => e.toString()).toList(),
                    ),
                    _chipSection('Languages', teacher.languages),
                  ],
                ),
                const SizedBox(height: 24),

                _sectionWrapper(
                  title: 'Resources',
                  children: [
                    // 📄 Resume
                    if (teacher.resume?.url != null &&
                        teacher.resume!.url!.isNotEmpty)
                      _resourceTile(
                        icon: Icons.picture_as_pdf,
                        color: Colors.red,
                        title: 'Resume',
                        actionText: 'View',
                        onTap: () async {
                          final uri = Uri.parse(teacher.resume!.url!);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            showSnackBar(context, 'Unable to open resume');
                          }
                        },
                      ),

                    if (teacher.resume?.url != null &&
                        teacher.resume!.url!.isNotEmpty)
                      const SizedBox(height: 12),

                    // 🎥 Demo Video
                    if (teacher.demoVideoUrl != null &&
                        teacher.demoVideoUrl!.isNotEmpty)
                      _resourceTile(
                        icon: Icons.play_circle_fill,
                        color: Colors.blue,
                        title: 'Demo Video',
                        actionText: 'Watch',
                        onTap: () async {
                          final uri = Uri.parse(teacher.demoVideoUrl!);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            showSnackBar(context, 'Unable to open video');
                          }
                        },
                      ),
                  ],
                ),

                const SizedBox(height: 120),
              ],
            ),
          );
        },
      ),

      /// ───────── UPDATE STATUS BUTTON ─────────
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
        child: ElevatedButton(
          onPressed: _openStatusSheet,
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalVariables.selectedColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text(
            'Update Application Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────── UI PARTS ─────────────────────────

  Widget _headerCard(TeacherModel teacher, String teacherName) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture - Centered
          CircleAvatar(
            radius: 55,
            backgroundColor: GlobalVariables.selectedColor.withOpacity(0.15),
            backgroundImage:
            teacher.photo?.url != null && teacher.photo!.url!.isNotEmpty
                ? NetworkImage(teacher.photo!.url!)
                : null,
            child: teacher.photo?.url == null
                ? Icon(
              Icons.person,
              size: 52,
              color: GlobalVariables.selectedColor.withOpacity(0.6),
            )
                : null,
          ),

          const SizedBox(height: 16),

          // Name with label
          Column(
            children: [

              Text(
                teacherName ?? 'Name not provided',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // City with icon and label
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                teacher.city ?? 'City not provided',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Status chip - centered
          _statusChip(_currentStatus),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _iconBubble(icon, color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _doubleInfoRow({required Widget left, required Widget right}) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }

  Widget _smallCard(
      IconData icon, Color color, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _iconBubble(icon, color, size: 20),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipSection(String title, List<String> values) {
    if (values.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: values
              .map(
                (v) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: GlobalVariables.selectedColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: GlobalVariables.selectedColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                v,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          )
              .toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _iconBubble(IconData icon, Color color, {double size = 20}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size, color: color),
    );
  }

  Widget _statusChip(String status) {
    Color color;
    switch (status) {
      case 'shortlisted':
        color = Colors.orange;
        break;
      case 'selected':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _sectionWrapper({
    String? title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
          ],
          ...children,
        ],
      ),
    );
  }

  // ───────────────────────── STATUS BOTTOM SHEET ─────────────────────────

  void _openStatusSheet() {
    _selectedStatus = _currentStatus;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Update Status',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Select the application status',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['shortlisted', 'rejected', 'selected']
                        .map(
                          (s) => ChoiceChip(
                        label: Text(
                          s.toUpperCase(),
                          style: TextStyle(
                            color: _selectedStatus == s
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                        selected: _selectedStatus == s,
                        selectedColor: GlobalVariables.selectedColor,
                        backgroundColor: Colors.grey.shade100,
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: _selectedStatus == s
                                ? GlobalVariables.selectedColor
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        onSelected: (_) {
                          setModalState(() => _selectedStatus = s);
                          setState(() => _selectedStatus = s);
                        },
                      ),
                    )
                        .toList(),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            foregroundColor: Colors.black87,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _updateStatus,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GlobalVariables.selectedColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }
  Future<void> _updateStatus() async {
    final success =
    await Provider.of<JobApplicationProvider>(context, listen: false)
        .updateApplicationStatus(
      context: context,
      applicationId: widget.applicationId,
      status: _selectedStatus,
    );

    if (success) {
      setState(() {
        _currentStatus = _selectedStatus; // ✅ update UI
      });

      showSnackBar(context, 'Status updated');
      Navigator.pop(context); // close bottom sheet only
      Navigator.pop(context);
    }
  }

  Widget _resourceTile({
    required IconData icon,
    required Color color,
    required String title,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _iconBubble(icon, color),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              actionText,
              style: TextStyle(
                color: GlobalVariables.selectedColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

}