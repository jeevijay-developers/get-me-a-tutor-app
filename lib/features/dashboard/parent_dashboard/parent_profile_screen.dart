import 'package:get_me_a_tutor/import_export.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;

    String buildAddress(ParentAddress address) {
      final parts = [
        address.street,
        address.city,
        address.state,
        address.pincode,
      ].where((e) => e != null && e.trim().isNotEmpty).toList();

      return parts.isEmpty ? 'Not provided' : parts.join(', ');
    }

    return Consumer<ParentProfileProvider>(
      builder: (context, provider, _) {
        final parent = provider.parent;

        if (provider.isLoading) {
          return const Center(child: Loader());
        }

        if (parent == null) {
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
                    const CircleAvatar(
                      radius: 42,
                      backgroundColor: Color(0xFFEAEAEA),
                      child: Icon(Icons.person,
                          size: 36, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    PrimaryText(text: parent.name, size: 20),
                    const SizedBox(height: 4),
                    const SecondaryText(text: 'Parent', size: 14),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// ───────── Info Cards ─────────
              _infoCard(
                title: 'Email',
                value: parent.email!,
                icon: Icons.email,
              ),

              _infoCard(
                title: 'Phone',
                value: parent.phone!,
                icon: Icons.phone,
              ),

              _infoCard(
                title: 'City',
                value: parent.city ?? 'Not provided',
                icon: Icons.location_city,
              ),

              if (parent.address != null)
                _infoCard(
                  title: 'Address',
                  value: buildAddress(parent.address!),
                  icon: Icons.location_on,
                ),

              const SizedBox(height: 28),

              /// ───────── Stats ─────────
              Row(
                children: [
                  Expanded(
                    child: _statBox(
                      title: 'Credits',
                      value: parent.credits.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statBox(
                      title: 'Jobs Posted',
                      value: parent.jobsPosted.toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _statBox(
                      title: 'Tutors Hired',
                      value: parent.tutorsHired.toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// ───────── Actions ─────────
              CustomButton(
                text: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ParentProfileUpdateScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              _actionTile(
                text: 'Reset Password',
                icon: Icons.lock_reset,
                onTap: () {
                  _showResetPasswordDialog(context);
                },
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

                            final auth =
                            Provider.of<AuthProvider>(context, listen: false);
                            final parentProvider =
                            Provider.of<ParentProfileProvider>(
                              context,
                              listen: false,
                            );

                            await auth.logout(context: context);
                            parentProvider.clearParent();

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
                        'This will permanently delete your parent profile and log you out. '
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

                            final auth =
                            Provider.of<AuthProvider>(context, listen: false);
                            final parentProvider =
                            Provider.of<ParentProfileProvider>(
                              context,
                              listen: false,
                            );

                            final success =
                            await auth.deleteAccount(context: context);

                            if (success) {
                              parentProvider.clearParent();
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

  // ───────── Reusable Widgets ─────────

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
            Expanded(child: Text(text)),
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
            TextField(controller: tokenCtrl),
            const SizedBox(height: 12),
            TextField(controller: passwordCtrl, obscureText: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final auth =
              Provider.of<AuthProvider>(context, listen: false);
              await auth.resetPassword(
                context: context,
                email: auth.email!,
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
