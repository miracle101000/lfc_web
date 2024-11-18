import 'package:flutter/material.dart';
import 'package:lfc_web/provider/video_provider.dart';
import 'package:lfc_web/screens/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:extended_image/extended_image.dart';
import '../../services/helpers.dart';
import '../../services/mongo_server.dart';

class LatestVideosList extends StatefulWidget {
  const LatestVideosList({super.key});

  @override
  State<LatestVideosList> createState() => _LatestVideosListState();
}

class _LatestVideosListState extends State<LatestVideosList> {
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
                          "No videos are available",
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
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      ExtendedImage.network(
                                        list[index]['image_url'],
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                      ),
                                      // Positioned(
                                      //     bottom: 16,
                                      //     left: 16,
                                      //     child: Length(
                                      //         length: list[index]['length']
                                      //             .toString())),
                                      Positioned(
                                        top: 16,
                                        right: 16,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: ElevatedButton(
                                                  style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.red)),
                                                  onPressed: () async {
                                                    Provider.of<
                                                            LatestVideoProvider>(
                                                        context,
                                                        listen: false)
                                                      ..title =
                                                          list[index]['text']
                                                      // ..description =
                                                      //     list[index]
                                                      //         ['description']
                                                      ..isEdit = true
                                                      ..id = list[index]['_id']
                                                      ..image_url = list[index]
                                                          ['image_url']
                                                      ..video_link = list[index]
                                                              ['video_link']
                                                          // ..length = list[index]
                                                          //         ['length']
                                                          .toString();
                                                  },
                                                  child: const Text("Edit")),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: ElevatedButton(
                                                  style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.red)),
                                                  onPressed: () async {
                                                    await _delete(
                                                        list[index]['_id'],
                                                        list[index]
                                                            ['image_url']);
                                                  },
                                                  child: const Text("Delete")),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0, horizontal: 8),
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
                                                child:
                                                    Text(list[index]['text']),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  list[index]['video_link'],
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
          'collection': {'\$eq': 'latest'},
          'type': {'\$eq': 'video'},
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
    if (mounted) {
      setState(() {
        isLoading = v;
        hasError = v1;
      });
    }
  }

  _delete(String id, String url) async {
    if (mounted) {
      setState(() {
        list.clear();
      });
    }
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
