import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerController extends GetxController {
  static FilePickerController get instance => Get.find();
  final ImagePicker _picker = ImagePicker();

  final Rx<XFile?> _image = Rx<XFile?>(null);
  final RxList<XFile> _images = <XFile>[].obs;

  List<XFile> get images => _images;
  XFile? get image => _image.value;

  // Pick a single image
  Future<void> pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      _image.value = pickedImage;
    }
    update();
  }

  // Pick multiple images from gallery
  Future<void> pickImages(BuildContext context) async {
    final List<XFile> pickedImages = await _picker.pickMultiImage();
    _images.addAll(pickedImages);
    update();
  }

  // Remove all picked images
  void removeImages() {
    _images.clear();
    update();
  }

  // Remove a single picked image
  void removeImageFromIndex(int index) {
    if (index >= 0 && index < _images.length) {
      _images.removeAt(index);
    }
    update();
  }

  // Remove
  void removeImage() {
    _image.value = null;
    update();
  }

  // Clear all picked files
  void clearAll() {
    _images.clear();
    _image.value = null;
    update();
  }
}
