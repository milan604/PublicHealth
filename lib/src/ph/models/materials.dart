import 'package:cloud_firestore/cloud_firestore.dart';

class Materials {
  Materials({
    this.id = '',
    this.title = '',
    this.startColor = '',
    this.endColor = '',
    this.description = '',
    this.author = '',
    this.filePath = '',
    this.link = '',
  });

  String description;
  String title;
  String startColor;
  String endColor;
  String author;
  String filePath;
  String id;
  String link;

  factory Materials.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Materials(
      id: doc.id,
      title: data["Title"] ?? null,
      description: data["Description"] ?? null,
      author: data["Author"] ?? null,
      filePath: data["FilePath"] ?? null,
      link: data["Link"] ?? null,
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    );
  }

  static List<Materials> materials = <Materials>[
    Materials(
      title: 'book 1',
      author: 'milan',
      description:
          'This is kdnas dnjanjd jdnasjn jndasknd ndkasnkd kadsnaksnd kdnaksnd kndaskdn kdnaskdn nice book',
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    Materials(
      title: 'book 2',
      description: 'This is nice book',
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    Materials(
      title: 'book 3',
      author: 'milan',
      description: 'This is nice book',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    Materials(
      title: 'book 4',
      description: 'This is nice book',
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    Materials(
      title: 'book 5',
      description: 'This is nice book',
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    Materials(
      title: 'book 6',
      description: 'This is nice book',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    Materials(
      title: 'book 7',
      description: 'This is nice book',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    Materials(
      title: 'book 1',
      description:
          'This is kdnas dnjanjd jdnasjn jndasknd ndkasnkd kadsnaksnd kdnaksnd kndaskdn kdnaskdn nice book',
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    Materials(
      title: 'book 2',
      description: 'This is nice book',
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    Materials(
      title: 'book 3',
      description: 'This is nice book',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    Materials(
      title: 'book 4',
      description: 'This is nice book',
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    Materials(
      title: 'book 5',
      description: 'This is nice book',
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    Materials(
      title: 'book 6',
      description: 'This is nice book',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    Materials(
      title: 'book 7',
      description: 'This is nice book',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    Materials(
      title: 'book 1',
      description:
          'This is kdnas dnjanjd jdnasjn jndasknd ndkasnkd kadsnaksnd kdnaksnd kndaskdn kdnaskdn nice book',
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    Materials(
      title: 'book 2',
      description: 'This is nice book',
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    Materials(
      title: 'book 3',
      description: 'This is nice book',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    Materials(
      title: 'book 4',
      description: 'This is nice book',
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    Materials(
      title: 'book 5',
      description: 'This is nice book',
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    Materials(
      title: 'book 6',
      description: 'This is nice book',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    Materials(
      title: 'book 7',
      description: 'This is nice book',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    Materials(
      title: 'book 1',
      description:
          'This is kdnas dnjanjd jdnasjn jndasknd ndkasnkd kadsnaksnd kdnaksnd kndaskdn kdnaskdn nice book',
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    Materials(
      title: 'book 2',
      description: 'This is nice book',
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    Materials(
      title: 'book 3',
      description: 'This is nice book',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    Materials(
      title: 'book 4',
      description: 'This is nice book',
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    Materials(
      title: 'book 5',
      description: 'This is nice book',
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    Materials(
      title: 'book 6',
      description: 'This is nice book',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    Materials(
      title: 'book 7',
      description: 'This is nice book',
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
  ];
}
