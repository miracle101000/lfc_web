import 'package:flutter/material.dart';
import 'package:lfc_web/screens/latest/latest_list.dart';
import 'package:lfc_web/screens/latest/latest_upload.dart';
import 'package:lfc_web/screens/videos/videos_list.dart';
import 'package:lfc_web/screens/videos/videos_upload.dart';
import 'package:provider/provider.dart';

import '../../provider/wsf_provider.dart';
import 'testimonies_list.dart';
import 'testimonies_upload.dart';

class TestimoniesMain extends StatefulWidget {
  const TestimoniesMain({super.key});

  @override
  State<TestimoniesMain> createState() => _TestimoniesMainState();
}

class _TestimoniesMainState extends State<TestimoniesMain> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [const TestimoniesUpload(), Consumer<WSFProvider>(builder: (context, w, _) {
            return w.refresh
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
                : TestimoniesList();
          })],
      ),
    );
  }
}
