import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../models/customer.dart';

class AddCustomers extends StatefulWidget {
  @override
  _AddCustomersState createState() => _AddCustomersState();
}

class _AddCustomersState extends State<AddCustomers> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();

  Future<void> _saveCustomer() async {
    if (_formKey.currentState!.validate()) {
      final customerBox = Hive.box<Customer>('customers');

      // Retrieve the input values
      final name = _nameController.text;
      final gstNumber = _gstNumberController.text;

      // Check if a customer with the same name or GST number already exists
      bool exists =
          customerBox.values.any((customer) => customer.gstNumber == gstNumber);

      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Customer with the GST number already exists'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Create a new Customer object
      final customer = Customer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        phoneNumber: _phoneNumberController.text,
        address: _addressController.text,
        city: _cityController.text,
        gstNumber: gstNumber,
      );

      // Save the customer object to Hive
      await customerBox.add(customer);
      Get.back();
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer added successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      // Clear the form
      _formKey.currentState!.reset();
      _nameController.clear();
      _phoneNumberController.clear();
      _addressController.clear();
      _cityController.clear();
      _gstNumberController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the customer\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _gstNumberController,
                decoration: InputDecoration(labelText: 'GST Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the GST number';
                  }
                  if (!RegExp(
                          r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid GST number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                    side: const MaterialStatePropertyAll(
                        BorderSide(color: Colors.grey)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    fixedSize: MaterialStatePropertyAll(
                        Size.fromWidth(context.width * 0.9)),
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 20),
                    ),
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xFF00395d))),
                onPressed: _saveCustomer,
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
