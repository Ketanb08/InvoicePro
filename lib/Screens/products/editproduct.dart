import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../models/invoiceitem.dart';

class EditProductScreen extends StatefulWidget {
  final InvoiceItem product;

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _hsnCodeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _hsnCodeController = TextEditingController(text: widget.product.hsnCode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hsnCodeController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    final invoiceItemBox = Hive.box<InvoiceItem>('invoiceItems');

    final updatedProduct = widget.product
      ..name = _nameController.text.trim()
      ..hsnCode = _hsnCodeController.text.trim();

    await invoiceItemBox.put(widget.product.key, updatedProduct);

    Get.back(); // Go back to the previous screen
    Get.snackbar('Success', 'Product updated successfully!',
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _hsnCodeController,
              decoration: InputDecoration(labelText: 'HSN Code'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProduct,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
