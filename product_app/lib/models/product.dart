import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final int price;
  final int stok;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stok,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
      stok: data['stok'] ?? 0,
    );
  }
}
