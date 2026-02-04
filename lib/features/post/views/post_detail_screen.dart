import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/post_actions_provider.dart';

class PostDetailScreen extends ConsumerWidget {
  final String postId;

  const PostDetailScreen({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = TextEditingController();

    final commentsStream =
    ref.read(postActionsProvider).getComments(postId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          /// COMMENTS LIST
          Expanded(
            child: StreamBuilder(
              stream: commentsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading comments'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final comments = snapshot.data!.docs;

                if (comments.isEmpty) {
                  return const Center(
                    child: Text('No comments yet'),
                  );
                }

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final data = comments[index].data();

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                        NetworkImage(data['authorPhotoUrl'] ?? ''),
                      ),
                      title: Text(data['authorName'] ?? ''),
                      subtitle: Text(data['text'] ?? ''),
                    );
                  },
                );
              },
            ),
          ),

          /// ADD COMMENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      await ref.read(postActionsProvider).addComment(
                        postId: postId,
                        text: commentController.text,
                      );
                      commentController.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
