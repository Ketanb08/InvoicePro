import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:invoicepro/Screens/invoices/invoice_preview.dart';
import 'package:invoicepro/models/customer.dart';
import 'package:invoicepro/models/invoice.dart';
import 'package:invoicepro/models/invoiceitem.dart';

class CreateInvoiceScreen extends StatefulWidget {
  final Customer customer;
  final InvoiceItem product;

  CreateInvoiceScreen({required this.customer, required this.product});

  @override
  _CreateInvoiceScreenState createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  late TextEditingController _quantityController;
  late TextEditingController _rateController;
  late TextEditingController _cgstController;
  late TextEditingController _sgstController;
  late TextEditingController _igstController;
  late TextEditingController _invoiceNumberController;
  late TextEditingController _vehicleNumberController;
  DateTime? _selectedDate;

  double _taxableAmount = 0.0;
  double _cgstAmount = 0.0;
  double _sgstAmount = 0.0;
  double _igstAmount = 0.0;
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _rateController = TextEditingController();
    _cgstController = TextEditingController();
    _sgstController = TextEditingController();
    _igstController = TextEditingController();
    _invoiceNumberController = TextEditingController();
    _vehicleNumberController = TextEditingController(text: "MH42-T-0943");

    // Add listeners to update calculated fields
    _quantityController.addListener(_updateAmounts);
    _rateController.addListener(_updateAmounts);
    _cgstController.addListener(_updateAmounts);
    _sgstController.addListener(_updateAmounts);
    _igstController.addListener(_updateAmounts);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _rateController.dispose();
    _cgstController.dispose();
    _sgstController.dispose();
    _igstController.dispose();
    _invoiceNumberController.dispose();
    _vehicleNumberController.dispose();
    super.dispose();
  }

  void _updateAmounts() {
    final totalQuantity = int.tryParse(_quantityController.text) ?? 0;
    final totalRate = double.tryParse(_rateController.text) ?? 0;
    _taxableAmount = totalRate * totalQuantity;

    final cgstPercent = double.tryParse(_cgstController.text) ?? 0;
    final sgstPercent = double.tryParse(_sgstController.text) ?? 0;
    final igstPercent = double.tryParse(_igstController.text) ?? 0;

    _cgstAmount = _roundToTwo(_taxableAmount * (cgstPercent / 100));
    _sgstAmount = _roundToTwo(_taxableAmount * (sgstPercent / 100));
    _igstAmount = _roundToTwo(_taxableAmount * (igstPercent / 100));

    // Calculate total amount and round to the nearest integer
    _totalAmount =
        (_taxableAmount + _cgstAmount + _sgstAmount + _igstAmount).round() +
            0.00;

    setState(() {}); // Update the UI
  }

  double _roundToTwo(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<Invoice> _saveInvoice() async {
    final invoiceBox = Hive.box<Invoice>('invoices');

    final String formattedDate = _selectedDate != null
        ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
        : DateFormat('dd-MM-yyyy').format(DateTime.now());

    final invoice = Invoice(
        date: _selectedDate ?? DateTime.now(),
        invoiceNumber: _invoiceNumberController.text.isNotEmpty
            ? _invoiceNumberController.text
            : 'INV-${DateTime.now().millisecondsSinceEpoch}',
        invoiceItems: [widget.product],
        rate: _taxableAmount /
            (_quantityController.text.isNotEmpty
                ? int.parse(_quantityController.text)
                : 1),
        quantity: int.tryParse(_quantityController.text) ?? 0,
        taxableAmount: _taxableAmount,
        cgstRate: double.tryParse(_cgstController.text) ?? 0,
        sgstRate: double.tryParse(_sgstController.text) ?? 0,
        igstRate: double.tryParse(_igstController.text) ?? 0,
        cgst: _cgstAmount,
        sgst: _sgstAmount,
        igst: _igstAmount,
        total: _totalAmount,
        customer: widget.customer,
        vehicleNumber: _vehicleNumberController.text.isNotEmpty
            ? _vehicleNumberController.text
            : 'MH42-T-0943' // Assign the selected customer
        );

    await invoiceBox.add(invoice);
    Get.to(() => InvoicePreviewScreen(invoice: invoice));

    return invoice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Invoice'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display selected customer and product details
                Text(
                  'Customer: ${widget.customer.name}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Product: ${widget.product.name}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                // Invoice Number
                TextField(
                  controller: _invoiceNumberController,
                  decoration: InputDecoration(
                    labelText: 'Invoice Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 16),
                // Invoice Date
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'Select Invoice Date'
                            : 'Date: ${DateFormat('dd-MM-yyyy').format(_selectedDate!)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blueGrey.shade100), // Light grey background
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black87), // Dark grey/black text color
                        elevation: MaterialStateProperty.all<double>(
                            2.0), // Slight shadow for depth
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal:
                                    28.0)), // Padding for better spacing
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Rounded corners
                            side: BorderSide(
                                color: Colors
                                    .grey.shade400), // Border with grey color
                          ),
                        ),
                      ),
                      onPressed: () => _selectDate(context),
                      child: Text('Pick Date'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Quantity
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 16),
                // Rate
                TextField(
                  controller: _rateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Rate',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 16),
                // CGST
                TextField(
                  controller: _cgstController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'CGST (%)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 16),
                // SGST
                TextField(
                  controller: _sgstController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'SGST (%)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 16),
                // IGST
                TextField(
                  controller: _igstController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'IGST (%)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _vehicleNumberController,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 16),
                // Read-only Fields
                Text(
                  'Taxable Amount: ₹${_taxableAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'CGST: ₹${_cgstAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'SGST: ₹${_sgstAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'IGST: ₹${_igstAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Total Amount: ₹${_totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: Get.width * 0.9,
                    height: Get.height * 0.07,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          side: const MaterialStatePropertyAll(
                              BorderSide(color: Colors.grey)),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          fixedSize: MaterialStatePropertyAll(
                              Size.fromWidth(context.width * 0.9)),
                          padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 20),
                          ),
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xFF00395d))),
                      onPressed: _saveInvoice,
                      child: Center(
                        child: Text(
                          'Save Invoice',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
