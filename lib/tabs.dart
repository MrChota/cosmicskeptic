import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cosmicskeptic/screens/Blog.dart';
import 'package:cosmicskeptic/screens/Veganuary.dart';
import 'package:cosmicskeptic/screens/YouTube.dart';

class MyTabs extends StatefulWidget {
  @override
  _MyTabsState createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  // dispose function
  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.black,
        child: TabBar(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.blue,
          labelStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
          tabs: <Tab>[
            Tab(
              icon: Icon(FontAwesomeIcons.blog),
              text: "Blog",
            ),
            Tab(
              icon: Icon(FontAwesomeIcons.goodreadsG),
              text: "Veganuary",
            ),
            Tab(
              icon: Icon(FontAwesomeIcons.youtube),
              text: "YouTube",
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: <Widget>[
          Blog(),
          Veganuary(),
          YouTube(),
        ],
      ),
    );
  }
}