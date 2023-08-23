import 'package:flutter/material.dart';
import 'package:lfc_web/screens/wsf/wsf_list.dart';
import 'package:provider/provider.dart';

import '../../provider/wsf_provider.dart';
import '../../services/helpers.dart';
import '../../services/mongo_server.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class WSFDialog extends StatefulWidget {
  final String keya;
  final String id;
  const WSFDialog({super.key,required this.keya,required this.id});

  @override
  State<WSFDialog> createState() => _WSFDialogState();
}

class _WSFDialogState extends State<WSFDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 TextEditingController c = TextEditingController(),
      c1 = TextEditingController(),
      c2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Close',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextField(
                            hintText: "Address",
                            controller: c,
                            validator: (_) {
                              if (_!.isEmpty) {
                                return 'Cannot be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextField(
                            hintText: "Phone number: 080 123 1231",
                            maxLines: 1,
                            controller: c1,
                            validator: (_) {
                              if (_!.isEmpty) {
                                return 'Cannot be empty';
                              }

                              if (_.isNotEmpty && _.length != 11) {
                                return 'Invalid phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                        if (widget.keya == "Trademore")
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomTextField(
                              hintText: "Phase 1",
                              maxLines: 1,
                              controller: c2,
                              validator: (_) {
                                if (_!.isEmpty) {
                                  return 'Cannot be empty';
                                }

                                if (_.isNotEmpty && int.tryParse(_) == null) {
                                  return 'Must be a number';
                                }
                                return null;
                              },
                            ),
                          ),
                        Consumer<WSFProvider>(builder: (context, wsf, _) {
                          if (wsf.isLoading) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: Colors.red,
                            ));
                          }
                          return CustomButton(onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _addAddress(
                                  widget.id,widget.keya, c.text, c1.text, c2.text);
                            }
                          });
                        })
                      ],
                    ),
                  ),
                ),
              ),
            );
  }

    _addAddress(String id, String estate, String address, String phone,
      [String? phase]) async {
    var data =  Provider.of<WSFProvider>(context, listen: false).list
        .where((element) =>
            element['name'].toString().toLowerCase() == estate.toLowerCase())
        .toList()[0];
    List d = data['list'];
    d.add({
      "address": address,
      "phone": phone,
      if (phase != null) "phase": phase
    });
    if (id.isNotEmpty) {
      await MongoDB.updateData(
         
          filter: {
              '_id': {
                "\$eq": {'\$oid': id}
              }
              
            },
          document: {
            "collection": "wsf",
            "estate": estate.capitalize(),
            'time': DateTime.now().toIso8601String(),
            'list': d
          },
          upsert: true,
          showLoading: () {
             Provider.of<WSFProvider>(context, listen: false).isLoading = true;
          },
          onDone: (_) {
            Provider.of<WSFProvider>(context, listen: false).isLoading = false;
             Provider.of<WSFProvider>(context, listen: false).removeListUpdate(estate, data);
            Helper.showToast("Successful");
            Navigator.pop(context);
          },
          onError: (_) {
             Provider.of<WSFProvider>(context, listen: false).isLoading = false;
            Helper.showToast(_.toString());
          });
    } else {
      await MongoDB.insertData(
          document: {
            "collection": "wsf",
            "estate": estate.capitalize(),
            'time': DateTime.now().toIso8601String(),
            'list': d,
          },
          showLoading: () {
             Provider.of<WSFProvider>(context, listen: false).isLoading = true;
          },
          onDone: () {
             Provider.of<WSFProvider>(context, listen: false).isLoading = false;
            Helper.showToast("Successful");
            Navigator.pop(context);
          },
          onError: (_) {
             Provider.of<WSFProvider>(context, listen: false).isLoading = false;
            Helper.showToast(_.toString());
          });
    }
     Provider.of<WSFProvider>(context, listen: false).refreshm();
  }
}