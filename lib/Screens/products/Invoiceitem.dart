import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For navigation and state management
import 'package:hive/hive.dart';
import 'package:invoicepro/models/invoiceitem.dart';

class AddInvoiceItemForm extends StatefulWidget {
  @override
  _AddInvoiceItemFormState createState() => _AddInvoiceItemFormState();
}

class _AddInvoiceItemFormState extends State<AddInvoiceItemForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _hsnCodeController;
  late Box<InvoiceItem> invoiceItemBox;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _hsnCodeController = TextEditingController();
    invoiceItemBox = Hive.box<InvoiceItem>('invoiceItems');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hsnCodeController.dispose();
    super.dispose();
  }

  Future<void> _addInvoiceItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final hsnCode = _hsnCodeController.text.trim();

      // Check for duplicate entries
      final duplicate = invoiceItemBox.values.any((item) =>
          item.name.toLowerCase() == name.toLowerCase() &&
          item.hsnCode.toLowerCase() == hsnCode.toLowerCase());

      if (duplicate) {
        Get.snackbar(
          'Error',
          'Invoice item with the same name and HSN code already exists.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        // Create a new InvoiceItem
        final newItem = InvoiceItem(name: name, hsnCode: hsnCode);

        // Add the item to the Hive box
        await invoiceItemBox.add(newItem);

        Get.snackbar(
          'Success',
          'Invoice item added successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        _nameController.clear();
        _hsnCodeController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Invoice Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _hsnCodeController,
                decoration: InputDecoration(
                  labelText: 'HSN Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the HSN code';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
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
                onPressed: _addInvoiceItem,
                child: Text('Add Invoice Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
