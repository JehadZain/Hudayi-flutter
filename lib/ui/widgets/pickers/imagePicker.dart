import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hudayi/ui/widgets/dropDownBottomSheet.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final XFile? path;
  final List<XFile>? paths;
  final Function() galleryOnTap;
  final Function() cameraOnTap;
  final Function() deleteOnTap;
  final bool isMultiple;
  final String title;
  const ImagePickerWidget(
      {super.key,
      this.path,
      required this.galleryOnTap,
      required this.cameraOnTap,
      required this.title,
      required this.deleteOnTap,
      this.paths,
      required this.isMultiple});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          const SizedBox(
            height: 5,
          ),
          widget.isMultiple == true
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(width: 2, color: Colors.grey, style: BorderStyle.solid),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.file_upload_outlined,
                                color: Colors.grey,
                                size: 45,
                              ),
                            )),
                        onTap: () {
                          imageDropDown(context, widget.title, widget.deleteOnTap, widget.galleryOnTap, widget.cameraOnTap);
                        },
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          widget.paths!.isNotEmpty
                              ? Row(
                                  children: [
                                    for (var path in widget.paths!)
                                      path.path == ""
                                          ? Container()
                                          : Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(7),
                                                        border: Border.all(width: 2, color: Colors.grey, style: BorderStyle.solid),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Image.file(
                                                          File(path.path.toString()),
                                                          fit: BoxFit.fill,
                                                          height: 50,
                                                          width: 50,
                                                        ),
                                                      )),
                                                ),
                                                Positioned(
                                                  top: 2,
                                                  right: 0,
                                                  child: GestureDetector(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Theme.of(context).primaryColor,
                                                      ),
                                                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        widget.paths!.remove(path);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    imageDropDown(context, widget.title, widget.deleteOnTap, widget.galleryOnTap, widget.cameraOnTap);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(width: 2, color: Colors.grey, style: BorderStyle.solid),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: widget.path != null && widget.path!.path != ""
                            ? Image.file(
                                File(widget.path!.path.toString()),
                                fit: BoxFit.fill,
                                height: 50,
                                width: 50,
                              )
                            : const Icon(
                                Icons.file_upload_outlined,
                                color: Colors.grey,
                                size: 45,
                              ),
                      )),
                ),
        ],
      ),
    );
  }
}
