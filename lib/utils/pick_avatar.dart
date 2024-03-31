import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickAvatar(ImageSource src) async{
    final ImagePicker _picker = ImagePicker();
    XFile? _file = await _picker.pickImage(source: src);
    if (_file != null) return await _file.readAsBytes();
    print("No Image Selected!");
}