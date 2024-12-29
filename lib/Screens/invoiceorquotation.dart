import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicepro/Screens/invoices/select_customer.dart';

class IORQ extends StatelessWidget {
  int choice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Document'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  backgroundColor: MaterialStatePropertyAll(Color(0xFF00395d))),
              onPressed: () {
                choice = 1;
                Get.to(SelectCustomer(choice: choice));
                // Navigate to the screen for creating a new invoice
              },
              child: Text(
                'New Invoice',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20), // Space between buttons
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
                  backgroundColor: MaterialStatePropertyAll(Color(0xFF00395d))),
              onPressed: () {
                // Navigate to the screen for creating a new quotation
                choice = 2;
                Get.to(SelectCustomer(choice: choice));
              },
              child: Text(
                'New Quotation',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
