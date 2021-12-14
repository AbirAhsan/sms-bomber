import 'package:flutter/material.dart';
import 'package:smsbomber/screen/tab_screen/for_multi_number.dart';
import 'package:smsbomber/screen/tab_screen/for_single_number.dart';
import 'package:smsbomber/widget/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          //  automaticallyImplyLeading: false,
          title: const Text("SMS Bomber 💣"),
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            tabs: [
              Tab(
                child: Text("To Single Number"),
              ),
              Tab(
                child: Text("To Multi Number"),
              ),
            ],
          ),
        ),
        drawer: const Drawer(
          child: CustomDrawer(),
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
