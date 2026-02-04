import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';


/// Firestore reference provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Post actions provider
final postActionsProvider = Provider<PostActionsProvider>((ref) {
  final firestore = ref.read(firestoreProvider);
  final user = ref.read(authStateProvider).value;
  return PostActionsProvider(
    firestore: firestore,
    uid: user?.uid,
    authorName: user?.displayName ?? '',
    authorPhoto: user?.photoURL ?? '',
  );
});

class PostActionsProvider {
  final FirebaseFirestore firestore;
  final String? uid;
  final String authorName;
  final String authorPhoto;

  PostActionsProvider({
    required this.firestore,
    required this.uid,
    required this.authorName,
    required this.authorPhoto,
  });

  /// =============================
  /// LIKE / UNLIKE POST
  /// =============================
  Future<void> toggleLike(String postId) async {
    if (uid == null) return;

    final postRef = firestore.collection('posts').doc(postId);
    final likeRef = postRef.collection('likes').doc(uid);

    await firestore.runTransaction((tx) async {
      final likeSnapshot = await tx.get(likeRef);

      if (likeSnapshot.exists) {
        // Unlike
        tx.delete(likeRef);
        tx.update(postRef, {
          'likeCount': FieldValue.increment(-1),
        });
      } else {
        // Like
        tx.set(likeRef, {
          'createdAt': FieldValue.serverTimestamp(),
        });
        tx.update(postRef, {
          'likeCount': FieldValue.increment(1),
        });
      }
    });
  }

  /// =============================
  /// CHECK IF USER LIKED POST
  /// =============================
  Stream<bool> isPostLiked(String postId) {
    if (uid == null) return const Stream.empty();

    return firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists);
  }

  /// =============================
  /// ADD COMMENT
  /// =============================
  Future<void> addComment({
    required String postId,
    required String text,
  }) async {
    if (uid == null || text.trim().isEmpty) return;

    final postRef = firestore.collection('posts').doc(postId);
    final commentRef = postRef.collection('comments').doc();

    await firestore.runTransaction((tx) async {
      tx.set(commentRef, {
        'uid': uid,
        'authorName': authorName,
        'authorPhotoUrl': authorPhoto,
        'text': text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      tx.update(postRef, {
        'commentCount': FieldValue.increment(1),
      });
    });
  }

  /// =============================
  /// FETCH COMMENTS STREAM
  /// =============================
  Stream<QuerySnapshot<Map<String, dynamic>>> getComments(String postId) {
    return firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }
}
