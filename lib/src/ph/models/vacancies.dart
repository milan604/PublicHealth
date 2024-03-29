import 'package:cloud_firestore/cloud_firestore.dart';

class Vacancies {
  Vacancies({
    this.id = '',
    this.title = '',
    this.startDate = '',
    this.endDate = '',
    this.description = '',
    this.issuer = '',
    this.post = '',
    this.location = '',
    this.timestamp = '',
    this.link = '',
  });

  String description;
  String title;
  String startDate;
  String endDate;
  String issuer;
  String post;
  String id;
  String location;
  String timestamp;
  String link;

  factory Vacancies.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Vacancies(
      id: doc.id,
      title: data["Title"] ?? "",
      description: data["Description"] ?? null,
      issuer: data["Issuer"] ?? null,
      post: data["Post"] ?? null,
      location: data["Location"] ?? "",
      startDate: data["StartDate"] ?? null,
      endDate: data["EndDate"] ?? null,
      timestamp: data["Timestamp"] ?? null,
      link: data["Link"] ?? "",
    );
  }
}
