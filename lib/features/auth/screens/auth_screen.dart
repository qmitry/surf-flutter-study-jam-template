import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

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
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
              controller: nameController,
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
              controller: passwordController,
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
                //print(nameController.text);
                //print(passwordController.text);
                TokenDto token = await widget.authRepository.signIn(
                    login: nameController.text,
                    password: passwordController.text);
                _pushToChat(context, token);
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
            ),
          );
        },
      ),
    );
  }
}
