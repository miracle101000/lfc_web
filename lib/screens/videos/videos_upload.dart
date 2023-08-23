import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lfc_web/provider/video_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../provider/wsf_provider.dart';
import '../../services/helpers.dart';
import '../../services/mongo_server.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class VideosUpload extends StatefulWidget {
  const VideosUpload({super.key});

  @override
  State<VideosUpload> createState() => _VideosUploadState();
}

class _VideosUploadState extends State<VideosUpload> {
  Uint8List? file;
  bool isLoading = false, showProgress = false;
  bool isUpload = false;
  double progress = 0.0;

  String _downloadUrl = '';
  TextEditingController controller = TextEditingController(),
      controller1 = TextEditingController(),
      controller2 = TextEditingController(),
      controller3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<VideoProvider>(context, listen: false)
      ..controller = controller
      ..controller1 = controller1
      ..controller2 = controller2
      ..controller3 = controller3
      ..isEdit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(builder: (context, v, _) {
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
                      "Videos",
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
                    height: MediaQuery.of(context).size.height * 0.3,
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
                  width: MediaQuery.of(context).size.width * 0.55,
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
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: CustomTextField(
                      hintText: "Title",
                      controller: controller,
                      onChanged: (_) {
                        setState(() {});
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: CustomTextField(
                      hintText: "Description",
                      maxLines: 4,
                      controller: controller1,
                      onChanged: (_) {
                        setState(() {});
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: CustomTextField(
                      hintText:
                          "Link: https://www.youtube.com/live/heXQ8jaNYjE?feature=share",
                      controller: controller2,
                      onChanged: (_) {
                        setState(() {});
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: CustomTextField(
                      hintText: "Length in minutes: Example 22",
                      type: TextInputType.number,
                      controller: controller3,
                      onChanged: (_) {
                        setState(() {});
                      },
                    )),
              ),
              if (!isLoading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: CustomButton(onPressed: () {
                    _function(v);
                  }),
                )
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
          if (mounted) {
            setState(() {
              file = null;
              showProgress = false;
              progress = 0.0;
              _downloadUrl = '';
            });
          }
        },
        onDone: (_) {
          if (mounted) {
            setState(() {
              file = _;
              isUpload = true;
            });
          }
        },
        onError: (_) async {
          setState(() {
            isUpload = false;
          });
          await Helper.showToast(_.toString());
        });
  }

  _function(VideoProvider v) async {
    if (controller.text.isEmpty) {
      Helper.showToast("Title cannot be empty");
      return;
    }

    if (controller1.text.isEmpty) {
      Helper.showToast("Description cannot be empty");
      return;
    }

    if (controller2.text.isEmpty) {
      Helper.showToast("Link cannot be empty");
      return;
    }

    if (Helper.isYouTubeLink(controller2.text) == false) {
      Helper.showToast("Not a youtube link");
      return;
    }

    if (controller3.text.isEmpty) {
      Helper.showToast("Length cannot be empty");
      return;
    }

    if (controller3.text == '0') {
      Helper.showToast("Length cannot be zero");
      return;
    }

    if (!Helper.isInteger(controller3.text)) {
      Helper.showToast("Must be a number without decimal point");
      return;
    }

    if (_downloadUrl.isNotEmpty || v.isEdit) {
      if (!v.isEdit) {
        await MongoDB.insertData(
            document: {
              'image_url': _downloadUrl,
              'title': controller.text,
              "collection": "videos",
              'time': DateTime.now().toIso8601String(),
              'description': controller1.text,
              'video_link': controller2.text,
              'length': int.tryParse(controller3.text)
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
                  controller1.clear();
                  controller2.clear();
                  controller3.clear();
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
          await FirebaseStorage.instance.refFromURL(v.image_url).delete();
        }
        await MongoDB.updateData(
            filter: {
              '_id': {
                "\$eq": {'\$oid': v.id}
              }
              
            },
            document: {
              if (_downloadUrl.isNotEmpty) 'image_url': _downloadUrl,
              if (controller.text.isNotEmpty) 'title': controller.text,
              if (controller1.text.isNotEmpty) 'description': controller1.text,
              if (controller2.text.isNotEmpty) 'video_link': controller2.text,
              if (controller3.text.isNotEmpty)
                'length': int.tryParse(controller3.text)
            },
            showLoading: () {
              if (mounted) {
                setState(() {
                  isLoading = true;
                });
              }
            },
            onDone: (_) {
              Provider.of<VideoProvider>(context, listen: false).isEdit = false;
              if (mounted) {
                setState(() {
                  isLoading = false;
                  _downloadUrl = '';
                  progress = 0.0;
                  showProgress = false;

                  file = null;
                  isUpload = false;
                  controller.clear();
                  controller1.clear();
                  controller2.clear();
                  controller3.clear();
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
      await Helper.showToast("Expecting an uploaded image");
    }
  }

  _upload() {
    Helper.uploadFile(
        storagePath: 'videos',
        showLoading: () {},
        onDone: (_) {
          if (mounted) {
            setState(() {
              _downloadUrl = _;
            });
          }
        },
        onError: (_) async {
          await Helper.showToast(_.toString());
        },
        onData: (_) {
          if (mounted) {
            setState(() {
              showProgress = true;
              progress = _.bytesTransferred / file!.length;
            });
          }
        },
        file: file!);
  }
}
