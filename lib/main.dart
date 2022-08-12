import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_practice_chat_flutter/common/app_colors.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/auth/screens/auth_screen.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/chart_topics_repository.dart';
import 'package:surf_practice_chat_flutter/features/topics/screens/topics_screen.dart';
import 'common/globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  globals.token = await getToken();
  if (globals.token != '') {
    globals.client = globals.client.getAuthorizedClient(globals.token);
  }

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
      home: (globals.token != '')
          ? TopicsScreen(
              chatTopicsRepository: ChatTopicsRepository(globals.client))
          : AuthScreen(authRepository: AuthRepository(globals.client)),
    );
  }
}

Future<String> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') ?? '';
}

Future<bool> setToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('token', value);
}
