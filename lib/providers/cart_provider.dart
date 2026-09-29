import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../helpers/db_helper.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _cartItems = [];
  List<CartModel> get cartItems => _cartItems;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  CartProvider() {
    fetchCart(); // Load data saat provider diinisialisasi
  }

  // Mengambil data dari SQLite (Offline First)
  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();

    _cartItems = await DatabaseHelper.instance.fetchCartItems();
    
    _isLoading = false;
    notifyListeners();
  }

  // Menghitung total harga belanjaan
  double get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Menghitung total jumlah barang (quantity) dalam keranjang
  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Menambahkan item ke keranjang
  Future<void> addToCart(int productId, String name, double price, String? imagePath) async {
    // Cek apakah item sudah ada di keranjang
    final existingItem = await DatabaseHelper.instance.getCartItemByProductId(productId);

    if (existingItem != null) {
      // Jika ada, tambahkan kuantitasnya
      existingItem.quantity += 1;
      await DatabaseHelper.instance.updateCartItem(existingItem);
    } else {
      // Jika belum ada, masukkan sebagai item baru
      final newItem = CartModel(
        productId: productId,
        name: name,
        price: price,
        quantity: 1,
        imagePath: imagePath, // Menyimpan image path ke keranjang
      );
      await DatabaseHelper.instance.insertCartItem(newItem);
    }

    // Refresh data dan beritahu UI
    await fetchCart();
  }

  // Mengurangi kuantitas atau menghapus item jika quantity == 0
  Future<void> decreaseQuantity(CartModel item) async {
    if (item.quantity > 1) {
      item.quantity -= 1;
      notifyListeners(); // Pembaruan instan (<100ms) untuk UI
      await DatabaseHelper.instance.updateCartItem(item);
    } else {
      // Hapus jika kuantitas akan menjadi 0
      _cartItems.remove(item);
      notifyListeners(); // Pembaruan instan (<100ms) untuk UI
      if (item.id != null) {
        await DatabaseHelper.instance.deleteCartItem(item.id!);
      }
    }
    // Sinkronisasi ulang (opsional)
    await fetchCart();
  }

  // Menambah kuantitas (fungsi spesifik untuk di cart_page)
  Future<void> increaseQuantity(CartModel item) async {
    item.quantity += 1;
    notifyListeners(); // Pembaruan instan (<100ms) untuk UI
    await DatabaseHelper.instance.updateCartItem(item);
    // Sinkronisasi ulang (opsional)
    await fetchCart();
  }

  // Melakukan Checkout (mengosongkan keranjang)
  Future<void> checkout() async {
    _cartItems.clear();
    notifyListeners(); // Pembaruan instan (<100ms) untuk UI
    await DatabaseHelper.instance.clearCart();
    await fetchCart();
  }
}
