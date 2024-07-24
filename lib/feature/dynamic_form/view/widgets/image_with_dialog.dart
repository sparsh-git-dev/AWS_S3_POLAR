import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final String imageUrl;
  final String imagePath;

  const ImageDialog(
      {super.key, required this.imageUrl, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            margin: const EdgeInsets.only(top: 45),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                imagePath.isNotEmpty
                    ? Image.file(File(imagePath))
                    : CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
