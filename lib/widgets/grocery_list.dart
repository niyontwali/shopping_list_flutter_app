import 'package:flutter/material.dart';
import 'package:shopping_records_app/models/grocery_item.dart';
import 'package:shopping_records_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];
  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeGrocery(GroceryItem grocery) {
    setState(() {
      _groceryItems.remove(grocery);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget empty = Center(
      child: Text(
        'There are no shopping list items now!',
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );

    final Widget listItems = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(_groceryItems[index].id),
            onDismissed: (direction) {
              _removeGrocery(_groceryItems[index]);
            },
            child: ListTile(
              title: Text(
                _groceryItems[index].name,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              leading: Container(
                height: 16,
                width: 16,
                color: _groceryItems[index].category.color,
              ),
              trailing: Text(
                _groceryItems[index].quantity.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          );
        });

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: _groceryItems.isEmpty ? empty : listItems,
    );
  }
}
