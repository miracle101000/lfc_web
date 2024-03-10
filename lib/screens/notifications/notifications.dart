import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lfc_web/services/helpers.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  TextEditingController controller = TextEditingController(),
      controller1 = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12.0, left: 36),
            child: Row(
              children: [
                Text(
                  "Notify Users",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 32),
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
            padding: const EdgeInsets.only(top: 16.0, bottom: 32),
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: CustomTextField(
                  hintText: "Body",
                  controller: controller1,
                  maxLines: 5,
                  onChanged: (_) {
                    setState(() {});
                  },
                )),
          ),
          if (!isLoading)
            CustomButton(
                color: controller1.text.trim().isNotEmpty &&
                        controller1.text.trim().isNotEmpty
                    ? null
                    : Colors.grey,
                onPressed: () async {
                  await _function();
                })
          else
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
        ],
      ),
    );
  }

  _function() async {
    try {
      isLoading = true;
      if (mounted) {
        setState(() {});
      }
      http.Response resp =
          await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
              headers: {
                "Content-Type": "application/json",
                "Authorization":
                    "key=AAAAABtw79c:APA91bHVn6M5v2LTFeXWKsErONtc0SfGEdGcZ3YKgJ0n8qUjL1o2NnhH7zE_33IZrRct2h4EkFU0_dDJEf6h5FKpWHr3kpgrYOzio_c9E1AG684-Xn3RWPISCDAfHyeOj7A_djNTp4gf",
              },
              body: json.encode({
                "to": "/topics/General",
                "notification": {
                  "title": controller.text.trim(),
                  "body": controller1.text.trim(),
                  "clickAction": 'FLUTTER_NOTIFICATION_CLICK',
                  "sound": 'default',
                }
              }));
      print("object: ${resp.statusCode}");
      if (resp.statusCode == 200) {
        isLoading = false;
        if (mounted) {
          setState(() {});
        }
        Helper.showToast("Users noitified successfully");
      }
    } catch (_) {
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
