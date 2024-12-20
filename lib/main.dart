import 'package:flutter/material.dart';

void main() {
  runApp(ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  const ShoppingListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> shoppingList = [];
  String selectedFilter = "All"; // Default filter

  final List<String> categories = [
    "All",
    "Dairy",
    "Fruits",
    "Vegetables",
    "Beverages",
    "Personal Care",
    "Others",
  ];

  final Map<String, IconData> categoryIcons = {
  "Dairy": Icons.local_grocery_store,
  "Fruits": Icons.apple_outlined,
  "Vegetables": Icons.eco,
  "Beverages": Icons.coffee,
  "Personal Care": Icons.clean_hands_outlined,
  "Others": Icons.interests,
};


  @override
  Widget build(BuildContext context) {
    // Filter shopping list based on selected category
    List<Map<String, String>> filteredList = selectedFilter == "All"
        ? shoppingList
        : shoppingList
            .where((item) => item['category'] == selectedFilter)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddItemScreen(
                    onAddItem: (item) {
                      setState(() {
                        shoppingList.add(item);
                      });
                    },
                    categories: categories.sublist(1), // Exclude "All"
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown for category filter
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
            ),
          ),
          // Display filtered shopping list
          Expanded(
            child: filteredList.isEmpty
                ? Center(child: Text('No items in this category'))
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          categoryIcons[filteredList[index]['category']] ??
                              Icons.category, // Default icon
                          color: Colors.blue,
                        ),
                        title: Text(filteredList[index]['name']!),
                        subtitle: Text(
                          'Qty: ${filteredList[index]['quantity']} - Category: ${filteredList[index]['category']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditItemScreen(
                                      item: filteredList[index],
                                      onEditItem: (updatedItem) {
                                        setState(() {
                                          int originalIndex =
                                              shoppingList.indexWhere((item) =>
                                                  item == filteredList[index]);
                                          shoppingList[originalIndex] =
                                              updatedItem;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  shoppingList.remove(filteredList[index]);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class AddItemScreen extends StatelessWidget {
  final Function(Map<String, String>) onAddItem;
  final List<String> categories;

  AddItemScreen({super.key, required this.onAddItem, required this.categories});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  String selectedCategory = "Dairy"; // Default category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: selectedCategory,
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                selectedCategory = value!;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onAddItem({
                  'name': nameController.text,
                  'quantity': quantityController.text,
                  'category': selectedCategory,
                });
                Navigator.pop(context);
              },
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditItemScreen extends StatelessWidget {
  final Map<String, String> item;
  final Function(Map<String, String>) onEditItem;

  EditItemScreen({super.key, required this.item, required this.onEditItem});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  late String selectedCategory;

  @override
  Widget build(BuildContext context) {
    nameController.text = item['name']!;
    quantityController.text = item['quantity']!;
    selectedCategory = item['category']!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: selectedCategory,
              items: [
                "Dairy",
                "Fruits",
                "Vegetables",
                "Beverages",
                "Personal Care",
                "Others"
              ].map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                selectedCategory = value!;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onEditItem({
                  'name': nameController.text,
                  'quantity': quantityController.text,
                  'category': selectedCategory,
                });
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
