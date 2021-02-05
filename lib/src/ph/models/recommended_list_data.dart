class RecommendListData {
  RecommendListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String> meals;
  int kacl;

  static List<RecommendListData> tabIconsList = <RecommendListData>[
    RecommendListData(
      imagePath: 'assets/images/epidemiology.png',
      titleTxt: 'Epidemiology',
      kacl: 525,
      meals: <String>['Bread,', 'Peanut butter,', 'Apple'],
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    RecommendListData(
      imagePath: 'assets/images/Biostats.png',
      titleTxt: 'Biostatistics',
      kacl: 602,
      meals: <String>['Salmon,', 'Mixed veggies,', 'Avocado'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    RecommendListData(
      imagePath: 'assets/images/research@3x.png',
      titleTxt: 'Research Methodology',
      kacl: 0,
      meals: <String>['Recommend:', '800 kcal'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
  ];
}
