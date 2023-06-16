import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoppinglist/Data/categories.dart';

import 'package:shoppinglist/model/Grocery_Item.dart';
import 'package:shoppinglist/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() {
    // TODO: implement createState
    return _groceryListState();
  }
}

class _groceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https('flutter-project-8d93c-default-rtdb.firebaseio.com',
        'shopping_list.json');
    final response = await http.get(url);

    final Map<String, dynamic> data = json.decode(response.body);
    if (data == null) {
      setState(() {
        _isLoading = false;
      });
    }
    List<GroceryItem> _fireBaseGroceryItems = [];

    for (final item in data.entries) {
      final category = categoriess.entries
          .firstWhere((cat) => cat.value.title == item.value['category'])
          .value;

      _fireBaseGroceryItems.add(
        GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category),
      );
    }
    setState(() {
      _groceryItems = _fireBaseGroceryItems;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final getData = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => NewItem(),
      ),
    );

    if (getData == null) {
      return;
    }
    setState(() {
      _groceryItems.add(getData!);
    });
  }

  void _onDelete(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item Deleted'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text('No items found, Please try adding new items!!!'),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) => Dismissible(
          key: ValueKey(_groceryItems[index]),
          onDismissed: (direction) {
            _onDelete(_groceryItems[index]);
          },
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
