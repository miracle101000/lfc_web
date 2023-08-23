import 'package:flutter/material.dart';
import 'package:lfc_web/provider/wsf_provider.dart';
import 'package:lfc_web/screens/widgets/custom_button.dart';
import 'package:lfc_web/screens/widgets/custom_text_field.dart';
import 'package:lfc_web/screens/wsf/wsf_dialog.dart';
import 'package:provider/provider.dart';

import '../../services/helpers.dart';
import '../../services/mongo_server.dart';

class WSFList extends StatefulWidget {
  const WSFList({super.key});

  @override
  State<WSFList> createState() => _WSFListState();
}

class _WSFListState extends State<WSFList> {
  // late WSFProvider wsf;
  bool isLoading = false, hasError = false, isLoadMore = false;
  List list = [];
  var _lastDocument;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // wsf = Provider.of<WSFProvider>(context, listen: false);
    _get();
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (!isLoadMore) {
          if (mounted) {
            setState(() {
              isLoadMore = true;
            });
          }
          await _get(loadMore: true);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WSFProvider>(builder: (context, wsf, _) {
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
                  : ListView.builder(
                      itemCount: wsf.list.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              // onEnd: () {
                              //   if (wsf.show[wsf.list[index]['name']] == true) {
                              //     wsf.updateDone(wsf.list[index]['name'], true);
                              //   }
                              // },
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12)),
                              // duration: const Duration(milliseconds: 200),
                              height: wsf.show[wsf.list[index]['name']] == true
                                  ? 60 +
                                      (69 *
                                          (wsf.list[index]['list'].length
                                                  as int)
                                              .toDouble())
                                  : 60,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: SizedBox(
                                                child: Text(
                                                  wsf.list[index]['name']
                                                      .toString()
                                                      .capitalize(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              if (wsf.list[index]['name'] !=
                                                  "Trademore")
                                                GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onTap: () async {
                                                    await _delete(
                                                      wsf.list[index]['id'],
                                                      wsf.list[index]['name'],
                                                    );
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0),
                                                    child: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              GestureDetector(
                                                behavior:
                                                    HitTestBehavior.opaque,
                                                onTap: () {
                                                  _showDialog(
                                                      wsf.list[index]['name'],
                                                      wsf.list[index]['id']);
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "+",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.orange,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (wsf.show[wsf.list[index]
                                                          ['name']] ==
                                                      true) {
                                                    wsf.updateShow(
                                                        wsf.list[index]['name'],
                                                        false);
                                                    wsf.updateDone(
                                                        wsf.list[index]['name'],
                                                        false);
                                                  } else {
                                                    wsf.updateShow(
                                                        wsf.list[index]['name'],
                                                        true);
                                                    wsf.updateDone(
                                                        wsf.list[index]['name'],
                                                        true);
                                                  }
                                                },
                                                child: RotatedBox(
                                                  quarterTurns: wsf.show[
                                                              wsf.list[index]
                                                                  ['name']] ==
                                                          true
                                                      ? 0
                                                      : 2,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Image.asset(
                                                      "assets/arrow.png",
                                                      height: 24,
                                                      width: 24,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (wsf.onDone[wsf.list[index]['name']] ==
                                      true)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: SizedBox(
                                        height: 69 *
                                            (wsf.list[index]['list'].length
                                                    as int)
                                                .toDouble(),
                                        child: ListView.builder(
                                            itemCount:
                                                wsf.list[index]['list'].length,
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (_, ind) {
                                              Map data =
                                                  wsf.list[index]['list'][ind];
                                              return SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.45,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 69,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              data['address'],
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              data['phone'],
                                                              maxLines: 1,
                                                            ),
                                                            if (data
                                                                .containsKey(
                                                                    'phase'))
                                                              Text(
                                                                data['phase'],
                                                                maxLines: 1,
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .opaque,
                                                      onTap: () async {
                                                        await _delete(
                                                            wsf.list[index]
                                                                ['id'],
                                                            wsf.list[index]
                                                                ['name'],
                                                            data['address']);
                                                      },
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.0),
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        );
                      }));
    });
  }

  _showDialog(String key, String id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.red.withOpacity(0.05),
        builder: (_) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: WSFDialog(
                keya: key,
                id: id,
              ));
        });
  }

  _get({bool? loadMore}) async {
    WSFProvider wsf = Provider.of<WSFProvider>(context, listen: false);
    await MongoDB.getData(
        filter: {
          'collection': {'\$eq': 'wsf'},
          if (loadMore != null)
            '_id': {
              '\$gt': {'\$oid': _lastDocument['_id']}
            }
        },
        projection: {},
        sortBy: '_id',
        limit: 40,
        showLoading: () {
           if (loadMore == null)setisLoadingHasError(true, false);
        },
        onDone: (_) {
          setState(() {
            if (_.isNotEmpty) {
              _.forEach((d) {
                wsf.setList(
                    {'name': d['estate'], 'list': d['list'], 'id': d['_id']});
              });
              _lastDocument = _.last;
            } else {
              if (loadMore == null && wsf.list.isEmpty)
                wsf.setList({'name': 'Trademore', 'list': [], 'id': ''});
            }
            isLoadMore = false;
          });
          if (loadMore == null) setisLoadingHasError(false, false);
        },
        onError: (_) {
          setisLoadingHasError(false, true);
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

  _delete(String id, String estate, [String? address]) async {
    var data = Provider.of<WSFProvider>(context, listen: false)
        .list
        .where((element) =>
            element['name'].toString().toLowerCase() == estate.toLowerCase())
        .toList()[0];
    List d = data['list'];
    d.removeWhere((element) => element['address'] == address);
    if (address != null) {
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
            setisLoadingHasError(true, false);
          },
          onDone: (_) {
            Provider.of<WSFProvider>(context, listen: false)
                .removeListUpdate(estate, data);
            setisLoadingHasError(false, false);
            Helper.showToast("Successful");
          },
          onError: (_) {
            setisLoadingHasError(false, true);
            Helper.showToast(_.toString());
          });
      Provider.of<WSFProvider>(context, listen: false).refreshm();
    } else {
      if (id.isNotEmpty) {
        await MongoDB.deleteData(
            filter: {
              '_id': {'\$oid': id}
            },
            showLoading: () {
              setisLoadingHasError(true, false);
            },
            onDone: (_) {
              setisLoadingHasError(false, false);
              Helper.showToast("Successful");
            },
            onError: (_) {
              setisLoadingHasError(false, true);
              Helper.showToast(_.toString());
            });
        Provider.of<WSFProvider>(context, listen: false).refreshm();
      } else {
        Provider.of<WSFProvider>(context, listen: false).removeList(estate);
      }
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
