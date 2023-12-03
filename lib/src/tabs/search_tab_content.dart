import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class SearchTabContent extends StatefulWidget {
  @override
  _SearchTabContentState createState() => _SearchTabContentState();
}

class _SearchTabContentState extends State<SearchTabContent> {
  String searchType = 'movie';
  String searchText = '';
  List<dynamic> searchResults = [];

  Future<void> performSearch() async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/search/$searchType?api_key=aeb0b75180e36ff760f1a661927880cf&language=pt-BR&query=$searchText',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body)['results'];
      });
    } else {
      throw Exception('Falha na busca');
    }
  }

  void resetSearch() {
    setState(() {
      searchText = '';
      searchResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    resetSearch();
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Digite a palavra-chave',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  performSearch();
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Radio(
                    value: 'movie',
                    groupValue: searchType,
                    onChanged: (value) {
                      resetSearch();
                      setState(() {
                        searchType = value.toString();
                      });
                    },
                  ),
                  Text('Filmes'),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 'tv',
                    groupValue: searchType,
                    onChanged: (value) {
                      resetSearch();
                      setState(() {
                        searchType = value.toString();
                      });
                    },
                  ),
                  Text('Séries'),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 'person',
                    groupValue: searchType,
                    onChanged: (value) {
                      resetSearch();
                      setState(() {
                        searchType = value.toString();
                      });
                    },
                  ),
                  Text('Pessoas'),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: searchResults.isEmpty
              ? Center(
                  child: Text('Sem Resultados'),
                )
              : ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        navigateToDetailScreen(
                            context, searchResults[index], searchType);
                      },
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          searchType == 'person'
                              ? 'https://image.tmdb.org/t/p/w154${searchResults[index]['profile_path']}'
                              : 'https://image.tmdb.org/t/p/w154${searchResults[index]['poster_path']}',
                        ),
                      ),
                      title: Text(searchResults[index]['name'] ??
                          searchResults[index]['title'] ??
                          ''),
                    );
                  },
                ),
        ),
      ],
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
