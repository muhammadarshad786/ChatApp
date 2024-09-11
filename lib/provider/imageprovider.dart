import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageproviderSet extends ChangeNotifier {
  XFile? _file;
  XFile? get file => _file;

  String? _filePath;
  String? get filePath => _filePath;

  bool _switch = true;
  bool get sswitch => _switch;

  Future<void> getImageFromGallery() async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _file = image;
        _filePath = image.path;
        notifyListeners();
      } else {
        print('No image selected from gallery');
      }
    } catch (e) {
      print(e);
    }
  }

  void changeBool() {
    _switch = !_switch;
    notifyListeners();
  }
}