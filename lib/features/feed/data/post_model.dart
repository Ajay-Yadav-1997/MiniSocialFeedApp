import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String text;
  final String author;
  final String photo;      // Author avatar
  final String postImage;  // User-uploaded image
  final int likes;
  final int comments;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.text,
    required this.author,
    required this.photo,
    required this.postImage,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  factory PostModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};

    return PostModel(
      id: doc.id,
      text: d['text'] ?? '',
      author: d['authorName'] ?? 'Anonymous',
      photo: d['authorPhotoUrl'] ?? '',
      postImage: d['photo'] ?? '', // <-- this is the post image
      likes: (d['likeCount'] ?? 0) as int,
      comments: (d['commentCount'] ?? 0) as int,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
