import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerSheet {

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> show(BuildContext context) async {

    final result = await showModalBottomSheet<ImageSource>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  "Select Image",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    _option(
                      icon: Icons.camera_alt,
                      label: "Camera",
                      onTap: () {
                        Navigator.pop(context, ImageSource.camera);
                      },
                    ),

                    _option(
                      icon: Icons.photo_library,
                      label: "Gallery",
                      onTap: () {
                        Navigator.pop(context, ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == null) return null;

    final XFile? image = await _picker.pickImage(
      source: result,
      imageQuality: 80,
    );

    if (image == null) return null;

    return File(image.path);
  }

  static Widget _option({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [

          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, color: Colors.black87),
          ),

          const SizedBox(height: 6),

          Text(label),
        ],
      ),
    );
  }
}