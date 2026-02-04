import 'package:flutter/material.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/feed/presentation/feed_screen.dart';
import '../features/post/views/post_detail_screen.dart';
import '../features/profile/presentation/profile_screen.dart';



class AppRoutes {
  static const String login = '/login';
  static const String feed = '/feed';
  static const String profile = '/profile';
  static const String postDetail = '/post-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case feed:
        return MaterialPageRoute(
          builder: (_) => const FeedScreen(),
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );

      case postDetail:
        final postId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => PostDetailScreen(postId: postId),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
