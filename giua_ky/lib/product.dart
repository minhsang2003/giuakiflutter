import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String name;
  final int price;
  final String category;
  final String image;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
  });

  // Phương thức fromFirestore để chuyển đổi từ DocumentSnapshot sang Product
  factory Product.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Product(
      id: snapshot.id,
      name: data?['name'] ?? '',
      price: data?['price'] ?? 0,
      category: data?['category'] ?? '',
      image: data?['image'] ?? '',
    );
  }

  // Phương thức toFirestore để chuyển đối tượng Product sang Map (dành cho Firestore)
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'image': image,
    };
  }

  @override
  String toString() {
    return '''
    Product('name': $name,
      'price': $price,
      'category': $category,
      'image': $image)
''';
  }
}
