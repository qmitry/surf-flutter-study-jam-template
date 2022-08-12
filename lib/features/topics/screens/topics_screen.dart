import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_practice_chat_flutter/common/app_colors.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_dto.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/chart_topics_repository.dart';
import 'package:surf_practice_chat_flutter/common/globals.dart' as globals;

/// Screen with different chat topics to go to.
class TopicsScreen extends StatefulWidget {
  final IChatTopicsRepository chatTopicsRepository;

  /// Constructor for [TopicsScreen].
  const TopicsScreen({required this.chatTopicsRepository, Key? key})
      : super(key: key);

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  Iterable<ChatTopicDto> _currentTopics = [];
  String myName = 'temp';
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    _updateTopics();
    _updateName();

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: AppBar(
          title: Text(myName),
          backgroundColor: AppColors.appBarColor,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _TopicsBody(
              messages: _currentTopics,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateTopics() async {
    DateTime today = DateTime.now();
    DateTime tenDaysAgo = today.subtract(const Duration(days: 10));
    final messages = await widget.chatTopicsRepository
        .getTopics(topicsStartDate: tenDaysAgo);
    setState(() {
      _currentTopics = messages;
    });
  }

  Future<void> _updateName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final sjUser = await globals.client.getUser();
    final name = sjUser!.username ?? '';
    prefs.setString('name', name);

    setState(() {
      myName = prefs.getString('name') ?? '';
    });
  }
}

class _TopicsBody extends StatelessWidget {
  final Iterable<ChatTopicDto> messages;

  const _TopicsBody({
    required this.messages,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (_, index) => _TopicsWidget(
        topicsData: messages.elementAt(index),
      ),
    );
  }
}

class _TopicsWidget extends StatelessWidget {
  final ChatTopicDto topicsData;
  const _TopicsWidget({
    required this.topicsData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: AppColors.topicColor, minimumSize: const Size(0, 70)),
          onPressed: () {
            Navigator.push<ChatScreen>(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return ChatScreen(
                    chatRepository: ChatRepository(
                      globals.client,
                    ),
                  );
                },
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _TopicAvatar(id: topicsData.id),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topicsData.name ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      topicsData.description ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicAvatar extends StatelessWidget {
  static const double _size = 40;

  final int id;

  const _TopicAvatar({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: Material(
        color: AppColors.topicAvatarColor,
        shape: const CircleBorder(),
        child: Center(
          child: Text(
            id.toString(),
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
