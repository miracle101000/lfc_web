import 'package:flutter/material.dart';
import 'package:lfc_web/provider/announcements_provider.dart';
import 'package:lfc_web/screens/wsf/wsf_list.dart';
import 'package:provider/provider.dart';
import '../../services/helpers.dart';
import '../../services/mongo_server.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'announcement_widget.dart';
import 'announcements_dialog.dart';

class Announcements extends StatefulWidget {
  const Announcements({super.key});

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  PageController pageController = PageController();
  TextEditingController c = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementsProvider>(builder: (context, l, _) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: const Text(
                          "Announcements",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 50,
                            child: l.ignore == false
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.65,
                                        child: l.l.isNotEmpty
                                            ? ListView.builder(
                                                itemCount: l.l.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (_, index) =>
                                                        GestureDetector(
                                                          onTap: () {
                                                            l.selectedText =
                                                                l.l[index]
                                                                    ['type'];
                                                            pageController
                                                                .jumpToPage(
                                                              index,
                                                            );
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    l.l[index][
                                                                            'type']
                                                                        .toString()
                                                                        .capitalize(),
                                                                    style: TextStyle(
                                                                        fontWeight: l.selectedText == l.l[index]['type'] || l.selectedText == '' && index == 0
                                                                            ? FontWeight
                                                                                .bold
                                                                            : null,
                                                                       ),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ))
                                            : const SizedBox.shrink(),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          l.ignore = true;
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "+",
                                                  style: TextStyle(
                                                      fontWeight: null,
                                                      color: Colors.red),
                                                ),
                                              ]),
                                        ),
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.512,
                                          child: Form(
                                            key: _formKey,
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
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              l.setMap(
                                                  {'type': c.text, 'text': ""});
                                              l.ignore = false;
                                            }
                                          },
                                          child: const Text(
                                            "Submit",
                                            style: TextStyle(color: Colors.red),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            l.ignore = false;
                                          },
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  )),
                      )
                    ],
                  ),
                ),
                l.isIniting && !l.hasError
                    ? const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    : !l.isIniting && l.hasError
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: ElevatedButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.red)),
                                      onPressed: () async {
                                        await _get();
                                      },
                                      child: const Text("Error"))),
                            ],
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: l.l.isNotEmpty
                                ? PageView.builder(
                                    itemCount: l.l.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: pageController,
                                    itemBuilder: (_, index) {
                                      return AnnouncementWidget(
                                        title: l.l[index]['type'],
                                        text: l.l[index]['text'],
                                        index: index,
                                      );
                                    },
                                  )
                                : const SizedBox.shrink())
              ],
            ),
          ),
        ),
      );
    });
  }

  _showDialog() {
    showDialog(
        context: context,
        // barrierDismissible: false,
        barrierColor: Colors.red.withOpacity(0.05),
        builder: (_) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: const AnnouncementsDialog());
        });
  }

  setisLoadingHasError(bool v, bool v1, AnnouncementsProvider l) {
    if (mounted) {
      l.isIniting = v;
      l.hasError = v1;
    }
  }

  _get() async {
    await Provider.of<AnnouncementsProvider>(context, listen: false).clear();
    await MongoDB.getData(
        filter: {
          "collection": {'\$eq': 'announcements'},
        },
        projection: {},
        sortBy: '_id',
        limit: 100,
        showLoading: () {
          setisLoadingHasError(true, false,
              Provider.of<AnnouncementsProvider>(context, listen: false));
        },
        onDone: (_) async {
          if (_.isNotEmpty) {
            if (mounted) {
              Provider.of<AnnouncementsProvider>(context, listen: false)
                  .setList(_);
            }
          }
          setisLoadingHasError(false, false,
              Provider.of<AnnouncementsProvider>(context, listen: false));
        },
        onError: (_) async {
          await Provider.of<AnnouncementsProvider>(context, listen: false)
              .clear();
          setisLoadingHasError(false, true,
              Provider.of<AnnouncementsProvider>(context, listen: false));
          Helper.showToast(_.toString());
        });
  }
}
