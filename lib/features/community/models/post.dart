
class CommunityPost {
  final int id;
  final String authorUsername;
  final String content;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;

  const CommunityPost({
    required this.id,
    required this.authorUsername,
    required this.content,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as int,
      authorUsername: json['author_username'] as String,
      content: json['content'] as String,
      likesCount: json['likes_count'] as int,
      commentsCount: json['comments_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
