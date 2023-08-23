import 'package:flutter/material.dart';
import 'package:lfc_web/provider/audio_provider.dart';
import 'package:lfc_web/screens/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../services/helpers.dart';
import '../../services/mongo_server.dart';
import '../../widgets/custom_button.dart';

class AudioList extends StatefulWidget {
  const AudioList({super.key});

  @override
  State<AudioList> createState() => _AudioListState();
}

class _AudioListState extends State<AudioList> {
  bool isLoading = false, hasError = false, isLoadMore = false;
  List list = [];
  var _lastDocument;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _get();
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (!isLoadMore) {
          if (mounted)
            setState(() {
              isLoadMore = true;
            });
          await _get(loadMore: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: isLoading && !hasError
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
          : !isLoading && hasError
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.red)),
                            onPressed: () async {
                              await _get();
                            },
                            child: const Text("Error"))),
                  ],
                )
              : list.isEmpty
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          "No audios are available",
                          style: TextStyle(color: Colors.grey),
                        )),
                      ],
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      controller: scrollController,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      child: Image.network(
                                        list[index]['image_url'],
                                        height: 100,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(list[index]['title']),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(
                                                list[index]['audio_link'],
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade500),
                                              ),
                                            ),
                                            Length(
                                                length: list[index]['length']
                                                    .toString()),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: CustomListButton(
                                          onPressed: () async {
                                             Provider.of<AudioProvider>(
                                                        context,
                                                        listen: false)
                                                      ..title =
                                                          list[index]['title']
                                                          ..isEdit=true
                                                      ..audio_url =
                                                          list[index]
                                                              ['audio_link']
                                                              ..id =  list[index]
                                                              ['_id']
                                                      ..image_url = list[index]
                                                          ['image_url']
                                                      ..length = list[index]
                                                              ['length']
                                                          .toString();
                                                  },
                                          text: "Edit"),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: CustomListButton(
                                          onPressed: () async {
                                            await _delete(list[index]['_id'],
                                                list[index]['image_url']);
                                          },
                                          text: "Delete"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
    );
  }

  _get({bool? loadMore}) async {
    if (loadMore == null) list.clear();
    await MongoDB.getData(
        filter: {
          'collection': {'\$eq': 'audios'},
          if (loadMore != null)
            '_id': {
              '\$gt': {'\$oid': _lastDocument['_id']}
            }
        },
        projection: {},
        sortBy: '_id',
        limit: 20,
        showLoading: () {
          if (loadMore == null) setisLoadingHasError(true, false);
        },
        onDone: (_) {
          list.addAll(_);
          if (mounted) {
            setState(() {
              if (_.isNotEmpty) {
                _lastDocument = _.last;
              }
              isLoadMore = false;
            });
          }
          if (loadMore == null) setisLoadingHasError(false, false);
        },
        onError: (_) {
          if (loadMore == null) setisLoadingHasError(false, true);
          isLoadMore = false;
        });
  }

  setisLoadingHasError(bool v, bool v1) {
    if (mounted)
      setState(() {
        isLoading = v;
        hasError = v1;
      });
  }

  _delete(String id, String url) async {
    if (mounted)
      setState(() {
        list.clear();
      });
    await MongoDB.deleteData(
        filter: {
          '_id': {'\$oid': id}
        },
        showLoading: () {
          setisLoadingHasError(true, false);
        },
        onDone: (_) async {
          Helper.showToast(_.toString());
          await Helper.deleteFromStorage(url);
          await _get();
        },
        onError: (_) {
          setisLoadingHasError(false, false);
          Helper.showToast(_.toString());
        });
  }
}
