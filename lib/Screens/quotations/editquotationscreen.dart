import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoicepro/models/quotation.dart';

class EditQuotationScreen extends StatefulWidget {
  final Quotation quotation;

  EditQuotationScreen({required this.quotation});

  @override
  _EditQuotationScreenState createState() => _EditQuotationScreenState();
}

class _EditQuotationScreenState extends State<EditQuotationScreen> {
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
    _quantityController =
        TextEditingController(text: widget.quotation.quantity.toString());
    _rateController =
        TextEditingController(text: widget.quotation.rate.toString());
    _cgstController =
        TextEditingController(text: widget.quotation.cgstRate.toString());
    _sgstController =
        TextEditingController(text: widget.quotation.sgstRate.toString());
    _igstController =
        TextEditingController(text: widget.quotation.igstRate.toString());
    _quotationNumberController =
        TextEditingController(text: widget.quotation.quotationNumber);
    _termsController = TextEditingController(text: widget.quotation.terms);

    _selectedDate = widget.quotation.date;

    // Add listeners to update calculated fields
    _quantityController.addListener(_updateAmounts);
    _rateController.addListener(_updateAmounts);
    _cgstController.addListener(_updateAmounts);
    _sgstController.addListener(_updateAmounts);
    _igstController.addListener(_updateAmounts);

    // Initial calculation of amounts
    _updateAmounts();
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
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  void _updateQuotation() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        widget.quotation.quotationNumber = _quotationNumberController.text;
        widget.quotation.quantity = int.parse(_quantityController.text);
        widget.quotation.rate = double.parse(_rateController.text);
        widget.quotation.cgstRate = double.parse(_cgstController.text);
        widget.quotation.sgstRate = double.parse(_sgstController.text);
        widget.quotation.igstRate = double.parse(_igstController.text);
        widget.quotation.terms = _termsController.text;
        widget.quotation.date = _selectedDate ?? DateTime.now();

        // Recalculate amounts
        widget.quotation.taxableAmount = _taxableAmount;
        widget.quotation.cgst = _cgstAmount;
        widget.quotation.sgst = _sgstAmount;
        widget.quotation.igst = _igstAmount;
        widget.quotation.total = _totalAmount;
      });

      // Save updated quotation to Hive
      widget.quotation.save();

      Navigator.pop(context); // Return to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Quotation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                          Colors.blueGrey.shade100), // Light grey background
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.black87), // Dark grey/black text color
                      elevation: MaterialStateProperty.all<double>(
                          2.0), // Slight shadow for depth
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 28.0)), // Padding for better spacing
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    child: Text(
                      'Pick Date',
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
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
              // Terms
              TextFormField(
                controller: _termsController,
                decoration: InputDecoration(
                  labelText: 'Terms and Conditions',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 16),
              // Taxable Amount
              Text(
                'Taxable Amount: ₹ ${_taxableAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              // CGST Amount
              Text(
                'CGST: ₹ ${_cgstAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              // SGST Amount
              Text(
                'SGST: ₹ ${_sgstAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              // IGST Amount
              Text(
                'IGST: ₹ ${_igstAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              // Total Amount
              Text(
                'Total Amount: ₹ ${_totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // Submit Button
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
                onPressed: _updateQuotation,
                child: Text(
                  'Update Quotation',
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
