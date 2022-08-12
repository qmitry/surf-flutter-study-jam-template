import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_practice_chat_flutter/common/app_colors.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/auth/screens/auth_screen.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_study_jam/surf_study_jam.dart';
import 'common/globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  globals.token = await getToken();
  if (globals.token != '') {
    globals.client = globals.client.getAuthorizedClient(globals.token);
    // try {
    //   globals.userData = globals.client.getUser();
    // } on Object catch (e) {}
  }

  runApp(const MyApp());
}

/// App,s main widget.
class MyApp extends StatelessWidget {
  /// Constructor for [MyApp].
  const MyApp({Key? key}) : super(key: key);
  //final token = '4';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(primary: AppColors.primaryColor),
      ),
      home: (globals.token != '')
          ? ChatScreen(
              chatRepository: ChatRepository(
                //StudyJamClient().getAuthorizedClient(token.token),
                globals.client,
              ),
            )
          : AuthScreen(authRepository: AuthRepository(globals.client)),
      //home: AuthScreen(authRepository: AuthRepository(globals.client)),
      //home: AuthScreen(authRepository: AuthRepository(StudyJamClient())),
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
