import 'package:flutter/material.dart';
import 'tabs.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto 2',
      home: DefaultTabController(
        length: 4,
        initialIndex: 3,
        child: Tabs(),
      ),
    );
  }
}
