import 'package:flutter/foundation.dart';
import 'package:shoppinglist/model/Category.dart';

class GroceryItem {
  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  final String id;
  final String name;
  final int quantity;
  final Categori category;
}
