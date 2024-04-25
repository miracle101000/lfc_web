import 'dart:typed_data';
import 'package:lfc_web/provider/announcements_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:lfc_web/services/helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lfc_web/services/mongo_server.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveUpload extends StatefulWidget {
  const LiveUpload({super.key});

  @override
  State<LiveUpload> createState() => _LiveUploadState();
}

class _LiveUploadState extends State<LiveUpload> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Provider.of<AnnouncementsProvider>(context, listen: false)
      //   ..controller = controller
      //   ..isEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementsProvider>(builder: (context, latest, _) {
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
                      "Live",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CustomTextField(
                    hintText: "Enter youtube link",
                    controller: controller,
                    onChanged: (_) {
                      setState(() {});
                    },
                  )),
              if (!isLoading)
                CustomButton(
                    color: controller.text.isNotEmpty ? null : Colors.grey,
                    onPressed: controller.text.isNotEmpty
                        ? () async {
                            await _function();
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

  _function() async {
    if (controller.text.isNotEmpty && Helper.isYouTubeLink(controller.text)) {
      await MongoDB.insertData(
          document: {
            'url': controller.text.trim(),
            "collection": "Live",
            'time': DateTime.now().toIso8601String()
          },
          showLoading: () {
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
          },
          onDone: () async {
           await  FirebaseFirestore.instance
                .collection("Live")
                .doc('count')
                .update({'value': 0});
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
            Helper.showToast("Successful");
            Provider.of<AnnouncementsProvider>(context, listen: false).refres();
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
      await Helper.showToast("Invalid Entry");
    }
  }
}
