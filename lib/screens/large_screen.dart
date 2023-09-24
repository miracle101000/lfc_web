import 'package:flutter/material.dart';
import 'package:lfc_web/my_drawer.dart';
import 'package:lfc_web/provider/announcements_provider.dart';
import 'package:lfc_web/screens/accounts/accounts_main.dart';
import 'package:lfc_web/screens/announcements/announcements.dart';
import 'package:lfc_web/screens/audio/audio_main.dart';
import 'package:lfc_web/screens/books/books_main.dart';
import 'package:lfc_web/screens/latest/latest_main.dart';
import 'package:lfc_web/screens/pamphlets/pamphlets_main.dart';
import 'package:lfc_web/screens/testimonies/testimonies_main.dart';
import 'package:lfc_web/screens/videos/videos_main.dart';
import 'package:lfc_web/screens/wsf/wsf_main.dart';
import 'package:provider/provider.dart';

import '../provider/wsf_provider.dart';

class LargeScreen extends StatefulWidget {
  const LargeScreen({super.key});

  @override
  State<LargeScreen> createState() => _LargeScreenState();
}

class _LargeScreenState extends State<LargeScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  String selected = "Latest";
  bool isOpen = false;
  int currentIndex = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(
        onTap: (_, index) {
          setState(() {
            selected = _;
            currentIndex = index;
          });
          pageController.jumpToPage(currentIndex);
          Provider.of<WSFProvider>(context, listen: false).refreshToFalse();
          Navigator.pop(context);
        },
        selected: selected,
      ),
      drawerScrimColor: const Color(0xffED3237).withOpacity(0.05),
      key: _key,
      appBar: AppBar(
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              isOpen = !isOpen;
            });
            if (isOpen) {
              _key.currentState!.openDrawer();
            } else {
              _key.currentState!.closeDrawer();
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Center(
                child: Image.asset(
              "assets/menu.png",
              color: Colors.white,
              width: 24,
              height: 24,
            )),
          ),
        ),
        centerTitle: false,
        title: const Text(
          "LFC TRADEMORE ADMIN",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: const Color(0xffED3237),
        // leadingWidth: 200,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          const LatestMain(),
          const VideosMain(),
          const AudioMain(),
          const BooksMain(),
          const PamphletsMain(),
          const AccountsMain(),
          const TestimoniesMain(),
          const WSFMain(),
          Consumer<AnnouncementsProvider>(builder: (context, a, _) {
            return a.refresh ? const SizedBox() : const Announcements();
          }),
        ],
      ),
    );
  }
}
