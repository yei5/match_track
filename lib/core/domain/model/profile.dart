class Profile {
  String id; // UID de Supabase Auth
  final String name;
  final String email;
  final DateTime createdAt;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  /// Para enviar a Supabase (ej: insert)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Para leer desde Supabase (ej: select)
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}