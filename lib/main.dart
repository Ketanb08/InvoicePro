import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoicepro/Screens/home.dart';
import 'package:invoicepro/models/quotation.dart';

import 'models/customer.dart';
import 'models/invoice.dart';
import 'models/invoiceitem.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(InvoiceAdapter());
  Hive.registerAdapter(InvoiceItemAdapter());
  Hive.registerAdapter(QuotationAdapter());

  // Open boxes
  await Hive.openBox<Customer>('customers');
  await Hive.openBox<Invoice>('invoices');
  await Hive.openBox<InvoiceItem>('invoiceItems');
  await Hive.openBox<Quotation>('quotations');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
