import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:invoicepro/Screens/quotations/quotation.dart';
import 'package:invoicepro/models/customer.dart';
import 'package:invoicepro/models/invoiceitem.dart';
import 'package:invoicepro/models/quotation.dart';

class CreateQuotationScreen extends StatefulWidget {
  final Customer customer;
  final InvoiceItem product;

  CreateQuotationScreen({required this.customer, required this.product});

  @override
  _CreateQuotationScreenState createState() => _CreateQuotationScreenState();
}

class _CreateQuotationScreenState extends State<CreateQuotationScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _quantityController;
  late TextEditingController _rateController;
  late TextEditingController _cgstController;
  late TextEditingController _sgstController;
  late TextEditingController _igstController;
  late TextEditingController _quotationNumberController;
  late TextEditingController _termsController;
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
    _quotationNumberController = TextEditingController();
    _termsController = TextEditingController();

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
    _quotationNumberController.dispose();
    _termsController.dispose();

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
    setState(() {});
  }

  Future<Quotation> _saveQuotation() async {
    if (_formKey.currentState!.validate()) {
      final quotationBox = Hive.box<Quotation>('quotations');

      final String formattedDate = _selectedDate != null
          ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
          : DateFormat('dd-MM-yyyy').format(DateTime.now());

      final quotation = Quotation(
        date: _selectedDate ?? DateTime.now(),
        quotationNumber: _quotationNumberController.text.isNotEmpty
            ? _quotationNumberController.text
            : 'QUO-${DateTime.now().millisecondsSinceEpoch}',
        quotationItems: [widget.product],
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
        terms: _termsController.text.toString(),
        customer: widget.customer, // Assign the selected customer
      );

      await quotationBox.add(quotation);
      Get.to(() => QuotationPreviewScreen(quotation: quotation));

      return quotation;
    } else {
      // Handle the case when the form is not valid
      return Future.error('Form is not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quotation'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
                  // Quotation Number
                  TextFormField(
                    controller: _quotationNumberController,
                    decoration: InputDecoration(
                      labelText: 'Quotation Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a quotation number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Quotation Date
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Select Quotation Date'
                              : 'Date: ${DateFormat('dd-MM-yyyy').format(_selectedDate!)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors
                                  .blueGrey.shade100), // Light grey background
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
                              borderRadius: BorderRadius.circular(
                                  10.0), // Rounded corners
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
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a quantity';
                      }
                      final intValue = int.tryParse(value);
                      if (intValue == null || intValue <= 0) {
                        return 'Please enter a valid quantity';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Rate
                  TextFormField(
                    controller: _rateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Rate',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a rate';
                      }
                      final doubleValue = double.tryParse(value);
                      if (doubleValue == null || doubleValue <= 0) {
                        return 'Please enter a valid rate';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // CGST
                  TextFormField(
                    controller: _cgstController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'CGST (%)',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter CGST percentage';
                      }
                      final doubleValue = double.tryParse(value);
                      if (doubleValue == null || doubleValue < 0) {
                        return 'Please enter a valid CGST percentage';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // SGST
                  TextFormField(
                    controller: _sgstController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'SGST (%)',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter SGST percentage';
                      }
                      final doubleValue = double.tryParse(value);
                      if (doubleValue == null || doubleValue < 0) {
                        return 'Please enter a valid SGST percentage';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // IGST
                  TextFormField(
                    controller: _igstController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'IGST (%)',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter IGST percentage';
                      }
                      final doubleValue = double.tryParse(value);
                      if (doubleValue == null || doubleValue < 0) {
                        return 'Please enter a valid IGST percentage';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Terms and Conditions
                  TextFormField(
                    controller: _termsController,
                    decoration: InputDecoration(
                      labelText: 'Terms and Conditions',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Display calculated amounts
                  Text('Taxable Amount: $_taxableAmount'),
                  Text('CGST: $_cgstAmount'),
                  Text('SGST: $_sgstAmount'),
                  Text('IGST: $_igstAmount'),
                  Text('Total Amount: $_totalAmount'),
                  SizedBox(height: 16),
                  // Save button
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
                    onPressed: () {
                      _saveQuotation().then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Quotation saved successfully')),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to save quotation')),
                        );
                      });
                    },
                    child: Text(
                      'Save Quotation',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
