import 'package:flutter/material.dart';
import 'package:lfc_web/screens/widgets/custom_button.dart';
import 'package:lfc_web/screens/widgets/custom_text_field.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lfc_web/screens/wsf/wsf_list.dart';
import 'package:provider/provider.dart';

import '../../provider/announcements_provider.dart';
import '../../services/helpers.dart';
import '../../services/mongo_server.dart';

class AnnouncementWidget extends StatefulWidget {
  final String title;
  final String text;
  final int index;

  const AnnouncementWidget(
      {super.key,
      required this.title,
      required this.text,
      required this.index});

  @override
  State<AnnouncementWidget> createState() => _AnnouncementWidgetState();
}

class _AnnouncementWidgetState extends State<AnnouncementWidget> {
  String result = '', text = '';
  bool isLoading = false, hasError = false;
  bool isIniting = false;
  final HtmlEditorController controller = HtmlEditorController();

  @override
  void initState() {
    super.initState();
    text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 28.0),
            child: Text(
              widget.title.capitalize(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Text(
                            "Announcements",
                            style: TextStyle(letterSpacing: 1),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.65,
                            child: HtmlEditor(
                              controller: controller,
                              htmlEditorOptions: HtmlEditorOptions(
                                hint: 'Your text here...',
                                darkMode: false,
                                shouldEnsureVisible: true,
                                initialText: text,
                                //initialText: "<p>text content initial, if any</p>",
                              ),
                              htmlToolbarOptions: HtmlToolbarOptions(
                                toolbarPosition:
                                    ToolbarPosition.aboveEditor, //by default
                                toolbarType:
                                    ToolbarType.nativeScrollable, //by default
                                onButtonPressed: (ButtonType type, bool? status,
                                    Function? updateStatus) {
                                  // print(
                                  //     "button '${describeEnum(type)}' pressed, the current selected status is $status");
                                  return true;
                                },
                                onDropdownChanged: (DropdownType type,
                                    dynamic changed,
                                    Function(dynamic)? updateSelectedItem) {
                                  // print(
                                  //     "dropdown '${describeEnum(type)}' changed to $changed");
                                  return true;
                                },
                                mediaLinkInsertInterceptor:
                                    (String url, InsertFileType type) {
                                  print(url);
                                  return true;
                                },
                                mediaUploadInterceptor: (PlatformFile file,
                                    InsertFileType type) async {
                                  print(file.name); //filename
                                  print(file.size); //size in bytes
                                  print(file
                                      .extension); //file extension (eg jpeg or mp4)
                                  return true;
                                },
                              ),
                              otherOptions: const OtherOptions(height: 550),
                              callbacks: Callbacks(
                                  onBeforeCommand: (String? currentHtml) {
                                print('html before change is $currentHtml');
                              }, onChangeContent: (String? changed) {
                                print('content changed to $changed');
                                Provider.of<AnnouncementsProvider>(context,
                                        listen: false)
                                    .onChange(widget.title, changed ?? "");
                              }, onChangeCodeview: (String? changed) {
                                print('code changed to $changed');
                              }, onChangeSelection: (EditorSettings settings) {
                                print(
                                    'parent element is ${settings.parentElement}');
                                print('font name is ${settings.fontName}');
                              }, onDialogShown: () {
                                print('dialog shown');
                              }, onEnter: () {
                                print('enter/return pressed');
                              }, onFocus: () {
                                print('editor focused');
                              }, onBlur: () {
                                print('editor unfocused');
                              }, onBlurCodeview: () {
                                print('codeview either focused or unfocused');
                              }, onInit: () {
                                print('init');
                              },
                                  //this is commented because it overrides the default Summernote handlers
                                  /*onImageLinkInsert: (String? url) {
                                            print(url ?? "unknown url");
                                          },
                                          onImageUpload: (FileUpload file) async {
                                            print(file.name);
                                            print(file.size);
                                            print(file.type);
                                            print(file.base64);
                                          },*/
                                  onImageUploadError: (FileUpload? file,
                                      String? base64Str, UploadError error) {
                                print(base64Str ?? '');
                                if (file != null) {
                                  print(file.name);
                                  print(file.size);
                                  print(file.type);
                                }
                              }, onKeyDown: (int? keyCode) {
                                print('$keyCode key downed');
                                print(
                                    'current character count: ${controller.characterCount}');
                              }, onKeyUp: (int? keyCode) {
                                print('$keyCode key released');
                              }, onMouseDown: () {
                                print('mouse downed');
                              }, onMouseUp: () {
                                print('mouse released');
                              }, onNavigationRequestMobile: (String url) {
                                print(url);
                                return NavigationActionPolicy.ALLOW;
                              }, onPaste: () {
                                print('pasted into editor');
                              }, onScroll: () {
                                print('editor scrolled');
                              }),
                              plugins: [
                                SummernoteAtMention(
                                    getSuggestionsMobile: (String value) {
                                      var mentions = <String>[
                                        'test1',
                                        'test2',
                                        'test3'
                                      ];
                                      return mentions
                                          .where((element) =>
                                              element.contains(value))
                                          .toList();
                                    },
                                    mentionsWeb: ['test1', 'test2', 'test3'],
                                    onSelect: (String value) {
                                      print(value);
                                    }),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
          if (!isLoading)
            CustomButton(onPressed: () async {
              await _submit(widget.title, controller.getText());
            })
          else
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            )
        ],
      ),
    );
  }

  _submit(String type, Future<String> text) async {
    setState(() {
      isLoading = true;
    });
    String t = await text;
    await MongoDB.updateData(
        filter: {
          "type": {"\$eq": type}
        },
        document: {
          "collection": "announcements",
          "type": type,
          "text": t,
          'time': DateTime.now().toIso8601String(),
        },
        upsert: true,
        showLoading: () {},
        onDone: (_) {
          setState(() {
            isLoading = false;
          });
          Helper.showToast("Successful");
        },
        onError: (_) {
          setState(() {
            isLoading = false;
          });
          Helper.showToast(_.toString());
        });
  }
}
