import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:invoicepro/Screens/invoices/invoice_preview.dart';
import 'package:invoicepro/models/invoice.dart';

class EditInvoiceScreen extends StatefulWidget {
  final Invoice invoice;

  EditInvoiceScreen({required this.invoice});

  @override
  _EditInvoiceScreenState createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  late TextEditingController _quantityController;
  late TextEditingController _rateController;
  late TextEditingController _cgstController;
  late TextEditingController _sgstController;
  late TextEditingController _igstController;
  late TextEditingController _invoiceNumberController;
  DateTime? _selectedDate;

  double _taxableAmount = 0.0;
  double _cgstAmount = 0.0;
  double _sgstAmount = 0.0;
  double _igstAmount = 0.0;
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _quantityController =
        TextEditingController(text: widget.invoice.quantity.toString());
    _rateController =
        TextEditingController(text: (widget.invoice.rate).toString());
    _cgstController =
        TextEditingController(text: widget.invoice.cgstRate.toString());
    _sgstController =
        TextEditingController(text: widget.invoice.sgstRate.toString());
    _igstController =
        TextEditingController(text: widget.invoice.igstRate.toString());
    _invoiceNumberController =
        TextEditingController(text: widget.invoice.invoiceNumber);

    _selectedDate = widget.invoice.date;

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
    super.dispose();
  }

  void _updateAmounts() {
    final totalQuantity = int.tryParse(_quantityController.text) ?? 0;
    final totalRate = double.tryParse(_rateController.text) ?? 0;
    _taxableAmount = totalRate * totalQuantity;

    final cgstPercent = double.tryParse(_cgstController.text) ?? 0;
    final sgstPercent = double.tryParse(_sgstController.text) ?? 0;
    final igstPercent = double.tryParse(_igstController.text) ?? 0;

    _cgstAmount = _taxableAmount * (cgstPercent / 100);
    _sgstAmount = _taxableAmount * (sgstPercent / 100);
    _igstAmount = _taxableAmount * (igstPercent / 100);

    _totalAmount = _taxableAmount + _cgstAmount + _sgstAmount + _igstAmount;

    setState(() {}); // Update the UI
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _updateInvoice() async {
    final invoiceBox = Hive.box<Invoice>('invoices');

    final String formattedDate = _selectedDate != null
        ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
        : DateFormat('dd-MM-yyyy').format(DateTime.now());

    final updatedInvoice = Invoice(
      date: _selectedDate ?? DateTime.now(),
      invoiceNumber: _invoiceNumberController.text.isNotEmpty
          ? _invoiceNumberController.text
          : 'INV-${DateTime.now().millisecondsSinceEpoch}',
      invoiceItems: [
        widget.invoice.invoiceItems.first
      ], // Assuming a single product
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
      customer: widget.invoice.customer, // Keeping the same customer
    );

    final int index = invoiceBox.values.toList().indexWhere(
        (invoice) => invoice.invoiceNumber == widget.invoice.invoiceNumber);
    if (index != -1) {
      await invoiceBox.putAt(index, updatedInvoice);
    }

    Get.to(() => InvoicePreviewScreen(invoice: updatedInvoice));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Invoice'),
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
                  'Customer: ${widget.invoice.customer.name}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Product: ${widget.invoice.invoiceItems.first.name}',
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
                            Colors.blueGrey.shade100),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black87),
                        elevation: MaterialStateProperty.all<double>(2.0),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 28.0)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.grey.shade400),
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
                      onPressed: _updateInvoice,
                      child: Center(
                        child: Text(
                          'Update Invoice',
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
