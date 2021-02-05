import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleData {
  ArticleData({
    this.id = '',
    this.title = '',
    this.startColor = '',
    this.endColor = '',
    this.description = '',
    this.rating = 0,
  });

  String id;
  String description;
  String title;
  String startColor;
  String endColor;
  int rating;

  factory ArticleData.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return ArticleData(
      id: doc.id,
      title: data["Title"] ?? null,
      description: data["Description"] ?? null,
      rating: data["Rating"] ?? 0,
      startColor: '#FA7D82',
      endColor: '#FFB295',
    );
  }

  static List<ArticleData> articleList = <ArticleData>[
    ArticleData(
      title: 'Article 1',
      description:
          'This is kdnas dnjanjd jdnasjn jndasknd ndkasnkd kadsnaksnd kdnaksnd kndaskdn kdnaskdn nice book',
      rating: 5,
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    ArticleData(
      title: 'Article 2',
      description: 'This is nice book',
      rating: 5,
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    ArticleData(
      title: 'Article 3',
      description: 'This is nice book',
      rating: 5,
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
  ];
}
