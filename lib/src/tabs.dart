import 'package:flutter/material.dart';
import 'tabs/trending_list.dart';
import 'tabs/trending_people_list.dart';
import 'tabs/search_tab_content.dart';

class Tabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projeto 2'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Trending Movies'),
            Tab(text: 'Trending TV'),
            Tab(text: 'Trending People'),
            Tab(text: 'Buscar'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          TrendingList(type: 'movie'),
          TrendingList(type: 'tv'),
          TrendingPeopleList(),
          SearchTabContent(),
        ],
      ),
    );
  }
}
