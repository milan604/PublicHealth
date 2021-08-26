import 'package:cloud_firestore/cloud_firestore.dart';

class NewsData {
  NewsData({
    this.id = '',
    this.title = '',
    this.description = '',
    this.news = '',
    this.imagePath = '',
  });

  String id;
  String description;
  String title;
  String news;
  String imagePath;

  factory NewsData.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return NewsData(
        id: doc.id,
        title: data["Title"] ?? null,
        description: data["Description"] ?? null,
        imagePath: data["ImagePath"] ?? null,
        news: data["News"] ?? null);
  }

  static List<NewsData> newsList = <NewsData>[
    NewsData(
        id: 'id_1',
        title: 'News Post',
        imagePath: 'assets/images/ph/coming-soon.png',
        description: 'New Section will come soon. We are working on it.',
        news:
            'Pleased him another was settled for. Moreover end horrible endeavor entrance any families. Income appear extent on of thrown in admire. Stanhill on we if vicinity material in. Saw him smallest you provided ecstatic supplied. Garret wanted expect remain as mr. Covered parlors concern we express in visited to do. Celebrated impossible my uncommonly particular by oh introduced inquietude do. '),
    // NewsData(
    //     id: 'id_2',
    //     title: 'Biostatistics',
    //     imagePath: 'assets/images/general_k.png',
    //     description: 'This is nice book',
    //     news:
    //         'Pleased him another was settled for. Moreover end horrible endeavor entrance any families. Income appear extent on of thrown in admire. Stanhill on we if vicinity material in. Saw him smallest you provided ecstatic supplied. Garret wanted expect remain as mr. Covered parlors concern we express in visited to do. Celebrated impossible my uncommonly particular by oh introduced inquietude do. '),
    // NewsData(
    //     id: 'id_3',
    //     title: 'Research Methodology',
    //     imagePath: 'assets/images/general_k.png',
    //     description: 'This is nice book',
    //     news:
    //         'Pleased him another was settled for. Moreover end horrible endeavor entrance any families. Income appear extent on of thrown in admire. Stanhill on we if vicinity material in. Saw him smallest you provided ecstatic supplied. Garret wanted expect remain as mr. Covered parlors concern we express in visited to do. Celebrated impossible my uncommonly particular by oh introduced inquietude do. '),
    // NewsData(
    //     id: 'id_4',
    //     title: 'Epidemiology',
    //     imagePath: 'assets/images/general_k.png',
    //     description: 'This is nice book',
    //     news:
    //         'Pleased him another was settled for. Moreover end horrible endeavor entrance any families. Income appear extent on of thrown in admire. Stanhill on we if vicinity material in. Saw him smallest you provided ecstatic supplied. Garret wanted expect remain as mr. Covered parlors concern we express in visited to do. Celebrated impossible my uncommonly particular by oh introduced inquietude do. '),
    // NewsData(
    //     id: 'id_5',
    //     title: 'Biostatistics',
    //     imagePath: 'assets/images/general_k.png',
    //     description: 'This is nice book',
    //     news:
    //         'Pleased him another was settled for. Moreover end horrible endeavor entrance any families. Income appear extent on of thrown in admire. Stanhill on we if vicinity material in. Saw him smallest you provided ecstatic supplied. Garret wanted expect remain as mr. Covered parlors concern we express in visited to do. Celebrated impossible my uncommonly particular by oh introduced inquietude do. '),
    // NewsData(
    //     id: 'id_6',
    //     title: 'Research Methodology',
    //     imagePath: 'assets/images/general_k.png',
    //     description: 'This is nice book',
    //     news:
    //         'Pleased him another was settled for. Moreover end horrible endeavor entrance any families. Income appear extent on of thrown in admire. Stanhill on we if vicinity material in. Saw him smallest you provided ecstatic supplied. Garret wanted expect remain as mr. Covered parlors concern we express in visited to do. Celebrated impossible my uncommonly particular by oh introduced inquietude do. ')
  ];
}
