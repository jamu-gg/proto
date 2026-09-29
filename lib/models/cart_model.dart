class CartModel {
  final int? id; // ID cart item
  final int productId; // Referensi ke ID master_products
  final String name;
  final double price;
  int quantity; // Tidak final karena kuantitas dapat diubah
  final String? imagePath; // Tambahan untuk gambar di keranjang

  CartModel({
    this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.imagePath,
  });

  // Convert CartModel ke Map untuk SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image_path': imagePath,
    };
  }

  // Convert Map dari SQLite ke CartModel
  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'],
      productId: map['product_id'],
      name: map['name'],
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      imagePath: map['image_path'],
    );
  }
}
