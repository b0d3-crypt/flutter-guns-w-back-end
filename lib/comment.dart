import 'package:gun_store/user.dart';

class Comment {
  final String text;
  final User user;
  final DateTime dateTime;

  Comment({
    required this.text,
    required this.user,
    required this.dateTime,
  });
}
