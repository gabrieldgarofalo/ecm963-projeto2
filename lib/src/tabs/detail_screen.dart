import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_orientation/auto_orientation.dart';

class DetailScreen extends StatefulWidget {
  final dynamic item;
  final String type;

  DetailScreen({required this.item, required this.type});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic> detailedInfo = {};

  @override
  void initState() {
    super.initState();
    fetchDetails();
    AutoOrientation.landscapeRightMode();
  }

  Future<void> fetchDetails() async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/${widget.type}/${widget.item['id']}?api_key=aeb0b75180e36ff760f1a661927880cf&language=pt-BR',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        detailedInfo = json.decode(response.body);
      });
    } else {
      throw Exception('Falha ao carregar detalhes');
    }
  }

  @override
  void dispose() {
    AutoOrientation.fullAutoMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item['name'] ?? ''),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              getImageUrl(),
              fit: BoxFit.cover,
              height: 400,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildDetailRows([
                    _buildDetailRow('Orçamento', detailedInfo['budget']),
                    _buildDetailRow('Tagline', detailedInfo['tagline']),
                    _buildDetailRow(
                        'Nota Média', detailedInfo['vote_average']),
                    _buildDetailRow(
                        'Número de Votos', detailedInfo['vote_count']),
                    _buildDetailRow('Receita', detailedInfo['revenue']),
                    _buildDetailRow('Duração', detailedInfo['runtime']),
                    _buildDetailRow(
                        'Visão Geral', detailedInfo['overview']),
                    _buildDetailRow(
                        'Título Original',
                        detailedInfo['original_title']),
                    _buildDetailRow(
                        'Gêneros', getGenres(detailedInfo['genres'] ?? [])),
                    _buildDetailRow(
                        'Data de Estreia',
                        detailedInfo['first_air_date']),
                    _buildDetailRow(
                        'Data do Último Episódio',
                        detailedInfo['last_air_date']),
                    _buildDetailRow('Nome', detailedInfo['name']),
                    _buildDetailRow(
                        'Número de Episódios',
                        detailedInfo['number_of_episodes']),
                    _buildDetailRow(
                        'Número de Temporadas',
                        detailedInfo['number_of_seasons']),
                    _buildDetailRow(
                        'Biografia', detailedInfo['biography']),
                    _buildDetailRow(
                        'Data de Nascimento', detailedInfo['birthday']),
                    _buildDetailRow(
                        'Local de Nascimento',
                        detailedInfo['place_of_birth']),
                    _buildDetailRow(
                        'Popularidade', detailedInfo['popularity']),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value.toString(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDetailRows(List<Widget> rows) {
    return rows.whereType<Widget>().toList();
  }

  String getImageUrl() {
    if (widget.type == 'person') {
      return 'https://image.tmdb.org/t/p/w500${widget.item['profile_path']}';
    } else {
      return 'https://image.tmdb.org/t/p/w500${widget.item['poster_path']}';
    }
  }

  String getGenres(List<dynamic> genres) {
    return genres.map((genre) => genre['name']).join(', ');
  }
}
