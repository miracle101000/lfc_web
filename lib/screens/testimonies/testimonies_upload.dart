import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lfc_web/provider/testimonies_provider.dart';
import 'package:provider/provider.dart';
import '../../provider/wsf_provider.dart';
import '../../services/helpers.dart';
import '../../services/mongo_server.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TestimoniesUpload extends StatefulWidget {
  const TestimoniesUpload({super.key});

  @override
  State<TestimoniesUpload> createState() => _TestimoniesUploadState();
}

class _TestimoniesUploadState extends State<TestimoniesUpload> {
  // String selectedText = '', selectedText1 = 'Text';
  Uint8List? file;
  bool isLoading = false, showProgress = false;
  double progress = 0.0;
  bool isUpload = false;
  String _downloadUrl = '';
  TextEditingController controller = TextEditingController(),
      controller1 = TextEditingController(),
      controller2 = TextEditingController(),
      controller3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<TestimoniesProvider>(context, listen: false)
      ..controller = controller
      ..controller1 = controller1
      ..controller2 = controller2
      ..isEdit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TestimoniesProvider>(builder: (context, t, _) {
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
                      "Testimonies",
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
                            : null,
                        shape: BoxShape.circle),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        await _upload();
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                      child: const Text("Upload")),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: CustomTextField(
                      hintText: "Name",
                      controller: controller,
                      onChanged: (_) {
                        setState(() {});
                      },
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 22),
                child: SizedBox(
                  child: Wrap(
                    runSpacing: 16,
                    children: c.map<Widget>((e) => _tag2(e, true,t)).toList(),
                  ),
                ),
              ),
              if (t.type == 'Text')
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: CustomTextField(
                        hintText: "Testimony",
                        maxLines: 10,
                        controller: controller1,
                        onChanged: (_) {
                          setState(() {});
                        },
                      )),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: CustomTextField(
                        hintText:
                            "Link: https://www.youtube.com/live/heXQ8jaNYjE?feature=share",
                        controller: controller1,
                        onChanged: (_) {
                          setState(() {});
                        },
                      )),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 22),
                child: SizedBox(
                  child: Wrap(
                    runSpacing: 16,
                    children: l.map<Widget>((e) => _tag2(e, false, t)).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: CustomTextField(
                      hintText: "Length in minutes",
                      type: TextInputType.number,
                      controller: controller2,
                      onChanged: (_) {
                        setState(() {});
                      },
                    )),
              ),
              if (!isLoading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: CustomButton(onPressed: () {
                    _function(t);
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

  List l = [
        "Healing",
        "Deliverance",
        "Financial Breakthrough",
        "Fruit of the womb",
        "Thanksgiving",
        "Soul winning",
        "Marital Breakthrough",
        "Seed Sowing"
      ],
      c = ['Text', 'Video', 'Audio'];
  _tag2(String text, bool category, TestimoniesProvider t) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!category) {
          if (mounted) {
            t.category = text;
          }
        } else {
          controller1.clear();
          if (mounted) {
            t.type = text;
          }
        }
      },
      child: !category
          ? Container(
              padding: const EdgeInsets.all(7),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  color: t.category == text
                      ? const Color(0xffED3237)
                      : Colors.transparent,
                  border: t.category == text
                      ? null
                      : Border.all(color: const Color(0xffDBDBDB)),
                  borderRadius: BorderRadius.circular(4)),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: t.category == text
                        ? Colors.white
                        : const Color(0xff989898)),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(7),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  color: t.type == text
                      ? const Color(0xffED3237)
                      : Colors.transparent,
                  border: t.type == text
                      ? null
                      : Border.all(color: const Color(0xffDBDBDB)),
                  borderRadius: BorderRadius.circular(4)),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: t.type == text
                        ? Colors.white
                        : const Color(0xff989898)),
              ),
            ),
    );
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

  _function(TestimoniesProvider t) async {
    if (controller.text.isEmpty) {
      Helper.showToast("Name cannot be empty");
      return;
    }

    if (controller1.text.isEmpty) {
      Helper.showToast("Testimony cannot be empty");
      return;
    }

    if (controller2.text.isEmpty) {
      Helper.showToast("Length cannot be empty");
      return;
    }

    if (t.type != 'Text' && Helper.isYouTubeLink(controller3.text) == false) {
      Helper.showToast("Not a youtube link");
      return;
    }

    if (!Helper.isInteger(controller2.text)) {
      Helper.showToast("Must be a number without decimal point");
      return;
    }

    if (_downloadUrl.isNotEmpty && t.category.isNotEmpty || !t.isEdit) {
      if (!t.isEdit) {
        await MongoDB.insertData(
            document: {
              'image_url': _downloadUrl,
              'name': controller.text,
              'testimony': controller1.text,
              'length': controller2.text,
              'category': t.category,
              'type': t.type.toLowerCase(),
              "collection": "testimonies",
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
              t.category = '';
              t.type = 'Text';
              if (mounted) {
                setState(() {
                  isLoading = false;
                  _downloadUrl = '';
                  progress = 0.0;
                  showProgress = false;
                  file = null;
                  controller.clear();

                  isUpload = false;
                  controller1.clear();
                  controller2.clear();
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
          await FirebaseStorage.instance.refFromURL(t.image_url).delete();
        }
        await MongoDB.updateData(
            filter: {
                '_id': {
                "\$eq": {'\$oid': t.id}
              }

            },
            document: {
              'image_url': _downloadUrl,
              'name': controller.text,
              'testimony': controller1.text,
              'length': controller2.text,
              'category': t.category,
              'type': t.type.toLowerCase(),
            },
            showLoading: () {
              if (mounted) {
                setState(() {
                  isLoading = true;
                });
              }
            },
            onDone: (_) {
              Provider.of<TestimoniesProvider>(context, listen: false)
                ..isEdit = false
                ..category = ''
                ..type = 'Text';
              if (mounted) {
                setState(() {
                  isLoading = false;
                  _downloadUrl = '';
                  progress = 0.0;
                  showProgress = false;
                  file = null;
                  controller.clear();

                  isUpload = false;
                  controller1.clear();
                  controller2.clear();
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
      if (_downloadUrl.isEmpty) {
        await Helper.showToast("Expecting an uploaded image");
      }

      if (t.category.isEmpty) {
        await Helper.showToast("Choose a category");
      }
      if (_downloadUrl.isEmpty && t.category.isEmpty) {
        await Helper.showToast(
            "Expecting an uploaded image & choose a category");
      }
    }
  }

  _upload() {
    Helper.uploadFile(
        storagePath: 'testimonies',
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
