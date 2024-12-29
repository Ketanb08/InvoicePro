import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invoicepro/Screens/customers/addcustomers.dart';
import 'package:invoicepro/Screens/invoices/select_product.dart';
import 'package:invoicepro/models/customer.dart';

class SelectCustomer extends StatefulWidget {
  final int choice;

  SelectCustomer({required this.choice});
  @override
  _SelectCustomerState createState() => _SelectCustomerState();
}

class _SelectCustomerState extends State<SelectCustomer> {
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
    final customerBox = Hive.box<Customer>('customers');

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
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

              return ListTile(
                title: Text(customer.name),
                subtitle: Text(customer.gstNumber), // Show GST number
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  // Navigate to the ProductList screen and pass the selected customer
                  Get.to(
                      () => SelectProduct(
                          choice: widget.choice, customer: customer),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 500));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
            bottom: 50.0), // Adjust this value to move the button up
        child: FloatingActionButton(
          backgroundColor:
              Colors.grey.shade600, // Set a professional color for the button
          onPressed: () {
            Get.to(AddCustomers());
          },
          child: Icon(
            Icons.add,
            color: Colors.white, // Ensure the '+' icon is visible
            size: 32.0, // Increase icon size if needed
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endDocked, // Adjust location if needed
    );
  }
}
