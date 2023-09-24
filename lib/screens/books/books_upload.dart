import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lfc_web/provider/book_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../provider/wsf_provider.dart';
import '../../services/helpers.dart';
import '../../services/mongo_server.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class BooksUpload extends StatefulWidget {
  const BooksUpload({super.key});

  @override
  State<BooksUpload> createState() => _BooksUploadState();
}

class _BooksUploadState extends State<BooksUpload> {
  Uint8List? file, file1;
  bool isLoading = false, showProgress = false, showProgress1 = false;
  double progress = 0.0, progress1 = 0.0;
  String _downloadUrl = '', _downloadUrl1 = '';
  bool isUpload = false, isUpload1 = false;

  TextEditingController controller = TextEditingController(),
      controller1 = TextEditingController(),
      controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<BookProvider>(context, listen: false)
      ..controller = controller
      ..controller1 = controller1
      ..controller2 = controller2
      ..isEdit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(builder: (context, b, _) {
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
                      "Books",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    await _getFile(FileType.image);
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
                      await _upload(FileType.image);
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    child: const Text("Upload")),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    await _getFile(FileType.custom);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    alignment: Alignment.center,
                    child: file1 == null
                        ? const Text(
                            "Upload pdf here",
                            style: TextStyle(color: Colors.red),
                          )
                        : Text(
                            progress1 == 1 ? "File uploaded !!" : "Upload file",
                            style: TextStyle(color: Colors.red),
                          ),
                  ),
                ),
              ),
              if (isUpload1 && showProgress1)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: LinearProgressIndicator(
                            value: progress1,
                            color: Colors.red,
                            backgroundColor: Colors.red,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.orange),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text((progress1 * 100) == 100
                            ? "Done"
                            : "${Helper.dp((progress1 * 100), 2)}%"),
                      )
                    ],
                  ),
                )
              else if (isUpload1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        await _upload(FileType.any);
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
                      hintText: "Author",
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
                      hintText: "Number of Pages",
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
                    _function(b);
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

  _getFile(FileType type) async {
    await Helper.getFile(
        type: type,
        showLoading: () {
          if (mounted) {
            setState(() {
              if (type == FileType.image) {
                file = null;
                showProgress = false;
                progress = 0.0;
                _downloadUrl = '';
              } else {
                file1 = null;
                showProgress1 = false;
                progress1 = 0.0;
                _downloadUrl1 = '';
              }
            });
          }
        },
        onDone: (_) {
          if (mounted) {
            setState(() {
              if (type == FileType.image) {
                file = _;
                isUpload = true;
              } else {
                file1 = _;
                isUpload1 = true;
              }
            });
          }
        },
        onError: (_) async {
          await Helper.showToast(_.toString());
        });
  }

  _function(BookProvider b) async {
    if (controller.text.isEmpty) {
      Helper.showToast("Title cannot be empty");
      return;
    }

    if (controller1.text.isEmpty) {
      Helper.showToast("Author cannot be empty");
      return;
    }

    if (controller2.text.isEmpty) {
      Helper.showToast("Length cannot be empty");
      return;
    }

    if (!Helper.isInteger(controller2.text)) {
      Helper.showToast("Must be a number without decimal point");
      return;
    }

    if (_downloadUrl.isNotEmpty && _downloadUrl1.isNotEmpty || b.isEdit) {
      if (!b.isEdit) {
        await MongoDB.insertData(
            document: {
              'image_url': _downloadUrl,
              'book_url': _downloadUrl1,
              'title': controller.text,
              "collection": "books",
              'time': DateTime.now().toIso8601String(),
              'author': controller1.text,
              'length': int.tryParse(controller2.text)
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
                  // showProgress = false;
                  _downloadUrl1 = '';
                  progress1 = 0.0;
                  // showProgress1 = false;
                  file = null;
                  file1 = null;
                  isUpload = false;
                  isUpload1 = false;
                  controller.clear();
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
          await FirebaseStorage.instance.refFromURL(b.image_url).delete();
        }

        if (_downloadUrl1.isNotEmpty) {
          await FirebaseStorage.instance.refFromURL(b.pdf_url).delete();
        }
        await MongoDB.updateData(
            filter: {
              '_id': {
                "\$eq": {'\$oid': b.id}
              }
            },
            document: {
              if (_downloadUrl.isNotEmpty) 'image_url': _downloadUrl,
              if (_downloadUrl1.isNotEmpty) 'book_url': _downloadUrl1,
              if (controller.text.isNotEmpty) 'title': controller.text,
              if (controller1.text.isNotEmpty) 'author': controller1.text,
              if (controller2.text.isNotEmpty)
                'length': int.tryParse(controller2.text),
            },
            showLoading: () {
              if (mounted) {
                setState(() {
                  isLoading = true;
                });
              }
            },
            onDone: (_) {
              Provider.of<BookProvider>(context, listen: false).isEdit = false;
              if (mounted) {
                setState(() {
                  isLoading = false;
                  _downloadUrl = '';
                  _downloadUrl1 = '';
                  progress = 0.0;
                  showProgress = false;
                  file = null;
                  isUpload = false;
                  controller.clear();
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
      if (_downloadUrl1.isEmpty) {
        await Helper.showToast("Expecting an uploaded book");
      }

      if (_downloadUrl.isEmpty && _downloadUrl1.isEmpty) {
        await Helper.showToast("Expecting an uploaded image & book");
      }
    }
  }

  _upload(FileType type) {
    Helper.uploadFile(
        storagePath: type == FileType.image ? 'books/cover' : 'books/document',
        showLoading: () {},
        onDone: (_) {
          if (mounted) {
            setState(() {
              if (type == FileType.image) {
                _downloadUrl = _;
              } else {
                _downloadUrl1 = _;
              }
            });
          }
        },
        onError: (_) async {
          if (mounted) {
            setState(() {
              if (type == FileType.image) {
                isUpload = false;
              } else {
                isUpload1 = false;
              }
            });
          }

          await Helper.showToast(_.toString());
        },
        onData: (_) {
          if (mounted) {
            setState(() {
              if (type == FileType.image) {
                showProgress = true;
                progress = _.bytesTransferred / file!.length;
              } else {
                showProgress1 = true;
                progress1 = _.bytesTransferred / file1!.length;
              }
            });
          }
        },
        file: type == FileType.image ? file! : file1!);
  }
}
