import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoppinglist/Data/categories.dart';
import 'package:shoppinglist/model/Category.dart';
import 'package:shoppinglist/model/Grocery_Item.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  @override
  State<NewItem> createState() {
    return _newItemState();
  }
}

class _newItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categoriess[Categories.vegetables];
  var _isSending = false;

  void onSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isSending = true;
    });
    // print(_enteredName);
    // print(_enteredQuantity);
    // print(_selectedCategory);
    final url = Uri.https('flutter-project-8d93c-default-rtdb.firebaseio.com',
        'shopping_list.json');
    final resp = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectedCategory!.title
        },
      ),
    );
    final respData = json.decode(resp.body);
    Navigator.of(context).pop(
      GroceryItem(
          id: respData['name'],
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: (value) {
                  _enteredName = value!;
                },
                maxLength: 50,
                decoration: InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.trim().length < 1 ||
                      value.trim() == null) {
                    return 'Name should be valid...';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                      initialValue: _enteredQuantity.toString(),
                      decoration: InputDecoration(
                        label: Text('Quantity'),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Enter vaue between 1 to 50';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: [
                          for (final category in categoriess.entries)
                            DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: category.value.color,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(category.value.title),
                                  ],
                                ))
                        ],
                        onChanged: (x) {
                          setState(() {
                            _selectedCategory = x! as Categori;
                          });
                        }),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSending
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: onSave,
                    child: _isSending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Add Item'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
