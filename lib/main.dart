import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/assignment_repository.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/features/home/view_models/home_view_model.dart';
import 'ui/features/home/views/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HighSchoolEnglishApp());
}

class HighSchoolEnglishApp extends StatelessWidget {
  const HighSchoolEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AssignmentRepository>(
          create: (_) => AssignmentRepository(),
        ),
        ChangeNotifierProxyProvider<AssignmentRepository, HomeViewModel>(
          create: (ctx) => HomeViewModel(repository: ctx.read<AssignmentRepository>()),
          update: (_, repo, prev) => prev ?? HomeViewModel(repository: repo),
        ),
      ],
      child: MaterialApp(
        title: '高中英语听说 (学生端)',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
