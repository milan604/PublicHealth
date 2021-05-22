import 'package:flutter/material.dart';

class CourseTabData {
  CourseTabData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.label = '',
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  String label;
  bool isSelected;
  int index;

  AnimationController animationController;

  static List<CourseTabData> tabIconsList = <CourseTabData>[
    CourseTabData(
      imagePath: 'assets/images/ph/tab_1.png',
      selectedImagePath: 'assets/images/ph/tab_1s.png',
      label: 'My',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    CourseTabData(
      imagePath: 'assets/images/ph/tab_2.png',
      selectedImagePath: 'assets/images/ph/tab_2s.png',
      label: 'Download',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
  ];
}
