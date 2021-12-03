import 'package:flutter/material.dart';
import 'package:smsbomber/screen/tab_screen/for_multi_number.dart';
import 'package:smsbomber/screen/tab_screen/for_single_number.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("SMS Bomber"),
          bottom: const TabBar(tabs: [
            Tab(
              child: Text("Single Number"),
            ),
            Tab(
              child: Text("Multi Number"),
            ),
          ]),
        ),
        body: const SizedBox(
          child: TabBarView(children: [
            ForSingleNumber(),
            ForMultiNumber(),
          ]),
        ),
      ),
    );
  }
}
