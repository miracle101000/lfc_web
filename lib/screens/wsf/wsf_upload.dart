import 'package:flutter/material.dart';
import 'package:lfc_web/provider/wsf_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class WSFUpload extends StatefulWidget {
  const WSFUpload({super.key});

  @override
  State<WSFUpload> createState() => _WSFUploadState();
}

class _WSFUploadState extends State<WSFUpload> {
  String selectedText = '';
  bool show = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.55,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 12.0, left: 36, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "WSF",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Form(
                key: _formKey,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: CustomTextField(
                        hintText: "Estate name example: Trademore Mega City",
                        controller: controller,
                        validator: (_) {
                          if (_!.isEmpty) {
                            return 'Cannot be empty';
                          }
                          return null;
                        })),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: CustomButton(onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Provider.of<WSFProvider>(context, listen: false)
                    ..updateShow(controller.text.trim(), false)
                    ..updateDone(controller.text.trim(), false)
                    ..setList({'name': controller.text, 'list': [],'id':""});
                    controller.clear();
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
