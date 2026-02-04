import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String uid;
  final String author;
  final String photo;
  final String text;
  final Timestamp createdAt;

  CommentModel({
    required this.id,
    required this.uid,
    required this.author,
    required this.photo,
    required this.text,
    required this.createdAt,
  });

  factory CommentModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      uid: d['uid'],
      author: d['authorName'],
      photo: d['authorPhotoUrl'],
      text: d['text'],
      createdAt: d['createdAt'],
    );
  }
}
