import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../models/customer.dart';

class EditCustomerScreen extends StatefulWidget {
  final Customer customer;

  EditCustomerScreen({required this.customer});

  @override
  _EditCustomerScreenState createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _gstNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _phoneNumberController =
        TextEditingController(text: widget.customer.phoneNumber);
    _addressController = TextEditingController(text: widget.customer.address);
    _cityController = TextEditingController(text: widget.customer.city);
    _gstNumberController =
        TextEditingController(text: widget.customer.gstNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _gstNumberController.dispose();
    super.dispose();
  }

  Future<void> _updateCustomer() async {
    if (_formKey.currentState!.validate()) {
      final customerBox = Hive.box<Customer>('customers');

      // Update the customer details
      final updatedCustomer = Customer(
        id: widget.customer.id, // Retain the same ID
        name: _nameController.text,
        phoneNumber: _phoneNumberController.text,
        address: _addressController.text,
        city: _cityController.text,
        gstNumber: _gstNumberController.text,
      );

      // Replace the old customer with the updated one
      await customerBox.putAt(
        customerBox.values.toList().indexOf(widget.customer),
        updatedCustomer,
      );

      Get.back(); // Close the edit screen using GetX
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
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
                onPressed: _updateCustomer,
                child: Text(
                  'Update',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
