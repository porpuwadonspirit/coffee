// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ReportModel {
    String? id;
    String? date;
    List<ItemsProduct?>? items;
  ReportModel({
    this.id,
    this.date,
    this.items,
  });
  

  ReportModel copyWith({
    String? id,
    String? date,
    List<ItemsProduct?>? items,
  }) {
    return ReportModel(
      id: id ?? this.id,
      date: date ?? this.date,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'items': items?.map((x) => x?.toMap()).toList(),
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] != null ? map['id'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      items: map['items'] != null ? List<ItemsProduct?>.from((map['items'] as List<int>).map<ItemsProduct?>((x) => ItemsProduct?.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportModel.fromJson(String source) => ReportModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ReportModel(id: $id, date: $date, items: $items)';

  @override
  bool operator ==(covariant ReportModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.date == date &&
      listEquals(other.items, items);
  }

  @override
  int get hashCode => id.hashCode ^ date.hashCode ^ items.hashCode;
}




class ItemsProduct {
    int? qty;
    String? name;
    double? price;
    String? id;
  ItemsProduct({
    this.qty,
    this.name,
    this.price,
    this.id,
  });

  ItemsProduct copyWith({
    int? qty,
    String? name,
    double? price,
    String? id,
  }) {
    return ItemsProduct(
      qty: qty ?? this.qty,
      name: name ?? this.name,
      price: price ?? this.price,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'qty': qty,
      'name': name,
      'price': price,
      'id': id,
    };
  }

  factory ItemsProduct.fromMap(Map<String, dynamic> map) {
    return ItemsProduct(
      qty: map['qty'] != null ? map['qty'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null ? map['price'] as double : null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemsProduct.fromJson(String source) => ItemsProduct.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemsProduct(qty: $qty, name: $name, price: $price, id: $id)';
  }

  @override
  bool operator ==(covariant ItemsProduct other) {
    if (identical(this, other)) return true;
  
    return 
      other.qty == qty &&
      other.name == name &&
      other.price == price &&
      other.id == id;
  }

  @override
  int get hashCode {
    return qty.hashCode ^
      name.hashCode ^
      price.hashCode ^
      id.hashCode;
  }
}
