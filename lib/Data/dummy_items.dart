import 'package:shoppinglist/Data/categories.dart';
import 'package:shoppinglist/model/Category.dart';
import 'package:shoppinglist/model/Grocery_Item.dart';

final groceryItems = [
  GroceryItem(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: categoriess[Categories.dairy]!),
  GroceryItem(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: categoriess[Categories.fruit]!),
  GroceryItem(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: categoriess[Categories.meat]!),
];
