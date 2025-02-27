import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_login_signin/view/all_app_color/app_color.dart';
import 'package:hive_login_signin/view/all_font_size/app_font_size.dart';
import 'package:hive_login_signin/view/screens/intro/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController productText = TextEditingController();
  final TextEditingController priceText = TextEditingController();
  final Box userBox = Hive.box('userBox');
  List<Map<String, dynamic>> myData = [];

  @override
  void initState() {
    super.initState();
    getItem();
  }

  void getItem() {
    setState(() {
      // Filter only product-related items from the box
      myData = userBox.keys
          .where((key) {
        final item = userBox.get(key);
        return item is Map && item.containsKey('product') && item.containsKey('price');
      })
          .map((key) {
        final item = userBox.get(key);
        return {
          'key': key,
          'product': item['product'],
          'price': item['price'],
        };
      })
          .toList();
    });
  }

  void addItem(Map<String, dynamic> data) async {
    await userBox.add(data);
    getItem();
    Fluttertoast.showToast(msg: 'New data added successfully');
  }

  void updateItem(dynamic key, Map<String, dynamic> data) async {
    await userBox.put(key, data);
    getItem();
    Fluttertoast.showToast(msg: 'Data updated successfully');
  }

  void deleteItem(dynamic key) async {
    await userBox.delete(key);
    getItem();
    Fluttertoast.showToast(msg: 'Item deleted successfully');
  }

  void logOutUser(BuildContext context) {
    userBox.put('isLoggedIn', false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void controllerClear() {
    productText.clear();
    priceText.clear();
  }

  void bottomSheet({dynamic key}) {
    final isEditing = key != null;

    if (isEditing) {
      final item = userBox.get(key);
      productText.text = item['product'] ?? '';
      priceText.text = item['price'] ?? '';
    }

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 50.0,left: 20,right: 20,top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: productText,
                  decoration: InputDecoration(
                      labelText: isEditing ? 'Update Product' : 'Enter Product',
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceText,
                  decoration: InputDecoration(
                      labelText: isEditing ? 'Update Price' : 'Enter Price',
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: () {
                      final data = {
                        'product': productText.text,
                        'price': priceText.text,
                      };
                      if (isEditing) {
                        updateItem(key, data);
                      } else {
                        addItem(data);
                      }
                      Navigator.pop(context);
                      controllerClear();
                    },
                    child: Text(isEditing ? 'Update' : 'Save')),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hive',
          style: TextStyle(
              fontSize: AllAppTextSize.appbarTextSize,
              color: AllAppColor.appbarColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Log Out'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            logOutUser(context);
                            Fluttertoast.showToast(
                                msg: 'Logged out successfully');
                          },
                          child: const Text('OK')),
                    ],
                  );
                },
              ),
              icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.blueAccent),
        onPressed: () => bottomSheet(),
      ),
      body: ListView.builder(
          itemCount: myData.length,
          itemBuilder: (context, index) {
            final item = myData[index];
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(item['product']),
                  subtitle: Text(item['price']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () => bottomSheet(key: item['key']),
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () => deleteItem(item['key']),
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
