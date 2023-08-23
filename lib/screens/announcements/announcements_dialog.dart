import 'package:flutter/material.dart';
import 'package:lfc_web/provider/announcements_provider.dart';
import 'package:lfc_web/screens/wsf/wsf_list.dart';
import 'package:provider/provider.dart';
import '../../provider/wsf_provider.dart';
import '../../services/helpers.dart';
import '../../services/mongo_server.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AnnouncementsDialog extends StatefulWidget {
  const AnnouncementsDialog({
    super.key,
  });

  @override
  State<AnnouncementsDialog> createState() => _AnnouncementsDialogState();
}

class _AnnouncementsDialogState extends State<AnnouncementsDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController c = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32),
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
                  hintText: "Annoucement Title",
                  controller: c,
                  validator: (_) {
                    if (_!.isEmpty) {
                      return 'Cannot be empty';
                    }

                    return null;
                  },
                ),
              ),
              CustomButton(onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Provider.of<AnnouncementsProvider>(context, listen: false)
                      .setMap({'type': c.text, 'text': ""});
                  Navigator.pop(context);
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
