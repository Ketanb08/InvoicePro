import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/customer.dart';
import 'editcustomer.dart'; // Import the screen for editing customer details

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
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
    print("Search Query Updated: ${_searchController.text}");
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final customerBox = Hive.box<Customer>('customers');

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
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
                hintText: 'Search by name, phone, or GST number',
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
        valueListenable: customerBox.listenable(),
        builder: (context, Box<Customer> box, _) {
          final customers = box.values.where((customer) {
            final lowerCaseName = customer.name.toLowerCase();
            final lowerCasePhone = customer.phoneNumber.toLowerCase();
            final lowerCaseGst = customer.gstNumber.toLowerCase();

            return lowerCaseName.contains(_searchQuery) ||
                lowerCasePhone.contains(_searchQuery) ||
                lowerCaseGst.contains(_searchQuery);
          }).toList();

          if (customers.isEmpty) {
            return Center(
              child: Text('No customers found matching the criteria!'),
            );
          }

          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];

              return GestureDetector(
                onTap: () {
                  // Navigate to the EditCustomerScreen
                  Get.to(
                    () => EditCustomerScreen(customer: customer),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: 500),
                  );
                },
                child: ListTile(
                  title: Text(customer.name),
                  subtitle: Text(customer.gstNumber), // Show GST number
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to the EditCustomerScreen
                      Get.to(
                        () => EditCustomerScreen(customer: customer),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 500),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
