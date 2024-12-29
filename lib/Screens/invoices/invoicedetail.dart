import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoicepro/Screens/invoices/editinvoice.dart';
import 'package:invoicepro/Screens/invoices/invoice_preview.dart';
import 'package:invoicepro/models/invoice.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final Invoice invoice;

  InvoiceDetailScreen({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Invoice Number and Date
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Invoice Number:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          invoice.invoiceNumber,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Date:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          DateFormat('dd-MM-yyyy').format(invoice.date),
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Customer Details
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Name:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          invoice.customer.name,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Phone Number:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          invoice.customer.phoneNumber,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Address:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          invoice.customer.address,
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'City:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          invoice.customer.city,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'GST Number:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          invoice.customer.gstNumber,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Product Details
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Product:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          invoice.invoiceItems.isNotEmpty
                              ? invoice.invoiceItems[0].name
                              : 'N/A',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Quantity:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          invoice.quantity.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Rate:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          '₹${invoice.rate.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Tax Details
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tax Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Taxable Amount:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          '₹${invoice.taxableAmount.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'CGST (${invoice.cgstRate.toStringAsFixed(2)}%):',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          '₹${invoice.cgst.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'SGST (${invoice.sgstRate.toStringAsFixed(2)}%):',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          '₹${invoice.sgst.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'IGST (${invoice.igstRate.toStringAsFixed(2)}%):',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          '₹${invoice.igst.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Total Amount
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Total Amount:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          '₹${invoice.total.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
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
                  Get.to(InvoicePreviewScreen(invoice: invoice));
                },
                child: Text(
                  "Preview",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 15,
            ),
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
                  Get.to(EditInvoiceScreen(invoice: invoice));
                },
                child: Text(
                  "Update",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}
