import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news/db/db.dart';
import 'package:news/models/models.dart';
import 'package:http/http.dart' as http;

class NewsProvider with ChangeNotifier {
  static const baseUrl = 'https://hacker-news.firebaseio.com/v0';
  final Map<int, NewsItem> _newsList;
  List<dynamic> _topStories;
  List<dynamic> _favorites;

  NewsProvider()
      : _newsList = {},
        _topStories = List.empty(),
        _favorites = List.empty(growable: true);

  Future<void> fetchTopStories() async {
    var response = await http.get(Uri.parse('$baseUrl/topstories.json'));
    _topStories = jsonDecode(response.body);
  }

  List<dynamic> get topStories {
    return _topStories;
  }

  List<dynamic> get favorites {
    return _favorites;
  }

  Future<void> fetchById(int id) async {
    if (!_newsList.containsKey(id)) {
      try {
        final response = await http.get(Uri.parse('$baseUrl/item/$id.json'));
        _newsList[id] = NewsItem.fromJson(jsonDecode(response.body));
      } catch (e) {}
    }
  }

  NewsItem? getById(int id) {
    if (_newsList.containsKey(id)) {
      return _newsList[id]!;
    }
    return NewsItem(id: 0, title: "Invalid Id", by: "", time: DateTime.now(), score: 0);
  }

  Future<void> fetchFromDb() async {
    var items = await DBHelper.select();
    var todos = items.map((e) => NewsItem.fromJson(e));
  }

  void toggleFavorite(int id) {
    if (_newsList.containsKey(id)) {
      _newsList[id]!.isFavorite = !(_newsList[id]!.isFavorite ?? false);
      if (_newsList[id]!.isFavorite ?? false) {
        _favorites.add(id);
      } else {
        _favorites.remove(id);
      }
      notifyListeners();
    }
  }

/* 
  Future<NewsItem> getById(String id) {

  } */

}
