import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key? key, required this.imagePickFn})
      : super(key: key);

  final Function(
    File pickedImage,
  ) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  void _pickImage(ImageSource souruce) async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(
        source: souruce,
        imageQuality: 80,
        maxHeight: 300,
        maxWidth: 300,
      );
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        widget.imagePickFn(_image!);
      }
    } catch (e) {
      print('Picker error' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _image != null ? FileImage(_image!) : null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () {
                _pickImage(ImageSource.camera);
              },
              icon: const Icon(Icons.camera),
              label: const Text(
                'Take foto',
              ),
            ),
            const Text('or'),
            TextButton.icon(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              icon: const Icon(Icons.image),
              label: const Text(
                'Add image',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
