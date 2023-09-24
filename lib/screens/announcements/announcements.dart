import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lfc_web/provider/announcements_provider.dart';
import 'package:lfc_web/screens/wsf/wsf_list.dart';
import 'package:provider/provider.dart';
import '../../services/helpers.dart';
import '../../services/mongo_server.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'announcement_widget.dart';
import 'announcements_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Announcements extends StatefulWidget {
  const Announcements({super.key});

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  PageController pageController = PageController();
  TextEditingController c = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Uint8List? file, file1;
  bool isLoading = false, showProgress = false, showProgress1 = false;
  bool _isLoading = false, _hasError = false;
  double progress = 0.0, progress1 = 0.0;
  String _downloadUrl = '', _downloadUrl1 = '';
  bool isUpload = false, isUpload1 = false;
  var _data;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementsProvider>(builder: (context, l, _) {
      return _isLoading && !_hasError
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            )
          : !_isLoading && _hasError
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.red)),
                              onPressed: () async {
                                await _get();
                              },
                              child: const Text("Error"))),
                    ],
                  ))
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, left: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        child: const Text(
                                          "Announcements",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, bottom: 16),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () async {
                                      await _getFile(FileType.custom);
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      ),
                                      alignment: Alignment.center,
                                      child: file1 == null
                                          ? const Text(
                                              "Upload announcents here",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : Text(
                                              progress1 == 1
                                                  ? "File uploaded !!"
                                                  : "Upload file",
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                    ),
                                  ),
                                ),
                                if (isUpload1 && showProgress1)
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 32.0),
                                            child: LinearProgressIndicator(
                                              value: progress1,
                                              color: Colors.red,
                                              backgroundColor: Colors.red,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(Colors.orange),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
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
                                                MaterialStatePropertyAll(
                                                    Colors.red)),
                                        child: const Text("Upload")),
                                  ),
                                if (_data != null)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () async {
                                            await _delete();
                                          },
                                          child: const Text(
                                            "Delete current announcements",
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  ),
                                if (!isLoading)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 32.0),
                                    child: CustomButton(onPressed: () {
                                      _function();
                                    }),
                                  )
                                else
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                    ),
                                  )
                              ]))));
    });
  }

  _delete() async {
    await FirebaseStorage.instance.refFromURL(_data['book_url']).delete();
    await MongoDB.updateData(
        filter: {
          'collection': {"\$eq": "announcements"}
        },
        document: {
          'book_url': '',
          'time': DateTime.now().toIso8601String(),
        },
        showLoading: () {
          if (mounted) {
            setState(() {
              isLoading = true;
            });
          }
        },
        upsert: true,
        onDone: (_) {
          if (mounted) {
            setState(() {
              isLoading = false;
              _downloadUrl = '';
              _downloadUrl1 = '';
              progress = 0.0;
              showProgress = false;
              file = null;
              isUpload = false;
            });
          }
          Helper.showToast("Deletion Successful");
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

  _function() async {
    if (_downloadUrl1.isNotEmpty) {
      if (_data != null && _data['book_url'].isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(_data['book_url']).delete();
      }
      await MongoDB.updateData(
          filter: {
            'collection': {"\$eq": "announcements"}
          },
          document: {
            if (_downloadUrl1.isNotEmpty) 'book_url': _downloadUrl1,
            'time': DateTime.now().toIso8601String(),
          },
          showLoading: () {
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
          },
          upsert: true,
          onDone: (_) {
            if (mounted) {
              setState(() {
                isLoading = false;
                _downloadUrl = '';
                _downloadUrl1 = '';
                progress = 0.0;
                showProgress = false;
                file = null;
                isUpload = false;
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
      if (_downloadUrl1.isEmpty) {
        await Helper.showToast("Expecting an uploaded announcements");
      }
    }
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

  _upload(FileType type) {
    Helper.uploadFile(
        storagePath: type == FileType.image
            ? 'announcements/cover'
            : 'announcements/document',
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

  setisLoadingHasError(
    bool v,
    bool v1,
  ) {
    _isLoading = v;
    _hasError = v1;
    if (mounted) setState(() {});
  }

  _get() async {
    await Provider.of<AnnouncementsProvider>(context, listen: false).clear();
    await MongoDB.getData(
        filter: {
          "collection": {'\$eq': 'announcements'},
        },
        projection: {},
        sortBy: '_id',
        limit: 100,
        showLoading: () {
          setisLoadingHasError(
            true,
            false,
          );
        },
        onDone: (_) async {
          if (_.isNotEmpty) {
            if (mounted) {
              if (_.isNotEmpty) _data = _[0];
            }
          }
          setisLoadingHasError(
            false,
            false,
          );
        },
        onError: (_) async {
          setisLoadingHasError(
            false,
            true,
          );
          Helper.showToast(_.toString());
        });
  }
}
