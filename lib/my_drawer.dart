import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final void Function(dynamic,int) onTap;
  final String selected;
  const MyDrawer({super.key, required this.onTap, required this.selected});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.35,
      margin: const EdgeInsets.only(top: 56),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                  widget.onTap.call(_list[index],index);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _list[index],
                    style: TextStyle(
                        color: widget.selected == _list[index]
                            ? Colors.red
                            : Colors.black,
                        fontWeight: widget.selected == _list[index]
                            ? FontWeight.bold
                            : FontWeight.w400),
                  ),
                ),
              );
            }),
      ),
    );
  }

  final List<String> _list = [
    "Latest",
    "Videos",
    "Audio",
    "Books",
    "Account No.",
    "Testimonies",
    "WSF",
    "Announcements"
  ];
}
