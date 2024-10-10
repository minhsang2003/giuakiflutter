import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giua_ky/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final dynamic _onUpdate;

  const ProductItem({
    super.key,
    required this.product,
    required onUpdate,
  }) : _onUpdate = onUpdate;

  void _onDeleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueAccent.shade700,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cột bên trái chứa ảnh sản phẩm
          Container(
            width: 100, // Chiều rộng ảnh
            height: 100, // Chiều cao ảnh
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 16), // Khoảng cách giữa ảnh và cột bên phải

          // Cột bên phải chứa thông tin sản phẩm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hàng 1: Tên sản phẩm
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  product.price.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 8),
                // Hàng 2: Loại sản phẩm
                Text(
                  product.category,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 24,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  _onUpdate(product);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                      color: Colors.yellow.shade500,
                    ),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.yellow.shade500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  _onDeleteProduct(product.id!);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                      color: Colors.red.shade500,
                    ),
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red.shade500,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
