import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoicepro/Screens/home.dart';
import 'package:invoicepro/models/invoice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoicePreviewScreen extends StatelessWidget {
  final Invoice invoice;
  InvoicePreviewScreen({required this.invoice});

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final width = PdfPageFormat.a4.width;
    final height = PdfPageFormat.a4.height;
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.copyWith(
          marginBottom: 10,
          marginLeft: 10,
          marginRight: 10,
          marginTop: 10,
        ),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
              height: height,
              width: width,
              child: pw.Column(
                children: [
                  buildHeader(),
                  pw.Container(
                    width: width * 0.9,
                    height: height * 0.8,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColors.black,
                        width: 1.0,
                      ),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            invoiceDetails(),
                            vehicleDetails(),
                          ],
                        ),
                        pw.Divider(
                          height: 0,
                          thickness: 0.5,
                          color: PdfColors.black,
                        ),
                        pw.Row(
                          children: [
                            pw.SizedBox(
                              width: width * 0.07,
                            ),
                            pw.Container(
                                width: width * 0.49,
                                height: height * 0.015,
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      top: 2, left: 5.0),
                                  child: pw.Text(
                                    "Details of Receiver | Bill to : ",
                                    style: pw.TextStyle(fontSize: 8),
                                  ),
                                )),
                            pw.Container(
                              height: height * 0.015,
                              child: pw.Padding(
                                padding:
                                    const pw.EdgeInsets.only(top: 2, left: 5.0),
                                child: pw.Text(
                                  "Details of Consignee | Shipped to : ",
                                  style: pw.TextStyle(fontSize: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.Divider(
                          height: 0,
                          thickness: 0.5,
                          color: PdfColors.black,
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 5.0),
                          child: pw.Row(
                            children: [
                              pw.SizedBox(
                                width: width * 0.56,
                                height: height * 0.05,
                                child: customerDetails(),
                              ),
                              pw.SizedBox(
                                height: height * 0.05,
                                child: customerDetails(),
                              ),
                            ],
                          ),
                        ),
                        table(),
                        table2(),
                        bottom(),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Center(
                      child: pw.Text("This is a Computer Generated Invoice",
                          style: pw.TextStyle(
                              fontSize: 6, fontWeight: pw.FontWeight.normal)))
                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget buildHeader() {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10.0),
            child: pw.Text(
              "Green Energy",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 17),
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Center(
            child: pw.Text(
              'S. NO. 12/3,HOUSE NO. 690,Mumbai Nashik Highway,Kathiyawadi Dairy, Viholi NASHIK - 422010',
              style: pw.TextStyle(fontSize: 7),
            ),
          ),
          pw.Center(
            child: pw.Text(
              'CONTACT NO: 95522662787 EMAIL: greenenergy@gmail.com',
              style: pw.TextStyle(fontSize: 7),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 2.0),
            child: pw.Center(
              child: pw.Text(
                "GSTN : 27AHUPB8856A1Z7",
                style: pw.TextStyle(fontSize: 7),
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 1.0),
            child: pw.Center(
              child: pw.Text(
                "INVOICE",
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget vehicleDetails() {
    return pw.Container(
      width: PdfPageFormat.a4.width * 0.34,
      height: PdfPageFormat.a4.height * 0.055,
      child: pw.Padding(
        padding: const pw.EdgeInsets.only(left: 4.0),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(height: 3),
            pw.Text(
              "Challan NO  : ",
              style: pw.TextStyle(fontSize: 8),
            ),
            pw.Text(
              "Challan Date            : ",
              style: pw.TextStyle(fontSize: 8),
            ),
            pw.Text(
              "Payment Terms         : Immediate",
              style: pw.TextStyle(fontSize: 8),
            ),
            pw.Text(
              "Vehicle No                 : ${invoice.vehicleNumber}",
              style: pw.TextStyle(fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget invoiceDetails() {
    final String formattedDate = DateFormat('dd-MM-yyyy').format(invoice.date!);
    return pw.Container(
      width: PdfPageFormat.a4.width * 0.56,
      height: PdfPageFormat.a4.height * 0.055,
      child: pw.Padding(
        padding: const pw.EdgeInsets.only(left: 4.0),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(height: 3),
            pw.Text(
              "Reverse Charges  : No",
              style: pw.TextStyle(fontSize: 8),
            ),
            pw.Text(
              "Invoice No            :  ${invoice.invoiceNumber}",
              style: pw.TextStyle(fontSize: 8),
            ),
            pw.Text(
              "Invoice Date         : ${formattedDate}",
              style: pw.TextStyle(fontSize: 8),
            ),
            pw.Text(
              "State                     : Maharashtra",
              style: pw.TextStyle(fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(1.0),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontSize: 8),
      ),
    );
  }

  pw.Widget tableCellWithHeight(String text, double height) {
    return pw.Container(
      height: height,
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.all(0.0),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontSize: 8),
      ),
    );
  }

  pw.Widget customerDetails() {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            invoice.customer.name, // Dynamically insert the customer name
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
            ),
          ),
          pw.Text(
            invoice.customer.address, // Dynamically insert the customer address
            style: pw.TextStyle(fontSize: 8),
          ),
          pw.Text(
            "GSTN: ${invoice.customer.gstNumber}", // Dynamically insert the GST number
            style: pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }

  pw.Widget table2() {
    return pw.Container(
        child: pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: pw.FixedColumnWidth(124),
        1: pw.FixedColumnWidth(27.0),
        2: pw.FixedColumnWidth(28.0),
        3: pw.FixedColumnWidth(106.0),
        4: pw.FixedColumnWidth(145.0),
      },
      children: [
        pw.TableRow(
          children: [
            tableCell(
              'Total',
            ),
            tableCell(
              '${invoice.quantity}',
            ),
            tableCell(
              "", // empty cell
            ),
            tableCell(
              '${invoice.taxableAmount}',
            ),
            tableCell(
              "", // empty cell
            ),
          ],
        ),
      ],
    ));
  }

  pw.Widget table() {
    return pw.Container(
      child: pw.Table(
        border: pw.TableBorder.all(color: PdfColors.black, width: 0.7),
        columnWidths: {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(4.8),
          2: pw.FlexColumnWidth(3),
          3: pw.FlexColumnWidth(2),
          4: pw.FlexColumnWidth(2),
          5: pw.FlexColumnWidth(2.8),
          6: pw.FlexColumnWidth(2.8),
          7: pw.FlexColumnWidth(1.5),
          8: pw.FlexColumnWidth(2),
          9: pw.FlexColumnWidth(1),
          10: pw.FlexColumnWidth(2),
          11: pw.FlexColumnWidth(1),
          12: pw.FlexColumnWidth(2),
          13: pw.FlexColumnWidth(2.8),
        },
        children: [
          pw.TableRow(
            children: [
              tableCell("Sr"),
              tableCell("Product / Service"),
              tableCell("HSN / HAC"),
              tableCell("Qty"),
              tableCell("Rate"),
              tableCell("Amount"),
              tableCell("Taxable Value"),
              tableCell("CGST\n%"),
              tableCell("CGST\nAmt"),
              tableCell("SGST\n%"),
              tableCell("SGST\nAmt"),
              tableCell("IGST\n%"),
              tableCell("IGST\nAmt"),
              tableCell("Total"),
            ],
          ),
          ...invoice.invoiceItems.asMap().entries.map((entry) {
            final item = entry.value;
            final index = entry.key + 1;
            return pw.TableRow(
              children: [
                tableCellWithHeight("1", 350),
                tableCellWithHeight(item.name, 20),
                tableCellWithHeight(item.hsnCode, 20),
                tableCellWithHeight(invoice.quantity.toString(), 20),
                tableCellWithHeight(invoice.rate.toStringAsFixed(2), 20),
                tableCellWithHeight(
                    invoice.taxableAmount.toStringAsFixed(2), 20),
                tableCellWithHeight(
                    invoice.taxableAmount.toStringAsFixed(2), 20),
                tableCellWithHeight("${invoice.cgstRate}", 20),
                tableCellWithHeight("${invoice.cgst}", 20),
                tableCellWithHeight("${invoice.sgstRate}", 20),
                tableCellWithHeight("${invoice.sgst}", 20),
                tableCellWithHeight("${invoice.igstRate}", 20),
                tableCellWithHeight("${invoice.igst}", 20),
                tableCellWithHeight(invoice.total.toStringAsFixed(2), 20),
              ],
            );
          }).toList(),
          // pw.TableRow(
          //   children: [
          //     tableCell(""),
          //     tableCell("Total"),
          //     tableCell(""),
          //     tableCell(invoice.quantity.toString()),
          //     tableCell(""),
          //     tableCell(invoice.taxableAmount.toStringAsFixed(2)),
          //     tableCell(invoice.taxableAmount.toStringAsFixed(2)),
          //     tableCell(""),
          //     tableCell(invoice.cgst.toStringAsFixed(2)),
          //     tableCell(""),
          //     tableCell(invoice.sgst.toStringAsFixed(2)),
          //     tableCell(""),
          //     tableCell(invoice.igst.toStringAsFixed(2)),
          //     tableCell(invoice.total.toStringAsFixed(2)),
          //   ],
          // ),
        ],
      ),
    );
  }

  pw.Widget bottom() {
    final words = numberToWords(invoice.total.round());
    return pw.Container(
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(0.0),
        child: pw.Row(
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Container(
                  height: PdfPageFormat.a4.height * 0.04,
                  width: PdfPageFormat.a4.width * 0.6,
                  padding: pw.EdgeInsets.all(4.0),
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      right: pw.BorderSide(color: PdfColors.black),
                    ),
                  ),
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 2),
                        pw.Text("Total In Words :",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal, fontSize: 8)),
                        pw.SizedBox(height: 1),
                        pw.Text(
                          words,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 9),
                        ),
                      ]),
                ),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: PdfPageFormat.a4.width * 0.6,
                      height: PdfPageFormat.a4.height * 0.06,
                      padding: pw.EdgeInsets.all(0.0),
                      decoration: pw.BoxDecoration(
                          border: pw.Border(
                              top: pw.BorderSide(color: PdfColors.black),
                              right: pw.BorderSide(color: PdfColors.black),
                              bottom: pw.BorderSide(color: PdfColors.black))),
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            top: 4, left: 4.0, bottom: 4),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Bank Details',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 9)),
                            pw.SizedBox(height: 1.0),
                            pw.Text(
                              'Bank Name & Branch        :   HDFC BANK, THATTE NAGAR NASHIK.',
                              style: pw.TextStyle(fontSize: 7),
                            ),
                            pw.Text(
                                'Account Number                :   CURRENT A/C NO: 006420200055',
                                style: pw.TextStyle(fontSize: 7)),
                            pw.Text(
                                'IFSC Code                         :   HDFC 0000064',
                                style: pw.TextStyle(fontSize: 7)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                pw.Container(
                  width: PdfPageFormat.a4.width * 0.6,
                  height: PdfPageFormat.a4.height * 0.112,
                  padding: pw.EdgeInsets.all(0.0),
                  decoration: pw.BoxDecoration(
                      border: pw.Border(
                    right: pw.BorderSide(color: PdfColors.black),
                  )),
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 4.0),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 2.0),
                        pw.Text('Terms and Conditions',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 9)),
                        pw.SizedBox(height: 1.0),
                        pw.Text('1) Goods once sold will not be taken back.',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.SizedBox(height: 1.0),
                        pw.Text(
                            '2) Our Responsibility ceases as soon as the goods leave our godown.',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.SizedBox(height: 1.0),
                        pw.Text(
                            '3) Payment Within Due Date otherwise 24% p.a. interest will be charged.',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.SizedBox(height: 1.0),
                        pw.Text('4) Subject To Nashik Jurisdiction.',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Spacer(),
                        pw.Text(
                          "Certified that the particulars given above are true and correct",
                          style: pw.TextStyle(fontSize: 7),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                amountDetails(invoice),
              ],
            )
          ],
        ),
      ),
    );
  }

  pw.Widget amountDetails(Invoice invoice) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(right: 4),
      child: pw.Container(
        width: PdfPageFormat.a4.width * 0.3,
        height: PdfPageFormat.a4.height * 0.2,
        padding: pw.EdgeInsets.only(right: 4.0),
        child: pw.Column(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 7.0, left: 4, right: 4),
              child: pw.Row(
                children: [
                  pw.Container(
                    width: PdfPageFormat.a4.width * 0.2,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Total Amount Before Tax:',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8)),
                        pw.SizedBox(height: 4.0),
                        pw.Text('Add: CGST',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 7)),
                        pw.Text('Add: SGST',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 7)),
                        pw.Text('Add: IGST',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 7)),
                        pw.SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                  pw.Spacer(), // Ensures that the next column is pushed to the right
                  pw.Container(
                    width: PdfPageFormat.a4.width * 0.08,
                    padding: pw.EdgeInsets.only(right: 6.0),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          '${invoice.taxableAmount}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        pw.SizedBox(height: 4.0),
                        pw.Text(
                          '${invoice.cgst}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        pw.Text(
                          '${invoice.sgst}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        pw.Text(
                          '${invoice.igst}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        pw.SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 8)
                ],
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Container(
              padding: pw.EdgeInsets.only(left: 0.0),
              decoration: pw.BoxDecoration(
                  border: pw.Border(
                top: pw.BorderSide(color: PdfColors.black),
                //bottom: pw.BorderSide(color: PdfColors.black),
              )),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 3),
                  pw.Row(
                    children: [
                      pw.SizedBox(width: 2),
                      pw.Container(
                        width: PdfPageFormat.a4.width * 0.2,
                        height: PdfPageFormat.a4.height * 0.01,
                        child: pw.Text(
                          'Total Amount After Tax : ',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 9),
                        ),
                      ),
                      pw.Spacer(), // Push the amount to the right
                      pw.Container(
                        padding: pw.EdgeInsets.only(right: 3.0),
                        // width: PdfPageFormat.a4.width * 0.06,
                        height: PdfPageFormat.a4.height * 0.01,
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text('${invoice.total.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 9)),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 3),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                        border: pw.Border(
                      top: pw.BorderSide(color: PdfColors.black),
                      bottom: pw.BorderSide(color: PdfColors.black),
                    )),
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 3),
                          pw.Row(
                            children: [
                              pw.SizedBox(width: 2),
                              pw.Text(
                                'GST Payable on Reverse Charge  : ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.normal,
                                    fontSize: 6),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 3),
                        ]),
                  ),
                  pw.SizedBox(height: 4.0),
                  pw.Container(
                      height: PdfPageFormat.a4.height * 0.048,
                      child: pw.Column(children: [
                        pw.SizedBox(height: 2),
                        pw.Center(
                          child: pw.Text(
                            "For                      GREEN ENERGY ",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 7),
                          ),
                        ),
                        pw.Spacer(),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "Authorised Signatory",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal, fontSize: 6),
                        ),
                      ]))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePdf(BuildContext context, Uint8List pdfData) async {
    // Use FilePicker to choose the save directory
    String? directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath == null) {
      // User canceled the picker
      return;
    }
    Get.snackbar('Success', 'Invoice created successfully!',
        backgroundColor: Colors.blueGrey, colorText: Colors.white);
    final path =
        '$directoryPath/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(path);

    await file.writeAsBytes(pdfData);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Saved to $path')),
    // );
    Get.offAll(HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Invoice Preview'),
        ),
        body: Column(
          children: [
            Container(
              height: 80, // Increase the height of the bar
              color: Colors.blue, // Optional: Set the background color
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Align buttons to the end
                children: [
                  IconButton(
                    icon: Icon(Icons.share, color: Colors.white),
                    onPressed: () async {
                      final pdfData = await _generatePdf(PdfPageFormat.a4);
                      await Printing.sharePdf(
                          bytes: pdfData, filename: 'document.pdf');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.print, color: Colors.white),
                    onPressed: () async {
                      final pdfData = await _generatePdf(PdfPageFormat.a4);
                      await Printing.layoutPdf(onLayout: (_) => pdfData);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.save, color: Colors.white),
                    onPressed: () async {
                      final pdfData = await _generatePdf(PdfPageFormat.a4);
                      await _savePdf(context, pdfData);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: PdfPreview(
                build: (format) => _generatePdf(format),
                allowPrinting: false,
                allowSharing: false,
                actions: [], // Disable default toolbar actions
                canChangePageFormat: false, // Disable page format change
                canChangeOrientation: false, // Disable orientation change
                canDebug: false, // Disable debug button
                //canChangeTheme: false, // Disable theme change
              ),
            ),
          ],
        ));
  }
}
