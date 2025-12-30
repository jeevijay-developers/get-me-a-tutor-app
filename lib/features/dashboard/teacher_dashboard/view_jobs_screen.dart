import 'package:get_me_a_tutor/import_export.dart';

class TutorViewJobsScreen extends StatefulWidget {
  static const String routeName = '/tutorViewJobs';

  const TutorViewJobsScreen({super.key});

  @override
  State<TutorViewJobsScreen> createState() => _TutorViewJobsScreenState();
}

class _TutorViewJobsScreenState extends State<TutorViewJobsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobProvider>(context, listen: false).fetchTutorJobs(context);
    });

    _searchCtrl.addListener(() {
      setState(() {
        _query = _searchCtrl.text.toLowerCase().trim();
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const PrimaryText(text: 'Available Jobs', size: 18),
      ),
      body: Consumer<JobProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: Loader());
          }

          // 🔍 filter jobs
          final filteredJobs = provider.tutorJobs.where((job) {
            if (_query.isEmpty) return true;

            final data = [
              job.title,
              job.classRange ?? '',
              job.jobType,
              job.location ?? '',
              ...job.subjects,
            ].join(' ').toLowerCase();

            return data.contains(_query);
          }).toList();

          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                /// ───────── Search Bar ─────────
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * scale,
                    vertical: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: 'Search by subject, class, role...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (_searchCtrl.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                /// ───────── Job List ─────────
                Expanded(
                  child: filteredJobs.isEmpty
                      ? const Center(
                          child: SecondaryText(
                            text: 'No jobs match your search',
                            size: 16,
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16 * scale,
                            vertical: 12,
                          ),
                          itemCount: filteredJobs.length,
                          itemBuilder: (context, index) {
                            return JobPostingCard(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TeacherJobDescriptionScreen(
                                      job: filteredJobs[index],
                                    ),
                                  ),
                                );
                              },
                              job: filteredJobs[index],
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
