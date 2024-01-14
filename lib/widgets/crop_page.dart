import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class CropPage extends StatefulWidget {
  @override
  _CropPageState createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  final cropKey = GlobalKey<CropState>();
  File img;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      var args = ModalRoute.of(context).settings.arguments;
      img = args;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Expanded(
                child: img == null
                    ? SizedBox()
                    : Crop(key: cropKey, image: FileImage(img), aspectRatio: 3 / 3)),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () async {
                        var crop = cropKey.currentState;
                        var area = crop.area;
                        if (area != null) {
                          var croppedFile = await ImageCrop.cropImage(file: img, area: crop.area);
                          Navigator.pop(context, croppedFile);
                        }
                      },
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Icon(Icons.check_circle, color: Colors.white, size: 40))),
                  InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Icon(Icons.cancel, color: Colors.white, size: 40))),
                ])
          ])),
    );
  }
}
