class UserProfile {
  final int id;
  final String username;
  final String email;
  final String stylePersona;
  final String preferredStyle;
  final String consciousShoppingPriority;
  final String wardrobeGoal;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.stylePersona,
    required this.preferredStyle,
    required this.consciousShoppingPriority,
    required this.wardrobeGoal,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      stylePersona: json['style_persona'] ?? '',
      preferredStyle: json['preferred_style'] ?? '',
      consciousShoppingPriority:
          json['conscious_shopping_priority'] ?? '',
      wardrobeGoal: json['wardrobe_goal'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'style_persona': stylePersona,
      'preferred_style': preferredStyle,
      'conscious_shopping_priority':
          consciousShoppingPriority,
      'wardrobe_goal': wardrobeGoal,
    };
  }
}