import 'package:flutter/material.dart';
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

class Comments extends StatefulWidget {
  final String? username;

  Comments({this.username});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _controller = TextEditingController();
  final List<Comment> _comments = [];

  void _addComment() {
    if (_controller.text.isNotEmpty && widget.username != null) {
      setState(() {
        _comments.insert(
          0,
          Comment(
            text: _controller.text,
            user: User(name: widget.username!),
            dateTime: DateTime.now(),
          ),
        );
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Comentários',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (widget.username != null)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 100),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Adicione um comentário...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _addComment,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey.shade800,
                    ),
                    child: const Text('Adicionar Comentário'),
                  ),
                ],
              ),
            ),
          ),
        if (widget.username == null)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Faça login para adicionar um comentário.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _comments.length,
            itemBuilder: (context, index) {
              final comment = _comments[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            comment.user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _formatDateTime(comment.dateTime),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(comment.text),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute}, ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
