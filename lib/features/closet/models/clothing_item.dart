class ClothingItem {
  final int id;
  final int user;
  final String? photo;
  final String? photoUrl;
  final String name;
  final String category;
  final String color;
  final String colorHex;
  final String material;
  final List<String> styles;
  final List<String> seasons;
  final List<String> weather;
  final String store;
  final String purchaseLink;
  final DateTime? datePurchased;
  final int? price;
  final String status;
  final DateTime createdAt;

  const ClothingItem({
    required this.id,
    required this.user,
    required this.photo,
    required this.photoUrl,
    required this.name,
    required this.category,
    required this.color,
    required this.colorHex,
    required this.material,
    required this.styles,
    required this.seasons,
    required this.weather,
    required this.store,
    required this.purchaseLink,
    required this.datePurchased,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: (json['id'] as num).toInt(),
      user: (json['user'] as num).toInt(),
      photo: json['photo'] as String?,
      photoUrl: json['photo_url'] as String?,
      name: json['name'] as String,
      category: json['category'] as String,
      color: json['color'] as String,
      colorHex: json['color_hex'] as String,
      material: json['material'] as String,
      styles: _stringList(json['styles']),
      seasons: _stringList(json['seasons']),
      weather: _stringList(json['weather']),
      store: json['store'] as String,
      purchaseLink: json['purchase_link'] as String,
      datePurchased: json['date_purchased'] == null
          ? null
          : DateTime.parse(json['date_purchased'] as String),
      price: (json['price'] as num?)?.toInt(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static List<String> _stringList(dynamic value) {
    return (value as List<dynamic>).cast<String>();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'photo': photo,
        'photo_url': photoUrl,
        'name': name,
        'category': category,
        'color': color,
        'color_hex': colorHex,
        'material': material,
        'styles': styles,
        'seasons': seasons,
        'weather': weather,
        'store': store,
        'purchase_link': purchaseLink,
        'date_purchased': datePurchased?.toIso8601String().split('T').first,
        'price': price,
        'status': status,
        'created_at': createdAt.toIso8601String(),
      };
}
