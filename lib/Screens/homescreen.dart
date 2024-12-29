import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:invoicepro/Screens/customers/addcustomers.dart';
import 'package:invoicepro/Screens/customers/customerlist.dart';
import 'package:invoicepro/Screens/invoiceorquotation.dart';
import 'package:invoicepro/Screens/products/Invoiceitem.dart';
import 'package:invoicepro/Screens/products/productlist.dart';
import 'package:invoicepro/models/invoice.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final invoiceBox = Hive.box<Invoice>('invoices');
    final today = DateTime.now();
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    final formattedToday = DateFormat('dd-MM-yyyy').format(today);
    final filteredInvoices = invoiceBox.values.where((invoice) {
      return invoice.date.isAfter(today);
    }).toList();
    final deliveredInvoices = invoiceBox.values.where((invoice) {
      return invoice.date.isBefore(yesterday);
    }).toList();
    final todaysInvoices = invoiceBox.values.where((invoice) {
      final formattedInvoiceDate =
          DateFormat('dd-MM-yyyy').format(invoice.date);
      return formattedInvoiceDate == formattedToday;
    }).toList();
    filteredInvoices.sort((a, b) => a.date.compareTo(b.date));

    return ListView(
      children: [
        Container(
          color: Colors.white10,
          child: Column(
            children: [
              SizedBox(height: 15),
              // Existing sections here...
              // Design Section
              // _buildDesignSection(context),
              // SizedBox(height: context.height * 0.03),
              // Customers Section
              _buildCustomerSection(context),
              SizedBox(height: context.height * 0.03),
              // Products Section
              _buildProductSection(context),
              SizedBox(height: context.height * 0.03),
              _buildTodaysOrdersSection(context, todaysInvoices),
              SizedBox(height: context.height * 0.03),
              _buildUpcomingOrdersSection(context, filteredInvoices),
              SizedBox(height: context.height * 0.03),
              _buildDeliveredOrdersSection(context, deliveredInvoices),
              SizedBox(height: context.height * 0.03),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesignSection(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: context.width * 0.9,
              height: context.height * 0.3,
              decoration: BoxDecoration(
                color: Color(0xFF00aeef),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  // Get.to(QuotationPreviewScreen(quotation: quotation));
                },
                child: Text("Design"),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerSection(BuildContext context) {
    return Container(
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: context.width * 0.9,
          height: context.height * 0.25,
          decoration: BoxDecoration(
            color: Color(0xff94acb7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Text("Customers",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: Colors.black)),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _buildCustomerAction(
                      icon: Icons.add_circle,
                      label: "Add Customers",
                      onPressed: () {
                        Get.to(AddCustomers());
                      },
                    ),
                    SizedBox(width: 15),
                    _buildCustomerAction(
                      icon: Icons.pages_outlined,
                      label: "New Invoice/Quotation",
                      onPressed: () {
                        Get.to(IORQ());
                      },
                    ),
                    SizedBox(width: 15),
                    _buildCustomerAction(
                      icon: Icons.pages_outlined,
                      label: "View Customers",
                      onPressed: () {
                        Get.to(CustomerList());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductSection(BuildContext context) {
    return Container(
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: context.width * 0.9,
          height: context.height * 0.25,
          decoration: BoxDecoration(
            color: Color(0xff94acb7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Text("Products",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: Color(0xff000000))),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _buildProductAction(
                      icon: Icons.add_circle,
                      label: "Add Products",
                      onPressed: () {
                        Get.to(AddInvoiceItemForm());
                      },
                    ),
                    SizedBox(width: 15),
                    _buildProductAction(
                      icon: Icons.pages_outlined,
                      label: "View Products",
                      onPressed: () {
                        Get.to(ProductList());
                      },
                    ),
                    SizedBox(width: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingOrdersSection(
      BuildContext context, List<Invoice> filteredInvoices) {
    return Container(
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: context.width * 0.9,
          decoration: BoxDecoration(
            color: Color(0xff94acb7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Text("Upcoming Orders",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: Color(0xff000000))),
              ),
              SizedBox(height: 10),
              filteredInvoices.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text('No upcoming orders found!'),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredInvoices.length,
                      itemBuilder: (context, index) {
                        final invoice = filteredInvoices[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xffe1e8e8),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          title: Text(invoice.customer.name),
                          subtitle: Text(DateFormat.yMMMd()
                              .format(invoice.date)), // Display due date
                          trailing: Text(
                            '${invoice.customer.city.toString()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysOrdersSection(
      BuildContext context, List<Invoice> todaysInvoices) {
    return Container(
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: context.width * 0.9,
          decoration: BoxDecoration(
            color: Color(0xff94acb7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Text("Todays Orders",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: Color(0xff000000))),
              ),
              SizedBox(height: 10),
              todaysInvoices.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'No orders found!',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: todaysInvoices.length,
                      itemBuilder: (context, index) {
                        final invoice = todaysInvoices[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xffe1e8e8),
                            child: Text(
                              '${index + 1}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          title: Text(
                            invoice.customer.name,
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            DateFormat.yMMMd().format(invoice.date),
                            style: TextStyle(fontSize: 13),
                          ), // Display due date
                          trailing: Text(
                            '${invoice.customer.city.toString()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveredOrdersSection(
      BuildContext context, List<Invoice> filteredInvoices) {
    return Container(
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: context.width * 0.9,
          decoration: BoxDecoration(
            color: Color(0xff94acb7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Text("Delivered Orders",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: Color(0xff000000))),
              ),
              SizedBox(height: 10),
              filteredInvoices.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'No delivered orders found!',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredInvoices.length,
                      itemBuilder: (context, index) {
                        final invoice = filteredInvoices[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xffe1e8e8),
                            child: Text(
                              '${index + 1}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          title: Text(
                            invoice.customer.name,
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            DateFormat.yMMMd().format(invoice.date),
                            style: TextStyle(fontSize: 13),
                          ), // Display due date
                          trailing: Text(
                            '${invoice.customer.city.toString()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerAction(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          width: context.width * 0.25,
          height: context.height * 0.15,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(icon, size: 30),
                onPressed: onPressed,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Urbanist-SemiBold",
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductAction(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          width: context.width * 0.25,
          height: context.height * 0.15,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(icon, size: 30),
                onPressed: onPressed,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Urbanist-SemiBold",
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
