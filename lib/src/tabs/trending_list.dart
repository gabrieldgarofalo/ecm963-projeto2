import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';


class TrendingList extends StatefulWidget {
  final String type;

  TrendingList({required this.type});

  @override
  _TrendingListState createState() => _TrendingListState();
}

class _TrendingListState extends State<TrendingList> {
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/trending/${widget.type}/week?api_key=aeb0b75180e36ff760f1a661927880cf&language=pt-BR',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body)['results'];
      });
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            navigateToDetailScreen(context, items[index], widget.type);
          },
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              'https://image.tmdb.org/t/p/w154${items[index]['poster_path']}',
            ),
          ),
          title: Text(items[index]['name'] ?? items[index]['title'] ?? ''),
        );
      },
    );
  }

  void navigateToDetailScreen(
      BuildContext context, dynamic item, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(item: item, type: type),
      ),
    );
  }
}
