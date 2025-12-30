import 'package:get_me_a_tutor/import_export.dart';
class JobUpdateScreen extends StatefulWidget {
  static const String routeName = '/jobUpdate';
  final JobModel job;

  const JobUpdateScreen({super.key,required this.job});

  @override
  State<JobUpdateScreen> createState() => _JobUpdateScreenState();
}

class _JobUpdateScreenState extends State<JobUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final classRangeCtrl = TextEditingController();
  final salaryCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final subjectInputCtrl = TextEditingController();

  // state
  DateTime? deadline;
  String jobType = 'full-time';
  List<String> subjects = [];

  final jobTypes = ['full-time', 'part-time', 'contract'];

  @override
  void initState() {
    super.initState();

    final job = widget.job;

    titleCtrl.text = job.title;
    descCtrl.text = job.description ?? '';
    classRangeCtrl.text = job.classRange ?? '';
    salaryCtrl.text = job.salary?.toString() ?? '';
    locationCtrl.text = job.location ?? '';

    subjects = List.from(job.subjects);
    jobType = job.jobType;
    deadline = job.deadline;
  }

  // ───────────────────────── DEADLINE PICKER ─────────────────────────

  Future<void> pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: GlobalVariables.selectedColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => deadline = picked);
    }
  }

  // ───────────────────────── SUBMIT ─────────────────────────

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    if (deadline == null) {
      showSnackBar(context, 'Please select a deadline');
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Job'),
        content: const Text(
          'Are you sure you want to update this job?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // close dialog

              final jobProvider =
              Provider.of<JobProvider>(context, listen: false);

              final body = {
                'title': titleCtrl.text.trim(),
                'description': descCtrl.text.trim(),
                'subjects': subjects,
                'classRange': classRangeCtrl.text.trim(),
                'salary': int.tryParse(salaryCtrl.text) ?? 0,
                'location': locationCtrl.text.trim(),
                'jobType': jobType,
                'deadline': deadline!.toIso8601String(),
              };

              final success = await jobProvider.updateJob(
                context: context,
                jobId: widget.job.id,
                body: body,
              );

              if (success) {
                Navigator.pop(context); // close JobUpdateScreen
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── UI ─────────────────────────

  @override
  Widget build(BuildContext context) {
    const double labelGap = 8;     // between text label and its field
    const double fieldGap = 20;    // between one field block and the next
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: PrimaryText(text: 'Post a Job', size: 25),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.chevron_left,size: 40,color: Colors.black,)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: fieldGap),
                const PrimaryText(text: 'Job Title', size: 16),
                const SizedBox(height: labelGap),
                CustomTextField(
                  controller: titleCtrl,
                  hintText: 'Job Title',
                ),
                const SizedBox(height: fieldGap),
                const PrimaryText(text: 'Job Description', size: 16),
                const SizedBox(height: labelGap),
                CustomTextField(
                  controller: descCtrl,
                  hintText: 'Job Description',
                  maxLines: 4,
                ),
                const SizedBox(height: fieldGap),

                // SUBJECTS
                const PrimaryText(text: 'Subjects', size: 16),
                const SizedBox(height: labelGap),
                _chipInput(),

                const SizedBox(height: fieldGap),
                const PrimaryText(text: 'Class Range', size: 16),
                const SizedBox(height: labelGap),
                CustomTextField(
                  controller: classRangeCtrl,
                  hintText: 'Class Range (e.g. 6–10)',
                ),
                const SizedBox(height: fieldGap),
                const PrimaryText(text: 'Salary', size: 16),
                const SizedBox(height: labelGap),
                CustomTextField(
                  controller: salaryCtrl,
                  hintText: 'Salary (₹)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: fieldGap),
                const PrimaryText(text: 'Location', size: 16),
                const SizedBox(height: labelGap),
                CustomTextField(
                  controller: locationCtrl,
                  hintText: 'Location',
                ),
                const SizedBox(height: fieldGap),

                const PrimaryText(text: 'Job Type', size: 16),
                const SizedBox(height: labelGap),

                Row(
                  children: [
                    _jobTypeChip('full-time', 'Full Time'),
                    const SizedBox(width: 10),
                    _jobTypeChip('part-time', 'Part Time'),
                    const SizedBox(width: 10),
                    _jobTypeChip('contract', 'Contract'),
                  ],
                ),


                const SizedBox(height: fieldGap),

                // DEADLINE
                const PrimaryText(text: 'Application Deadline', size: 16),
                const SizedBox(height: labelGap),
                GestureDetector(
                  onTap: pickDeadline,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          deadline == null
                              ? 'Select deadline'
                              : '${deadline!.day}/${deadline!.month}/${deadline!.year}',
                          style: TextStyle(
                            color: deadline == null
                                ? GlobalVariables.secondaryTextColor
                                : Colors.black,
                          ),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                CustomButton(
                  text: 'Post Job',
                  onTap: submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────── SUBJECT CHIPS ─────────────────────────

  Widget _chipInput() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...subjects.map(
              (s) =>
              Chip(
                label: Text(s, style: TextStyle(color: Colors.black),),
                onDeleted: () => setState(() => subjects.remove(s)),
                deleteIcon: Icon(
                  Icons.remove_circle_outline_rounded, color: Colors.grey,),
              ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) =>
                  AlertDialog(
                    title: const Text('Add Subject'),
                    content: TextField(
                      controller: subjectInputCtrl,
                      decoration:
                      const InputDecoration(hintText: 'Enter subject'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (subjectInputCtrl.text.isNotEmpty) {
                            setState(() =>
                                subjects.add(subjectInputCtrl.text.trim()));
                            subjectInputCtrl.clear();
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
            );
          },
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: GlobalVariables.selectedColor),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 16),
                SizedBox(width: 6),
                Text('Add'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _jobTypeChip(String value, String label) {
    final bool selected = jobType == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => jobType = value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? GlobalVariables.selectedColor
                : GlobalVariables.greyBackgroundColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}