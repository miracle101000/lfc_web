import 'package:flutter/material.dart';
import 'package:lfc_web/screens/books/books_list.dart';
import 'package:lfc_web/screens/books/books_upload.dart';
import 'package:lfc_web/screens/latest/latest_list.dart';
import 'package:lfc_web/screens/latest/latest_upload.dart';
import 'package:lfc_web/screens/videos/videos_list.dart';
import 'package:lfc_web/screens/videos/videos_upload.dart';
import 'package:provider/provider.dart';

import '../../provider/wsf_provider.dart';
import 'accounts_list.dart';
import 'accounts_upload.dart';

class AccountsMain extends StatefulWidget {
  const AccountsMain({super.key});

  @override
  State<AccountsMain> createState() => _AccountsMainState();
}

class _AccountsMainState extends State<AccountsMain> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [AccountsUpload(), Consumer<WSFProvider>(builder: (context, w, _) {
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
                : AccountsList();
          })],
      ),
    );
  }
}
