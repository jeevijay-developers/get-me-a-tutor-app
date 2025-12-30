import 'package:get_me_a_tutor/import_export.dart';
Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SelectRoleScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SelectRoleScreen(),
      );
    case ActiveJobsScreen.routeName:
      final jobsPosted = routeSettings.arguments as int;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ActiveJobsScreen(jobsPosted: jobsPosted,),
      );
    case AllJobsScreen.routeName:
      final jobsPosted = routeSettings.arguments as int;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AllJobsScreen(jobsPosted: jobsPosted,),
      );
    case JobPostScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const JobPostScreen(),
      );
    case AllApplicationsScreen.routeName:
      final jobId = routeSettings.arguments as String;
      final jobTitle = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AllApplicationsScreen(jobId: jobId, jobTitle: jobTitle),
      );
    case JobDescriptionScreen.routeName:
      final job = routeSettings.arguments as JobModel;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => JobDescriptionScreen(job: job,),
      );
    case JobUpdateScreen.routeName:
      final job = routeSettings.arguments as JobModel;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => JobUpdateScreen(job: job,),
      );
    case InstituteDashboard.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const InstituteDashboard(),
      );
    case StudentDashboard.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const StudentDashboard(),
      );
    case TeacherDashboard.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const TeacherDashboard(),
      );
    case ParentDashboard.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ParentDashboard(),
      );
    case InstituteProfileCreateScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const InstituteProfileCreateScreen(),
      );
    case StudentProfileScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const StudentProfileScreen(),
      );
    case ParentProfileCreateScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ParentProfileCreateScreen(),
      );
    case TeacherProfileCreateScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const TeacherProfileCreateScreen(),
      );
    case ParentProfileUpdateScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ParentProfileUpdateScreen(),
      );
    case TeacherProfileUpdateScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const TeacherProfileUpdateScreen(),
      );
    case ForgotPasswordScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ForgotPasswordScreen(),
      );
    case LoginScreenNew.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreenNew(),
      );
    case SignupSuccessScreen.routeName:
      final role = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SignupSuccessScreen(role: role,),
      );
    case SignUpDetailsScreen.routeName:
      final selectedRole = routeSettings.arguments as String?;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SignUpDetailsScreen(selectedRole: selectedRole),
      );
    case HomeScreenNew.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreenNew(),
      );
    case TutorViewJobsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const TutorViewJobsScreen(),
      );
    case ExamListingScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ExamListingScreen(),
      );
    case AppliedJobsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AppliedJobsScreen(),
      );
    case TeacherJobDescriptionScreen.routeName:
    final job = routeSettings.arguments as JobModel?;
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => TeacherJobDescriptionScreen(job: job!,),
    );
    case TutorProfileViewScreen.routeName:
      final userId = routeSettings.arguments as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => TutorProfileViewScreen(userId: userId),
      );


    case OtpVerifyScreen.routeName:
      final email = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OtpVerifyScreen(email: email),
      );
    case TutorApplicationScreen.routeName:
      final tutorUserId = routeSettings.arguments as String;
      final applicationId = routeSettings.arguments as String;
      final currentStatus = routeSettings.arguments as String;
      final name  = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => TutorApplicationScreen(tutorUserId: tutorUserId, applicationId: applicationId, currentStatus: currentStatus,teacherName: name,),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>
        const Scaffold(body: Center(child: Text('Screen does not exist'))),
      );
  }
}
