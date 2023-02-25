// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
   String? name;
   String? description;
   double? price;
   String? image;
   int? favorite;
   String? referenceId;
   String? id;
  Product({
    this.name,
    this.description,
    this.price,
    this.image,
    this.favorite,
    this.referenceId,
    this.id,
  });

  Product copyWith({
    String? name,
    String? description,
    double? price,
    String? image,
    int? favorite,
    String? referenceId,
    String? id,
  }) {
    return Product(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      favorite: favorite ?? this.favorite,
      referenceId: referenceId ?? this.referenceId,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'favorite': favorite,
      'referenceId': referenceId,
      'id': id,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] != null ? map['name'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      price: map['price'] != null ? map['price'] as double : null,
      image: map['image'] != null ? map['image'] as String : null,
      favorite: map['favorite'] != null ? map['favorite'] as int : null,
      referenceId: map['referenceId'] != null ? map['referenceId'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(name: $name, description: $description, price: $price, image: $image, favorite: $favorite, referenceId: $referenceId, id: $id)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.description == description &&
      other.price == price &&
      other.image == image &&
      other.favorite == favorite &&
      other.referenceId == referenceId &&
      other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      description.hashCode ^
      price.hashCode ^
      image.hashCode ^
      favorite.hashCode ^
      referenceId.hashCode ^
      id.hashCode;
  }
}


