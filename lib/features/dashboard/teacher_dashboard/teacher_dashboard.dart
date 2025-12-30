import 'package:get_me_a_tutor/import_export.dart';

class TeacherDashboard extends StatefulWidget {
  static const String routeName = '/teacherDashboard';
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      if (auth.userId != null) {
        Provider.of<TeacherProvider>(
          context,
          listen: false,
        ).fetchTeacherProfile(
          context,
          auth.userId!, // 👈 THIS is the key
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final scale = MediaQuery.of(context).size.width / 393;

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: _currentIndex == 0
            ? _dashboard(scale)
            : _currentIndex == 1
            ? const Center(child: Text('Jobs Screen'))
            : _currentIndex == 2
            ? const Center(child: Text('Exams Screen'))
            : TeacherProfileScreen(name: auth.name ?? 'No name provided'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: GlobalVariables.selectedColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  // ───────────────── DASHBOARD ─────────────────

  Widget _dashboard(double scale) {
    return Consumer2<TeacherProvider, AuthProvider>(
      builder: (context, teacherProvider, authProvider, _) {
        if (teacherProvider.isLoading) {
          return const Center(child: Loader());
        }

        final t = teacherProvider.teacher;
        if (t == null) {
          return const Center(
            child: SecondaryText(text: 'No profile found', size: 18),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// ───────── Header (Improved) ─────────
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: GlobalVariables.selectedColor.withOpacity(0.15),
                        backgroundImage: (t.photo?.url != null && t.photo!.url!.isNotEmpty)
                            ? NetworkImage(t.photo!.url!)
                            : null,
                        child: (t.photo?.url == null || t.photo!.url!.isEmpty)
                            ? const Icon(Icons.person, size: 22)
                            : null,
                      ),

                      if (t.isActive == true)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SecondaryText(text: 'Welcome back,', size: 12),
                      PrimaryText(
                        text: authProvider.name ?? 'Teacher',
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              PrimaryText(text: 'Dashboard', size: 28 * scale),
              const SizedBox(height: 4),
              const SecondaryText(
                text: "Here's what's happening today.",
                size: 14,
              ),

              const SizedBox(height: 20),

              /// ───────── Stats (Decorated) ─────────
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      onTap: (){},
                      icon: Icons.star,
                      title: 'Rating',
                      value: '${t.rating ?? 0}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      onTap: (){},
                      icon: Icons.verified,
                      title: 'Exams Passed',
                      value: '${t.examsPassed ?? 0}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      onTap: (){
                        Navigator.pushNamed(context, AppliedJobsScreen.routeName);
                      },
                      icon: Icons.work_outline,
                      title: 'Jobs Applied',
                      value: '${t.jobsApplied ?? 0}',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// ───────── Credits (EXACT same as InstituteDashboard) ─────────
              Container(
                padding: EdgeInsets.all(16 * scale),
                decoration: BoxDecoration(
                  color: GlobalVariables.selectedColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const PrimaryText(text: 'Credit Balance', size: 16),
                        Text(
                          'Top up',
                          style: TextStyle(
                            color: GlobalVariables.selectedColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        PrimaryText(
                          text: '${t.credits ?? 0}',
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
                        value: ((t.credits ?? 0) / 1000).clamp(0.02, 1),
                        minHeight: 8,
                        backgroundColor: GlobalVariables.greyBackgroundColor,
                        color: GlobalVariables.selectedColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// ───────── Quick Actions ─────────
              const PrimaryText(text: 'Quick Actions', size: 18),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _quickAction(
                      icon: Icons.shopping_cart,
                      text: 'Buy Credits',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _quickAction(
                      icon: Icons.work,
                      text: 'View Jobs',
                      onTap: () {
                        Navigator.pushNamed(context, TutorViewJobsScreen.routeName);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _quickAction(
                icon: Icons.school,
                text: 'Take Exams',
                onTap: () {
                  Navigator.pushNamed(context, ExamListingScreen.routeName);
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  // ───────────────── Widgets ─────────────────

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GlobalVariables.greyBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: GlobalVariables.selectedColor),
            const SizedBox(height: 8),
            PrimaryText(text: value, size: 22),
            const SizedBox(height: 4),
            SecondaryText(text: title, size: 13),
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
