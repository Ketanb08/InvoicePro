import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invoicepro/Screens/invoices/invoicedetail.dart';
import 'package:invoicepro/models/invoice.dart';

class InvoiceListScreen extends StatefulWidget {
  @override
  _InvoiceListScreenState createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  final List<int> _selectedInvoices =
      []; // List to store selected invoice indices
  bool _selectionMode = false; // Flag to check if selection mode is enabled

  void _toggleSelectionMode(int index) {
    setState(() {
      if (_selectedInvoices.contains(index)) {
        _selectedInvoices.remove(index);
      } else {
        _selectedInvoices.add(index);
      }

      if (_selectedInvoices.isEmpty) {
        _selectionMode = false;
      }
    });
  }

  void _enableSelectionMode() {
    setState(() {
      _selectionMode = true;
    });
  }

  Future<void> _showDeleteConfirmationDialog(Box<Invoice> box) async {
    final bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Confirmation'),
        content: Text('Are you sure you want to delete the selected invoices?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: Color(0xFF00395d))),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: Color(0xFF00395d))),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _deleteSelectedInvoices(box);
    }
  }

  void _deleteSelectedInvoices(Box<Invoice> box) {
    setState(() {
      _selectedInvoices
          .sort((a, b) => b.compareTo(a)); // Sort indices in descending order
      for (var index in _selectedInvoices) {
        box.deleteAt(index); // Delete invoices at selected indices
      }
      _selectedInvoices.clear(); // Clear the selection
      _selectionMode = false; // Exit selection mode
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoiceBox = Hive.box<Invoice>('invoices');

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice List'),
        actions: _selectionMode
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmationDialog(invoiceBox),
                ),
              ]
            : null,
      ),
      body: ValueListenableBuilder(
        valueListenable: invoiceBox.listenable(),
        builder: (context, Box<Invoice> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('No invoices found!'),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final invoice = box.getAt(index)!;
              final isSelected = _selectedInvoices.contains(index);

              return GestureDetector(
                onLongPress: () {
                  _enableSelectionMode();
                  _toggleSelectionMode(index);
                },
                onTap: () {
                  if (_selectionMode) {
                    _toggleSelectionMode(index);
                  } else {
                    // Navigate to EditQuotationScreen
                    Get.to(InvoiceDetailScreen(invoice: invoice));
                  }
                },
                child: Container(
                  color: isSelected
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.transparent,
                  child: ListTile(
                    leading: _selectionMode
                        ? Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              _toggleSelectionMode(index);
                            },
                          )
                        : CircleAvatar(
                            backgroundColor: Color(0xffe1e8e8),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(color: Colors.black),
                            ), // Serial number
                          ),
                    title: Text(invoice.customer.name),
                    subtitle: Text(invoice.invoiceItems
                        .map((item) => item.name)
                        .join(", ")),
                    trailing: Text(
                      '₹${invoice.total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
