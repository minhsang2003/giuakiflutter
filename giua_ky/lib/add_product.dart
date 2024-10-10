import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giua_ky/product.dart';
import 'package:giua_ky/utils.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();

  // Các controller để quản lý giá trị nhập vào
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  String? _imageUrl;

  @override
  void dispose() {
    // Hủy các controller khi không còn sử dụng
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_imageUrl == null) {
      AlertDialog(
        content: Text('Vui lòng chọn ảnh'),
      );
      return;
    }

    // Tạo một đối tượng Product từ thông tin nhập vào
    Product product = Product(
      name: _nameController.text,
      price: int.parse(_priceController.text),
      category: _categoryController.text,
      image: _imageUrl!,
    );

    await FirebaseFirestore.instance
        .collection('products')
        .add(product.toFirestore());

    _nameController.text = '';
    _priceController.text = '';
    _categoryController.text = '';
    setState(() {
      _imageUrl = null;
    });
  }

  void _onUploadImage() async {
    try {
      File? file = await pickImage();
      if (file == null) {
        return;
      }

      String res = await uploadImage(file);
      setState(() {
        _imageUrl = res;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Trường nhập tên sản phẩm
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the product name';
                }
                return null;
              },
            ),

            // Trường nhập giá sản phẩm
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the price';
                } else if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),

            // Trường nhập danh mục sản phẩm
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the category';
                }
                return null;
              },
            ),

            // Trường nhập đường dẫn ảnh sản phẩm
            Container(
              margin: EdgeInsets.only(top: 16),
              height: 58, // Chiều cao giống với các trường nhập liệu
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _onUploadImage,
                style: ButtonStyle(alignment: Alignment.centerLeft),
                child: Icon(Icons.upload_file),
              ),
            ),

            SizedBox(height: 20),

            // Nút submit
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Thêm sản phẩm'),
            ),
          ],
        ),
      ),
    );
  }
}
