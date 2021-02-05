import 'package:cloud_firestore/cloud_firestore.dart';

class VideoData {
  VideoData({
    this.id = '',
    this.title = '',
    this.startColor = '',
    this.endColor = '',
    this.description = '',
    this.rating = 0,
    this.link = '',
  });

  String id;
  String description;
  String title;
  String startColor;
  String endColor;
  String link;
  int rating;

  factory VideoData.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return VideoData(
      id: doc.id,
      title: data["Title"] ?? null,
      description: data["Description"] ?? null,
      link: data["Link"] ?? null,
      rating: data["Rating"] ?? 0,
      startColor: '#FE95B6',
      endColor: '#FF5287',
    );
  }

  static List<VideoData> videoList = <VideoData>[
    VideoData(
      title: 'Videos 1',
      description:
          'This is kdnas dnjanjd jdnasjn jndasknd ndkasnkd kadsnaksnd kdnaksnd kndaskdn kdnaskdn nice book',
      rating: 5,
      link: 'link_1',
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    VideoData(
      title: 'Videos 2',
      description: 'This is nice book',
      rating: 5,
      link: 'link_1',
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    VideoData(
      title: 'Videos 3',
      description: 'This is nice book',
      rating: 5,
      link: 'link_1',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
  ];
}
