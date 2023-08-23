import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lfc_web/provider/accounts_provider.dart';
import 'package:provider/provider.dart';
import '../../provider/wsf_provider.dart';
import '../../services/helpers.dart';
import '../../services/mongo_server.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AccountsUpload extends StatefulWidget {
  const AccountsUpload({super.key});

  @override
  State<AccountsUpload> createState() => _AccountsUploadState();
}

class _AccountsUploadState extends State<AccountsUpload> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController(),
      controller1 = TextEditingController(),
      controller2 = TextEditingController(),
      controller3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<AccountsProvider>(context, listen: false)
      ..controller = controller
      ..controller1 = controller1
      ..controller2 = controller2
      ..controller3 = controller3
      ..isEdit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountsProvider>(builder: (context, a, _) {
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
                      "Account No.",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, top: 32),
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
                      hintText: "Account No.",
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
                      hintText: "Account Name",
                      type: TextInputType.number,
                      controller: controller2,
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
                      hintText: "Bank Name",
                      type: TextInputType.number,
                      controller: controller3,
                      onChanged: (_) {
                        setState(() {});
                      },
                    )),
              ),
              if (!isLoading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: CustomButton(onPressed: () {
                    _function(a);
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

  _function(AccountsProvider a) async {
    if (controller.text.isEmpty) {
      Helper.showToast("Title cannot be empty");
      return;
    }
    if (controller1.text.isEmpty) {
      Helper.showToast("Account No. cannot be empty");
      return;
    }

    if (controller1.text.length != 10 && !Helper.isInteger(controller2.text)) {
      Helper.showToast("Account No. is invalid");
      return;
    }

    if (controller2.text.isEmpty) {
      Helper.showToast("Account Name cannot be empty");
      return;
    }

    if (controller3.text.isEmpty) {
      Helper.showToast("Bank Name cannot be empty");
      return;
    }
    if (!a.isEdit) {
      await MongoDB.insertData(
          document: {
            'title': controller.text,
            "collection": "accounts",
            'time': DateTime.now().toIso8601String(),
            'account_number': controller1.text,
            'account_name': controller2.text,
            'bank_name': controller3.text,
          },
          showLoading: () {
            if (mounted)
              setState(() {
                isLoading = true;
              });
          },
          onDone: () {
            if (mounted)
              setState(() {
                controller.clear();
                controller1.clear();
                controller2.clear();
                controller3.clear();
                isLoading = false;
              });
            Helper.showToast("Successful");
          },
          onError: (_) {
            if (mounted)
              setState(() {
                isLoading = false;
              });
            Helper.showToast(_.toString());
          });
    } else {
      await MongoDB.updateData(
          filter: {
            '_id': {
                "\$eq": {'\$oid': a.id}
              }
          },
          document: {
            'title': controller.text,
            'account_number': controller1.text,
            'account_name': controller2.text,
            'bank_name': controller3.text,
          },
          showLoading: () {
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
          },
          onDone: (_) {
            Provider.of<AccountsProvider>(context, listen: false).isEdit =
                false;
            if (mounted) {
              setState(() {
                controller.clear();
                controller1.clear();
                controller2.clear();
                controller3.clear();
                isLoading = false;
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
  }
}
