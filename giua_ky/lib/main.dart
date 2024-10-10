import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:giua_ky/add_product.dart';
import 'package:giua_ky/product.dart';
import 'package:giua_ky/product_item.dart';
import 'package:giua_ky/update_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 24),
          padding: EdgeInsets.all(8.0),
          child: ProductContainer(),
        ),
      ),
    );
  }
}

class ProductContainer extends StatefulWidget {
  const ProductContainer({super.key});

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  final Stream<QuerySnapshot> _productsStream =
      FirebaseFirestore.instance.collection('products').snapshots();

  Product? _productUpdate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Dữ liệu sản phẩm',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        (_productUpdate == null)
            ? AddProduct()
            : UpdateProduct(
                goBack: () {
                  setState(() {
                    _productUpdate = null;
                  });
                },
                product: _productUpdate!,
              ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _productsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Có lỗi xảy ra');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final products = snapshot.data!.docs
                  .map(
                    (data) => Product.fromFirestore(
                      data as DocumentSnapshot<Map<String, dynamic>>,
                    ),
                  )
                  .toList();

              print('-----------------------');
              print(products);
              print('-----------------------');

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) => ProductItem(
                  product: products[index],
                  onUpdate: (Product product) {
                    setState(() {
                      _productUpdate = product;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
