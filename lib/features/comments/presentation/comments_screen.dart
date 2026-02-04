import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/comments_provider.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({super.key, required this.postId});

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentsProvider(widget.postId));
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: Column(
        children: [
          Expanded(
            child: comments.when(
              data: (list) => ListView(
                reverse: true,
                children: list
                    .map(
                      (c) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(c.photo),
                    ),
                    title: Text(c.author),
                    subtitle: Text(c.text),
                  ),
                )
                    .toList(),
              ),
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Error loading')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:
                    const InputDecoration(hintText: 'Write a comment'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (controller.text.isEmpty) return;

                    final refPost = FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.postId);

                    await refPost.collection('comments').add({
                      'uid': user.uid,
                      'authorName': user.displayName,
                      'authorPhotoUrl': user.photoURL,
                      'text': controller.text,
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                    await refPost.update({
                      'commentCount': FieldValue.increment(1),
                    });

                    controller.clear();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
