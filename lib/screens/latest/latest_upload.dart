import 'dart:io';
import 'dart:typed_data';
import 'package:lfc_web/provider/latest_provider.dart';
import 'package:lfc_web/provider/wsf_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:lfc_web/services/helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lfc_web/services/mongo_server.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LatestUpload extends StatefulWidget {
  const LatestUpload({super.key});

  @override
  State<LatestUpload> createState() => _LatestUploadState();
}

class _LatestUploadState extends State<LatestUpload> {
  TextEditingController controller = TextEditingController();
  Uint8List? file;
  bool isLoading = false, showProgress = false;
  double progress = 0.0;
  String _downloadUrl = '';
  bool isUpload = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LatestProvider>(context, listen: false)
        ..controller = controller
        ..isEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LatestProvider>(builder: (context, latest, _) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.55,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 12.0, left: 36),
                child: Row(
                  children: [
                    Text(
                      "Latest",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 32),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    await _getFile();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: file != null ? Colors.black54 : null,
                        image: file != null
                            ? DecorationImage(image: MemoryImage(file!))
                            : null),
                    alignment: Alignment.center,
                    child: file == null
                        ? const Text(
                            "Click to upload image here",
                            style: TextStyle(color: Colors.red),
                          )
                        : null,
                  ),
                ),
              ),
              if (isUpload && showProgress)
                SizedBox(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: LinearProgressIndicator(
                            value: progress,
                            color: Colors.red,
                            backgroundColor: Colors.red,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.orange),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text((progress * 100) == 100
                            ? "Done"
                            : "${Helper.dp((progress * 100), 2)}%"),
                      )
                    ],
                  ),
                )
              else if (isUpload)
                ElevatedButton(
                    onPressed: () async {
                      await _upload();
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    child: const Text("Upload")),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CustomTextField(
                    hintText: "Input topic",
                    controller: controller,
                    onChanged: (_) {
                      setState(() {});
                    },
                  )),
              if (!isLoading)
                CustomButton(
                    color: _downloadUrl.isNotEmpty &&
                                controller.text.trim().isNotEmpty ||
                            latest.isEdit
                        ? null
                        : Colors.grey,
                    onPressed: _downloadUrl.isNotEmpty &&
                                controller.text.trim().isNotEmpty ||
                            latest.isEdit
                        ? () async {
                            await _function(latest);
                          }
                        : null)
              else
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                )
            ],
          ),
        ),
      );
    });
  }

  _getFile() async {
    await Helper.getFile(
        type: FileType.image,
        showLoading: () {
          setState(() {
            file = null;
            showProgress = false;
            progress = 0.0;
            _downloadUrl = '';
          });
        },
        onDone: (_) {
          setState(() {
            file = _;
            isUpload = true;
          });
        },
        onError: (_) async {
          setState(() {
            isUpload = false;
          });
          await Helper.showToast(_.toString());
        });
  }

  _function(LatestProvider l) async {
    if (_downloadUrl.isNotEmpty && controller.text.trim().isNotEmpty ||
        l.isEdit) {
      if (!l.isEdit) {
        await MongoDB.insertData(
            document: {
              'image_url': _downloadUrl,
              'text': controller.text,
              "collection": "latest",
              'time': DateTime.now().toIso8601String()
            },
            showLoading: () {
              if (mounted) {
                setState(() {
                  isLoading = true;
                });
              }
            },
            onDone: () {
              if (mounted) {
                setState(() {
                  isLoading = false;
                  _downloadUrl = '';
                  progress = 0.0;
                  showProgress = false;
                  file = null;
                  isUpload = false;
                  controller.clear();
                });
              }
              Helper.showToast("Successful");
            },
            onError: (_) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
              Helper.showToast(_.toString());
            });
      } else {
        if (_downloadUrl.isNotEmpty) {
          await FirebaseStorage.instance.refFromURL(l.imageUrl).delete();
        }
        print(controller.text.isNotEmpty);
        print(l.id);
        await MongoDB.updateData(
            filter: {
              '_id': {
                "\$eq": {'\$oid': l.id}
              }
            },
            document: {
              if (_downloadUrl.isNotEmpty) 'image_url': _downloadUrl,
              if (controller.text.isNotEmpty) 'text': controller.text,
            },
            showLoading: () {
              if (mounted) {
                setState(() {
                  isLoading = true;
                });
              }
            },
            onDone: (_) {
              Provider.of<LatestProvider>(context, listen: false).isEdit =
                  false;
              if (mounted) {
                setState(() {
                  isLoading = false;
                  _downloadUrl = '';
                  progress = 0.0;
                  showProgress = false;
                  file = null;
                  isUpload = false;
                  controller.clear();
                });
              }
              Helper.showToast("Successful");
            },
            onError: (_) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
              Helper.showToast(_.toString());
            });
      }
      Provider.of<WSFProvider>(context, listen: false).refreshm();
    } else {
      await Helper.showToast("Invalid Entry");
    }
  }

  _upload() {
    Helper.uploadFile(
        storagePath: 'latest',
        showLoading: () {},
        onDone: (_) {
          setState(() {
            _downloadUrl = _;
          });
        },
        onError: (_) async {
          await Helper.showToast(_.toString());
        },
        onData: (_) {
          setState(() {
            showProgress = true;
            progress = _.bytesTransferred / file!.length;
          });
        },
        file: file!);
  }
}
