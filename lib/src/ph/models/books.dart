import 'package:cloud_firestore/cloud_firestore.dart';

class BookData {
  BookData({
    this.id = '',
    this.title = '',
    this.startColor = '',
    this.endColor = '',
    this.description = '',
    this.rating = 0,
    this.imagePath = '',
  });

  String id;
  String description;
  String title;
  String startColor;
  String endColor;
  int rating;
  String imagePath;

  factory BookData.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return BookData(
      id: doc.id,
      title: data["Title"] ?? null,
      description: data["Description"] ?? null,
      imagePath: data["ImagePath"] ?? null,
      rating: data["Rating"] ?? 0,
      startColor: '#FA7D82',
      endColor: '#FFB295',
    );
  }

  static List<BookData> bookList = <BookData>[
    BookData(
      id: 'id_1',
      title: 'Epidemiology',
      description:
          'This is kdnas dnjanjd jdnasjn jndasknd ndkasnkd kadsnaksnd kdnaksnd kndaskdn kdnaskdn nice book',
      rating: 5,
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    BookData(
      id: 'id_2',
      title: 'Biostatistics',
      description: 'This is nice book',
      rating: 5,
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    BookData(
      id: 'id_3',
      title: 'Research Methodology',
      description: 'This is nice book',
      rating: 5,
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    BookData(
      id: 'id_4',
      title: 'Epidemiology',
      description: 'This is nice book',
      rating: 5,
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    BookData(
      id: 'id_5',
      title: 'Biostatistics',
      description: 'This is nice book',
      rating: 5,
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    BookData(
      id: 'id_6',
      title: 'Research Methodology',
      description: 'This is nice book',
      rating: 5,
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
  ];
}
