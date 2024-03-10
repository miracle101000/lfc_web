import 'package:flutter/material.dart';
import 'package:lfc_web/provider/announcements_provider.dart';
import 'package:lfc_web/screens/live/live_list.dart';
import 'package:lfc_web/screens/live/live_upload.dart';
import 'package:provider/provider.dart';

class LiveMain extends StatefulWidget {
  const LiveMain({super.key});

  @override
  State<LiveMain> createState() => _LiveMainState();
}

class _LiveMainState extends State<LiveMain> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LiveUpload(),
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
                : const LiveList();
          })
        ],
      ),
    );
  }



}
