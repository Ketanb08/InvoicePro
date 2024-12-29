import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../models/invoice.dart';

Future<void> generateInvoicePdf(Invoice invoice) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('GURUKRUPA TRADERS',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text(
                'PLOT NO. 47/11, PREMISES OF MANGALAM FOOD, SAIKHEDA ROAD, MIDC AREA, SHINDE NASHIK - 422102'),
            pw.Text(
                'CONTACT NO: 9422222408, 95522662888 EMAIL: gurukrupa.traders@gmail.com'),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('INVOICE NO: 03/24-25'),
                      pw.Text('INVOICE DATE: 01/04/2024'),
                      pw.Text('STATE: Maharashtra'),
                      pw.Text('STATE CODE: 27'),
                    ]),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('CHALLAN NO:'),
                      pw.Text('CHALLAN DATE:'),
                      pw.Text('PAYMENT TERMS: IMMEDIATE'),
                      pw.Text('VEHICLE NO: MH42 T 0943'),
                    ]),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Details of Receiver | Bill to:'),
            pw.Text('ABHIJEET INFRASTRUCTURE, GAT NO. 417, DEULGAON DHANGA'),
            pw.Text('GSTIN: 27AIIPR5593F1ZR'),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(2),
                2: pw.FlexColumnWidth(2),
                3: pw.FlexColumnWidth(1),
                4: pw.FlexColumnWidth(1),
                5: pw.FlexColumnWidth(1),
                6: pw.FlexColumnWidth(1),
                7: pw.FlexColumnWidth(1),
                8: pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5), child: pw.Text('Sr')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text('Product/Service')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5), child: pw.Text('HSN/HAC')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5), child: pw.Text('Qty')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5), child: pw.Text('Rate')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5), child: pw.Text('Amount')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text('Taxable Value')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5), child: pw.Text('CGST')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5), child: pw.Text('SGST')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5), child: pw.Text('IGST')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5), child: pw.Text('Total')),
                ]),
                // Example Data Row
                pw.TableRow(children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5), child: pw.Text('1')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text('FUEL OIL (2710)')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text('27101950')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5), child: pw.Text('6500')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5), child: pw.Text('52.00')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text('3,38,000.00')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text('3,38,000.00')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text('9.0% 30420.0')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text('9.0% 30420.0')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5), child: pw.Text('0.0')),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text('3,98,840.00')),
                ]),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text(
                'Total in Words: Three Lakh Ninety Eight Thousand Eight Hundred Forty Only.'),
            pw.SizedBox(height: 20),
            pw.Text('Bank Details: HDFC BANK, THATTE NAGAR NASHIK'),
            pw.Text('Account Number: 00642020005547'),
            pw.Text('IFSC Code: HDFC 0000064'),
            pw.SizedBox(height: 20),
            pw.Text('Terms and Conditions:'),
            pw.Bullet(text: 'Goods once sold will not be taken back.'),
            pw.Bullet(
                text:
                    'Our responsibility ceases as soon as the goods leave our godown.'),
            pw.Bullet(
                text:
                    'Payment within Due Date otherwise 24% p.a. interest will be charged.'),
            pw.Bullet(text: 'Subject to Nashik Jurisdiction.'),
          ],
        );
      },
    ),
  );

  // Save PDF to the device's storage
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/invoice.pdf");
  await file.writeAsBytes(await pdf.save());

  // Share or preview PDF
  await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice.pdf');
}
