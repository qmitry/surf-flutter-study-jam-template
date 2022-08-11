import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/common/app_colors.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/auth/screens/auth_screen.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

/// App,s main widget.
class MyApp extends StatelessWidget {
  /// Constructor for [MyApp].
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(primary: AppColors.primaryColor),
      ),
      home: AuthScreen(
        authRepository: AuthRepository(StudyJamClient()),
      ),
    );
  }
}
