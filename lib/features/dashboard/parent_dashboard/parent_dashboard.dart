import 'package:get_me_a_tutor/features/dashboard/parent_dashboard/parent_profile_screen.dart';
import 'package:get_me_a_tutor/features/dashboard/parent_dashboard/parent_profile_update_screen.dart';
import 'package:get_me_a_tutor/import_export.dart';

class ParentDashboard extends StatefulWidget {
  static const String routeName = '/parentDashboard';
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();

      if (auth.role == 'parent' && auth.token != null) {
        context
            .read<ParentProfileProvider>()
            .fetchMyParentProfile(context);
      }

      context
          .read<JobApplicationProvider>()
          .fetchRecentApplications(context);
    });
  }

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

      body: SafeArea(
        child: _currentIndex == 0
            ? RefreshIndicator(
            onRefresh: () async {
              await context
                  .read<JobApplicationProvider>()
                  .fetchRecentApplications(context);
            },
            child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              _topHeader(scale),

              const SizedBox(height: 24),
              PrimaryText(text: 'Dashboard', size: 28 * scale),
              const SizedBox(height: 4),
              const SecondaryText(
                text: "Here's what's happening today.",
                size: 14,
              ),

              const SizedBox(height: 20),

              /// ───────── Stats ─────────
              Consumer<ParentProfileProvider>(
                builder: (context, provider, _) {
                  final parent = provider.parent;

                  return Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          scale,
                          title: 'Tutors Hired',
                          value: '${parent?.tutorsHired ?? 0}',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          scale,
                          title: 'Active Jobs',
                          value: '${parent?.jobsPosted ?? 0}',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ActiveJobsScreen(
                                  jobsPosted:
                                  parent?.jobsPosted ?? 0,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              /// ───────── Credit Balance ─────────
              Consumer<ParentProfileProvider>(
                builder: (context, provider, _) {
                  final credits = provider.parent?.credits ?? 0;
                  final maxCredits = 1000;
                  final progress = credits == 0
                      ? 0.02
                      : (credits / maxCredits).clamp(0.0, 1.0);

                  return Container(
                    padding: EdgeInsets.all(16 * scale),
                    decoration: BoxDecoration(
                      color: GlobalVariables.selectedColor
                          .withOpacity(0.08),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            const PrimaryText(
                              text: 'Credit Balance',
                              size: 16,
                            ),
                            Text(
                              'Top up',
                              style: TextStyle(
                                color:
                                GlobalVariables.selectedColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          children: [
                            PrimaryText(
                              text: '$credits',
                              size: 32 * scale,
                            ),
                            const SizedBox(width: 6),
                            const SecondaryText(
                              text: 'credits available',
                              size: 14,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor:
                            GlobalVariables.greyBackgroundColor,
                            color: GlobalVariables.selectedColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              /// ───────── Quick Actions ─────────
              const PrimaryText(text: 'Quick Actions', size: 18),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _quickAction(
                      icon: Icons.add,
                      text: 'Post a Job',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          JobPostScreen.routeName,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _quickAction(
                      icon: Icons.search,
                      text: 'Search Tutors',
                      onTap: () {
                        setState(() => _currentIndex = 2);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// ───────── Recent Applications ─────────

              // Recent Applications
              Consumer<ParentProfileProvider>(
                builder: (context, provider, _) {
                  final parent = provider.parent;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const PrimaryText(
                        text: 'Recent Applications',
                        size: 18,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AllJobsScreen(
                                jobsPosted: parent!.jobsPosted,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: GlobalVariables.selectedColor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 12),

              Consumer<JobApplicationProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Loader();
                  }

                  if (provider.recentApplications.isEmpty) {
                    return SizedBox(
                      height: 180, // controls vertical centering area
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.check_circle_outline,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'You are all caught up!',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: provider.recentApplications.map(
                          (app) {
                        return RecentApplicationCard(
                          onTap: () {},
                          photo: app.tutorPhoto,
                          name: app.tutorName,
                          role: app.jobTitle,
                          time: timeAgo(app.createdAt),
                        );
                      },
                    ).toList(),
                  );
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        )
        )
            : _currentIndex == 1
            ? const Center(child: Text('Jobs Screen'))
            : _currentIndex == 2
            ? TutorDiscoveryScreen()
            : const ParentProfileScreen()
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: GlobalVariables.selectedColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.work), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  /// ───────── HEADER ─────────
  Widget _topHeader(double scale) {
    return Consumer<ParentProfileProvider>(
      builder: (context, provider, _) {
        final parent = provider.parent;

        return Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor:
              GlobalVariables.selectedColor.withOpacity(0.2),
              child: const Icon(Icons.person,
                  size: 32, color: Colors.black54),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SecondaryText(
                    text: 'Welcome back,', size: 12),
                PrimaryText(
                  text: parent?.name ?? 'Parent',
                  size: 16,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _statCard(
      double scale, {
        required String title,
        required String value,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16 * scale),
        decoration: BoxDecoration(
          color: GlobalVariables.greyBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(text: value, size: 28 * scale),
            const SizedBox(height: 6),
            SecondaryText(text: title, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: GlobalVariables.greyBackgroundColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}
