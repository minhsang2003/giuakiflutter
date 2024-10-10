import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    return File(image.path);
  }
  return null;
}

Future<String> uploadImage(File image) async {
  // Tạo đường dẫn trong Firebase Storage
  String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  Reference ref = FirebaseStorage.instance.ref().child('images/$fileName');

  // Upload file
  UploadTask uploadTask = ref.putFile(image);

  // Chờ quá trình upload hoàn thành
  TaskSnapshot taskSnapshot = await uploadTask;

  // Lấy URL của file sau khi upload xong
  return await taskSnapshot.ref.getDownloadURL();
}
