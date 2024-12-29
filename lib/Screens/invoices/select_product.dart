import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invoicepro/Screens/quotations/quotation_input.dart';
import 'package:invoicepro/models/customer.dart';
import 'package:invoicepro/models/invoiceitem.dart';

import 'invoice.dart';

// Import the screen for final invoice creation

class SelectProduct extends StatefulWidget {
  final Customer customer;
  final int choice;

  SelectProduct({required this.choice, required this.customer});

  @override
  _SelectProductState createState() => _SelectProductState();
}

class _SelectProductState extends State<SelectProduct> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_updateSearchQuery);
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
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
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
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  if (widget.choice == 1) {
                    Get.to(
                        () => CreateInvoiceScreen(
                            customer: widget.customer, product: product),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 500));
                  }

                  // Navigate to the Invoice screen and pass the selected customer and product
                  else if (widget.choice == 2) {
                    Get.to(
                        () => CreateQuotationScreen(
                            customer: widget.customer, product: product),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 500));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
