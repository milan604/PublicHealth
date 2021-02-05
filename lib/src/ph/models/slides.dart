import 'package:cloud_firestore/cloud_firestore.dart';

class SlideData {
  SlideData({
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

  factory SlideData.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return SlideData(
      id: doc.id,
      title: data["Title"] ?? null,
      description: data["Description"] ?? null,
      rating: data["Rating"] ?? 0,
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    );
  }

  static List<SlideData> slideList = <SlideData>[
    SlideData(
      title: 'Slide 1',
      description:
          'This is kdnas dnjanjd jdnasjn jndasknd ndkasnkd kadsnaksnd kdnaksnd kndaskdn kdnaskdn nice book',
      rating: 5,
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    SlideData(
      title: 'Slide 2',
      description: 'This is nice book',
      rating: 5,
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    SlideData(
      title: 'Slide 3',
      description: 'This is nice book',
      rating: 5,
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
  ];
}
