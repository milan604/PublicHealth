import 'package:cloud_firestore/cloud_firestore.dart';

class Scholarships {
  Scholarships({
    this.id = '',
    this.title = '',
    this.startDate = '',
    this.startDateTime,
    this.endDate = '',
    this.description = '',
    this.issuer = '',
    this.post = '',
    this.location = '',
    this.timestamp = '',
    this.link = '',
    this.recurring = false,
  });

  String description;
  String title;
  String startDate;
  Timestamp startDateTime;
  String endDate;
  String issuer;
  String post;
  String id;
  String location;
  String timestamp;
  String link;
  bool recurring;

  factory Scholarships.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Scholarships(
      id: doc.id,
      title: data["Title"] ?? "",
      description: data["Description"] ?? null,
      issuer: data["Issuer"] ?? null,
      post: data["Post"] ?? null,
      location: data["Location"] ?? "",
      startDate: data["StartDate"] ?? null,
      startDateTime: data["StartDateTime"] ?? null,
      endDate: data["EndDate"] ?? null,
      link: data["Link"] ?? "",
      recurring: data["Recurring"] ?? false,
    );
  }
}
