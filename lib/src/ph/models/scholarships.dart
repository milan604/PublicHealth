import 'package:cloud_firestore/cloud_firestore.dart';

class Scholarships {
  Scholarships({
    this.id = '',
    this.title = '',
    this.startDate,
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
  Timestamp startDate;
  String endDate;
  String issuer;
  String post;
  String id;
  String location;
  String timestamp;
  String link;

  factory Scholarships.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Scholarships(
      id: doc.id,
      title: data["Title"] ?? "",
      description: data["Description"] ?? null,
      issuer: data["Issuer"] ?? null,
      post: data["Post"] ?? null,
      location: data["Location"] ?? "",
      startDate: data["startDate"] ?? null,
      endDate: data["endDate"] ?? null,
      link: data["Link"] ?? "",
    );
  }
}
