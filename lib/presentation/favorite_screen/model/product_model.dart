class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String thumbnail;
  final List<String> images;
  final String availabilityStatus;
  final String shippingInformation;
  final String returnPolicy;
  final String warrantyInformation;
  final List<ReviewModel> reviews;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.thumbnail,
    required this.images,
    required this.availabilityStatus,
    required this.shippingInformation,
    required this.returnPolicy,
    required this.warrantyInformation,
    required this.reviews,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    category: json['category'] as String,
    price: (json['price'] as num).toDouble(),
    discountPercentage: (json['discountPercentage'] as num).toDouble(),
    rating: (json['rating'] as num).toDouble(),
    stock: json['stock'] as int,
    brand: json['brand'] as String? ?? '',
    thumbnail: json['thumbnail'] as String,
    images: List<String>.from(json['images'] as List),
    availabilityStatus: json['availabilityStatus'] as String,
    shippingInformation: json['shippingInformation'] as String,
    returnPolicy: json['returnPolicy'] as String,
    warrantyInformation: json['warrantyInformation'] as String,
    reviews: (json['reviews'] as List)
        .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  double get discountedPrice => price * (1 - discountPercentage / 100);
}

class ReviewModel {
  final int rating;
  final String comment;
  final String reviewerName;
  final String date;

  const ReviewModel({
    required this.rating,
    required this.comment,
    required this.reviewerName,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    rating: json['rating'] as int,
    comment: json['comment'] as String,
    reviewerName: json['reviewerName'] as String,
    date: json['date'] as String,
  );
}
