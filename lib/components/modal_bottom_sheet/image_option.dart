import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showImageOptionModalBottomSheet(BuildContext context,
    StateSetter setModalState, File? image, Function(File?) setImage) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 112,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Chụp ảnh"),
              onTap: () {
                //open camera
                pickImageFromCamera(setModalState, setImage);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Chọn ảnh từ thư viện"),
              onTap: () {
                //open gallery
                pickImageFromLibrary(setModalState, setImage);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

Future pickImageFromLibrary(
    StateSetter setModalState, Function(File) setImage) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile == null) return;
  setImage(File(pickedFile.path));
}

Future pickImageFromCamera(
    StateSetter setModalState, Function(File) setImage) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  if (pickedFile == null) return;
  setImage(File(pickedFile.path));
}
