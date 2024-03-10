import 'package:flutter/material.dart';
import 'package:lfc_web/provider/announcements_provider.dart';
import 'package:lfc_web/provider/wsf_provider.dart';
import 'package:lfc_web/screens/announcements/announcements_list.dart';
import 'package:lfc_web/screens/announcements/announcements_upload.dart';
import 'package:lfc_web/screens/latest/latest_list.dart';
import 'package:lfc_web/screens/latest/latest_upload.dart';
import 'package:provider/provider.dart';

class AnnouncementsMain extends StatefulWidget {
  const AnnouncementsMain ({super.key});

  @override
  State<AnnouncementsMain > createState() => _AnnouncementsMainState();
}

class _AnnouncementsMainState extends State<AnnouncementsMain > {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AnnouncementsUpload(),
          Consumer<AnnouncementsProvider>(builder: (context, a, _) {
            return a.refresh
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  )
                : const AnnouncementsList();
          })
        ],
      ),
    );
  }



}
