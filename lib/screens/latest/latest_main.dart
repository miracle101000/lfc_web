import 'package:flutter/material.dart';
import 'package:lfc_web/provider/wsf_provider.dart';
import 'package:lfc_web/screens/latest/latest_list.dart';
import 'package:lfc_web/screens/latest/latest_upload.dart';
import 'package:provider/provider.dart';

class LatestMain extends StatefulWidget {
  const LatestMain({super.key});

  @override
  State<LatestMain> createState() => _LatestMainState();
}

class _LatestMainState extends State<LatestMain> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LatestUpload(),
          Consumer<WSFProvider>(builder: (context, w, _) {
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
                : const LatestList();
          })
        ],
      ),
    );
  }
}
