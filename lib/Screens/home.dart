import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:invoicepro/Screens/homescreen.dart';
import 'package:invoicepro/Screens/profile.dart';
import 'package:invoicepro/Screens/quotations.dart';
import 'package:invoicepro/models/customer.dart';
import 'package:invoicepro/models/invoice.dart';
import 'package:invoicepro/models/invoiceitem.dart';
import 'package:invoicepro/models/quotation.dart';

import 'invoices.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sampleInvoiceItems = [
      InvoiceItem(
        name: 'Sample Product',
        hsnCode: '1234', // Use a default HSN code
      ),
    ];
    final customer = Customer(
      id: 'C001',
      name: 'John Doe',
      phoneNumber: '1234567890',
      address: '123 Main Street',
      city: 'Mumbai',
      gstNumber: '27AAEPM1234C1ZQ',
    );

    final quotationItems = [
      InvoiceItem(
        name: 'Product A',
        hsnCode: '1234',
      ),
      InvoiceItem(
        name: 'Product B',
        hsnCode: '5678',
      ),
    ];

    final quotation = Quotation(
      date: DateTime.now(),
      quotationNumber: 'Q2024/001',
      quotationItems: quotationItems,
      rate: 100.0,
      quantity: 10,
      taxableAmount: 1000.0,
      cgst: 90.0,
      sgst: 90.0,
      igst: 0.0,
      total: 1180.0,
      customer: customer,
      cgstRate: 9.0,
      sgstRate: 9.0,
      igstRate: 0.0,
    );

    final sampleCustomer = Customer(
      id: 'CUST-0001',
      name: 'John Doe',
      phoneNumber: '123-456-7890',
      address: '123 Main St',
      city: 'Anytown',
      gstNumber: '27AHUPB8856A1Z4',
    );
    final invoice = Invoice(
      date: DateTime.now(),
      invoiceNumber: 'INV-0001',
      invoiceItems: sampleInvoiceItems,
      rate: 100.0,
      quantity: 1,
      taxableAmount: 100.0,
      cgstRate: 9.0, // 9% GST as an example
      sgstRate: 9.0, // 9% GST as an example
      igstRate: 0.0, // Assuming no IGST
      total: 118.0, // Total including GST
      cgst: 0,
      sgst: 0,
      igst: 0,
      customer: sampleCustomer,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "Gurukrupa Traders",
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Color(0xff000000)),
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomeScreen(),
          InvoiceListScreen(), // Invoice list screen added as a tab
          QuotationListScreen(),
          Profile(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: GNav(
            gap: 8,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            selectedIndex: _selectedIndex,
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.grey.withOpacity(0.3),
            padding: const EdgeInsets.all(15),
            tabs: const [
              GButton(icon: Icons.home, text: "Home"),
              GButton(icon: Icons.pages, text: "Invoices"),
              GButton(icon: Icons.pages_outlined, text: "Quotations"),
              GButton(icon: Icons.person, text: "Profile"),
            ],
          ),
        ),
      ),
    );
  }
}
