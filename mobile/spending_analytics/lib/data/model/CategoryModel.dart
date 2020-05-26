class CategoryModel {

  int categoryId;
  String categoryName;
  String categoryType;
  String categoryIcon;
  bool isFavorite;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['id'];
    categoryName = json['category_name'];
    categoryType = json['category_type'];
    categoryIcon = json['category_icon'];
    isFavorite = false;
  }

  Map<String, dynamic> toJson() => {
    'id': categoryId,
    'category_type': categoryType,
    'category_name': categoryName,
    'category_icon': categoryIcon,
  };
}
