import 'package:get_me_a_tutor/import_export.dart';

class InstituteProfileScreen extends StatelessWidget {
  const InstituteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;
    String buildAddress(InstitutionAddress address) {
      final parts = [
        address.street,
        address.city,
        address.state,
        address.pincode,
      ].where((e) => e != null && e.trim().isNotEmpty).toList();

      return parts.isEmpty ? 'Not provided' : parts.join(', ');
    }

    return Consumer<InstituteProvider>(
      builder: (context, provider, _) {
        final institute = provider.institution;
        final hasLogo =
            institute?.logo != null && institute!.logo!.trim().isNotEmpty;
        if (provider.isLoading) {
          return const Center(child: Loader());
        }

        if (institute == null) {
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
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: GlobalVariables.selectedColor
                          .withOpacity(0.2),
                      backgroundImage: hasLogo
                          ? NetworkImage(institute.logo!)
                          : null,
                      child: !hasLogo
                          ? const Icon(
                        Icons.school,
                        size: 32,
                        color: Colors.black54,
                      )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    PrimaryText(text: institute.institutionName, size: 20),
                    const SizedBox(height: 4),
                    SecondaryText(text: institute.institutionType, size: 14),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// ───────── Info Card ─────────
              _infoCard(
                title: 'About',
                value: institute.about ?? 'No description provided',
              ),

              _infoCard(
                title: 'Email',
                value: institute.email ?? 'Not provided',
                icon: Icons.email,
              ),

              _infoCard(
                title: 'Phone',
                value: institute.phone ?? 'Not provided',
                icon: Icons.phone,
              ),

              _infoCard(
                title: 'Website',
                value: institute.website ?? 'Not provided',
                icon: Icons.language,
              ),

              if (institute.address != null)
                _infoCard(
                  title: 'Address',
                  value: buildAddress(institute.address!),
                  icon: Icons.location_on,
                ),

              const SizedBox(height: 28),

              /// ───────── Stats ─────────
              Row(
                children: [
                  Expanded(
                    child: _statBox(
                      title: 'Credits',
                      value: institute.credits.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statBox(
                      title: 'Jobs Posted',
                      value: institute.jobsPosted.toString(),
                    ),
                  ),
                ],
              ),

              // ───────── Gallery Images ─────────
              const SizedBox(height: 24),
              const PrimaryText(text: 'Gallery', size: 18),
              const SizedBox(height: 12),

              Consumer<InstituteProvider>(
                builder: (context, provider, _) {
                  final images = provider.institution?.galleryImages ?? [];

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: GlobalVariables.greyBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: images.isEmpty
                        ? Column(
                            children: const [
                              Icon(
                                Icons.photo_library_outlined,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              SecondaryText(
                                text: 'No gallery images uploaded yet',
                                size: 14,
                              ),
                            ],
                          )
                        : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: images.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // 👈 4 images per row
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1, // square
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            image: DecorationImage(
                              image: NetworkImage(images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    )

                  );
                },
              ),

              const SizedBox(height: 32),

              /// ───────── Actions ─────────
              CustomButton(
                text: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InstituteProfileUpdateScreen(),
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

                            final authProvider = Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            );
                            final instituteProvider =
                                Provider.of<InstituteProvider>(
                                  context,
                                  listen: false,
                                );

                            await authProvider.logout(context: context);
                            instituteProvider.clearInstitute();

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              HomeScreenNew.routeName,
                              (route) => false,
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
                        'This will permanently delete your institute profile and log you out. '
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
                            final instituteProvider =
                            Provider.of<InstituteProvider>(context, listen: false);

                            final success = await authProvider.deleteAccount(context: context);

                            if (success) {
                              instituteProvider.clearInstitute();

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
            Icon(icon, color: isDanger ? Colors.red : Colors.black, size: 20),
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
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tokenCtrl,
              decoration: const InputDecoration(
                labelText: 'Reset Token',
                hintText: 'Enter token from email',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
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
              if (tokenCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
                showSnackBar(context, 'All fields are required');
                return;
              }

              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );

              final success = await authProvider.resetPassword(
                context: context,
                email: authProvider.email!,
                token: tokenCtrl.text.trim(),
                newPassword: passwordCtrl.text.trim(),
              );

              if (success) {
                Navigator.pop(context);
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
