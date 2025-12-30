import 'package:get_me_a_tutor/import_export.dart';

class TeacherProfileScreen extends StatelessWidget {
  final String name;
  const TeacherProfileScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;

    return Consumer<TeacherProvider>(
      builder: (context, provider, _) {
        final teacher = provider.teacher;

        if (provider.isLoading) {
          return const Center(child: Loader());
        }

        if (teacher == null) {
          return const Center(
            child: SecondaryText(text: 'No profile data found', size: 20),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// ───────── Header ─────────
              Center(
                child: Column(
                  children: [
                    PrimaryText(
                      text: 'Your Profile',
                      size: 20,
                    ),
                    const SizedBox(height: 12),

                    CircleAvatar(
                      radius: 42,
                      backgroundColor: GlobalVariables.selectedColor.withOpacity(0.2),
                      backgroundImage: (teacher.photo?.url != null &&
                          teacher.photo!.url!.isNotEmpty)
                          ? NetworkImage(teacher.photo!.url!)
                          : null,
                      child: (teacher.photo?.url == null)
                          ? const Icon(Icons.person, size: 36)
                          : null,
                    ),


                    const SizedBox(height: 4),
                    SecondaryText(
                      text: name ?? 'Name not provided',
                      size: 14,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// ───────── Bio ─────────
              _infoCard(
                title: 'City',
                value: teacher.city ?? 'No city provided',
              ),
              _infoCard(
                title: 'Bio',
                value: teacher.bio ?? 'No bio provided',
              ),

              /// ───────── Experience ─────────
              _infoCard(
                title: 'Experience',
                value: '${teacher.experienceYears} years',
                icon: Icons.badge,
              ),

              /// ───────── Availability ─────────
              if (teacher.availability != null)
                _infoCard(
                  title: 'Availability',
                  value: teacher.availability!,
                  icon: Icons.schedule,
                ),

              /// ───────── Expected Salary ─────────
              if (teacher.expectedSalary != null)
                _infoCard(
                  title: 'Expected Salary',
                  value:
                  '₹${teacher.expectedSalary!.min} - ₹${teacher.expectedSalary!.max}',
                  icon: Icons.currency_rupee,
                ),

              const SizedBox(height: 20),

              /// ───────── Subjects ─────────
              _chipSection(
                title: 'Subjects',
                values: teacher.subjects,
              ),

              /// ───────── Classes ─────────
              _chipSection(
                title: 'Classes',
                values: teacher.classes.map((e) => e.toString()).toList(),
              ),

              /// ───────── Languages ─────────
              _chipSection(
                title: 'Languages',
                values: teacher.languages,
              ),

              /// ───────── Tags ─────────
              if (teacher.tags.isNotEmpty)
                _chipSection(
                  title: 'Tags',
                  values: teacher.tags,
                ),

              const SizedBox(height: 28),

              /// ───────── Stats ─────────
              Row(
                children: [
                  Expanded(
                    child: _statBox(
                      title: 'Credits',
                      value: teacher.credits.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statBox(
                      title: 'Jobs Applied',
                      value: teacher.jobsApplied.toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _statBox(
                      title: 'Exams Passed',
                      value: teacher.examsPassed.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statBox(
                      title: 'Rating',
                      value: teacher.rating.toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// ───────── Resume ─────────
              if (teacher.resume?.url != null && teacher.resume!.url!.isNotEmpty)
                _actionTile(
                  text: 'View Resume',
                  icon: Icons.picture_as_pdf,
                  onTap: () {
                    final url = teacher.resume!.url!;
                    launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                )
              else
                _infoCard(
                  title: 'Resume',
                  value: 'Not uploaded',
                  icon: Icons.picture_as_pdf,
                ),


              /// ───────── Demo Video ─────────
              if (teacher.demoVideoUrl != null && teacher.demoVideoUrl!.isNotEmpty)
                ListTile(
                  leading:
                  const Icon(Icons.play_circle_fill, color: Colors.red),
                  title: const Text(
                    'Watch Demo Video',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () async {
                    final uri = Uri.parse(teacher.demoVideoUrl!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      showSnackBar(context, 'Could not open video');
                    }
                  },
                )
              else
                _infoCard(
                  title: 'Demo Video',
                  value: 'Not uploaded',
                  icon: Icons.play_circle_fill,
                ),


              const SizedBox(height: 24),

              /// ───────── Actions ─────────
              CustomButton(
                text: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TeacherProfileUpdateScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              _actionTile(
                text: 'Reset Password',
                icon: Icons.lock_reset,
                onTap: () => _showResetPasswordDialog(context),
              ),

              _actionTile(
                text: 'Logout',
                icon: Icons.logout,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                            await authProvider.logout(context: context);
                            provider.clearTeacher();

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              HomeScreenNew.routeName,
                                  (_) => false,
                            );
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),


              _actionTile(
                text: 'Delete Account',
                icon: Icons.delete_forever,
                isDanger: true,
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Account'),
                      content: const Text(
                        'This will permanently delete your account and log you out.\n\n'
                            'This action cannot be undone.\n\nAre you sure?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);

                            final success =
                            await authProvider.deleteAccount(context: context);

                            if (success) {
                              provider.clearTeacher();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                HomeScreenNew.routeName,
                                    (_) => false,
                              );
                            }
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),


              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  // ───────── Helpers ─────────

  Widget _chipSection({
    required String title,
    required List<String> values,
  }) {
    if (values.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(text: title, size: 18),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: values.map((v) {
            return Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: GlobalVariables.selectedColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                v,
                style: TextStyle(
                  color: GlobalVariables.selectedColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GlobalVariables.greyBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(icon, size: 18, color: Colors.grey),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SecondaryText(text: title, size: 12),
                const SizedBox(height: 4),
                PrimaryText(text: value, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GlobalVariables.greyBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(text: value, size: 22),
          const SizedBox(height: 6),
          SecondaryText(text: title, size: 13),
        ],
      ),
    );
  }

  Widget _actionTile({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: GlobalVariables.greyBackgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: isDanger ? Colors.red : Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isDanger ? Colors.red : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    final tokenCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tokenCtrl,
              decoration:
              const InputDecoration(labelText: 'Reset Token'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration:
              const InputDecoration(labelText: 'New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final authProvider =
              Provider.of<AuthProvider>(context, listen: false);

              await authProvider.resetPassword(
                context: context,
                email: authProvider.email!,
                token: tokenCtrl.text.trim(),
                newPassword: passwordCtrl.text.trim(),
              );

              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
