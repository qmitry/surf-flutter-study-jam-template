import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/common/app_colors.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_practice_chat_flutter/main.dart';
import 'package:surf_study_jam/surf_study_jam.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:surf_practice_chat_flutter/common/globals.dart' as globals;

/// Screen for authorization process.
///
/// Contains [IAuthRepository] to do so.
class AuthScreen extends StatefulWidget {
  /// Repository for auth implementation.
  final IAuthRepository authRepository;

  /// Constructor for [AuthScreen].
  const AuthScreen({
    required this.authRepository,
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                labelText: 'Логин',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                labelText: 'Пароль',
              ),
            ),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: ElevatedButton(
              child: const Text(
                'ДАЛЕЕ',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () async {
                try {
                  final TokenDto tokenDto = await widget.authRepository.signIn(
                      login: _nameController.text,
                      password: _passwordController.text);
                  setToken(tokenDto.token);
                  TokenDto gottenTokenDto = TokenDto(token: await getToken());
                  _pushToChat(context, gottenTokenDto);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Ошибка!',
                      message: 'Неверное имя пользователя или пароль',
                      contentType: ContentType.failure,
                    ),
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _pushToChat(BuildContext context, TokenDto token) {
    Navigator.push<ChatScreen>(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ChatScreen(
            chatRepository: ChatRepository(
              StudyJamClient().getAuthorizedClient(token.token),
              //globals.client.getAuthorizedClient(token.token),
            ),
          );
        },
      ),
    );
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  static Future<bool> setToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', value);
  }
}
