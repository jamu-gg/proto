class ProductModel {
  final int? id;
  final String name;
  final double price;
  final String? imagePath; // Tambahan untuk gambar

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    this.imagePath,
  });

  // Convert ProductModel ke Map untuk SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image_path': imagePath,
    };
  }

  // Convert Map dari SQLite ke ProductModel
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: (map['price'] ?? 0).toDouble(),
      imagePath: map['image_path'],
    );
  }
}
