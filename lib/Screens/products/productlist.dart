import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invoicepro/Screens/products/editproduct.dart';
import 'package:invoicepro/models/invoiceitem.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoiceItemBox = Hive.box<InvoiceItem>('invoiceItems');

    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by name or HSN code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: invoiceItemBox.listenable(),
        builder: (context, Box<InvoiceItem> box, _) {
          final products = box.values.where((product) {
            final lowerCaseName = product.name.toLowerCase();
            final lowerCaseHsnCode = product.hsnCode.toLowerCase();

            return lowerCaseName.contains(_searchQuery) ||
                lowerCaseHsnCode.contains(_searchQuery);
          }).toList();

          if (products.isEmpty) {
            return Center(
              child: Text('No products found matching the criteria!'),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.hsnCode), // Show HSN code
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Use Get.to() for navigation
                    Get.to(EditProductScreen(product: product),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 500));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
