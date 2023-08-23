import 'package:flutter/material.dart';
import 'package:lfc_web/provider/wsf_provider.dart';
import 'package:provider/provider.dart';
import 'wsf_list.dart';
import 'wsf_upload.dart';

class WSFMain extends StatefulWidget {
  const WSFMain({super.key});

  @override
  State<WSFMain> createState() => _WSFMainState();
}

class _WSFMainState extends State<WSFMain> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const WSFUpload(),
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
                : const WSFList();
          })
        ],
      ),
    );
  }
}
