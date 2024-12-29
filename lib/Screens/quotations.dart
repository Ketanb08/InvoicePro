import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invoicepro/Screens/quotations/editquotationscreen.dart';
import 'package:invoicepro/models/quotation.dart';

class QuotationListScreen extends StatefulWidget {
  @override
  _QuotationListScreenState createState() => _QuotationListScreenState();
}

class _QuotationListScreenState extends State<QuotationListScreen> {
  final List<int> _selectedQuotations =
      []; // List to store selected quotation indices
  bool _selectionMode = false; // Flag to check if selection mode is enabled

  void _toggleSelectionMode(int index) {
    setState(() {
      if (_selectedQuotations.contains(index)) {
        _selectedQuotations.remove(index);
      } else {
        _selectedQuotations.add(index);
      }

      if (_selectedQuotations.isEmpty) {
        _selectionMode = false;
      }
    });
  }

  void _enableSelectionMode() {
    setState(() {
      _selectionMode = true;
    });
  }

  Future<void> _showDeleteConfirmationDialog(Box<Quotation> box) async {
    final bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Confirmation'),
        content:
            Text('Are you sure you want to delete the selected quotations?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF00395d)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: Color(0xFF00395d))),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _deleteSelectedQuotations(box);
    }
  }

  void _deleteSelectedQuotations(Box<Quotation> box) {
    setState(() {
      _selectedQuotations
          .sort((a, b) => b.compareTo(a)); // Sort indices in descending order
      for (var index in _selectedQuotations) {
        box.deleteAt(index); // Delete quotations at selected indices
      }
      _selectedQuotations.clear(); // Clear the selection
      _selectionMode = false; // Exit selection mode
    });
  }

  @override
  Widget build(BuildContext context) {
    final quotationBox = Hive.box<Quotation>('quotations');

    return Scaffold(
      appBar: AppBar(
        title: Text('Quotation List'),
        actions: _selectionMode
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmationDialog(quotationBox),
                ),
              ]
            : null,
      ),
      body: ValueListenableBuilder(
        valueListenable: quotationBox.listenable(),
        builder: (context, Box<Quotation> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('No quotations found!'),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final quotation = box.getAt(index)!;
              final isSelected = _selectedQuotations.contains(index);

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
                    Get.to(EditQuotationScreen(quotation: quotation));
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
                            ),
                          ),
                    title: Text(quotation.customer.name),
                    subtitle: Text(quotation.quotationItems
                        .map((item) => item.name)
                        .join(", ")),
                    trailing: Text(
                      '₹${quotation.total.toStringAsFixed(2)}',
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
