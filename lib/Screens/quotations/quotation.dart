import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoicepro/Screens/home.dart';
import 'package:invoicepro/models/invoice.dart';
import 'package:invoicepro/models/quotation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class QuotationPreviewScreen extends StatelessWidget {
  final Quotation quotation;
  QuotationPreviewScreen({required this.quotation});

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
                    height: height * 0.69,
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
                            quotationDetails(),
                            customerDetails(),
                          ],
                        ),
                        pw.Divider(
                          height: 0,
                          thickness: 0.5,
                          color: PdfColors.black,
                        ),
                        quotationTable(),
                        bottom(),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Center(
                      child: pw.Text("This is a Computer Generated Quotation",
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
              "GURUKRUPA TRADERS",
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
              'CONTACT NO: 9422222408, 95522662888 EMAIL: gurukrupa.traders@gmail.com',
              style: pw.TextStyle(fontSize: 7),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 2.0),
            child: pw.Center(
              child: pw.Text(
                "GSTN : 27AHUPB8856A1Z4",
                style: pw.TextStyle(fontSize: 7),
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 1.0),
            child: pw.Center(
              child: pw.Text(
                "QUOTATION",
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget quotationDetails() {
    final String formattedDate =
        DateFormat('dd-MM-yyyy').format(quotation.date!);
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
              "Quotation No        :  ${quotation.quotationNumber}",
              style: pw.TextStyle(fontSize: 8),
            ),
            pw.Text(
              "Quotation Date     : ${formattedDate}",
              style: pw.TextStyle(fontSize: 8),
            ),
            pw.Text(
              "State                    : Maharashtra",
              style: pw.TextStyle(fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget customerDetails() {
    return pw.Container(
      height: PdfPageFormat.a4.height * 0.055,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            quotation.customer.name,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
            ),
          ),
          pw.Text(
            quotation.customer.address,
            style: pw.TextStyle(fontSize: 8),
          ),
          pw.Text(
            "GSTN: ${quotation.customer.gstNumber}",
            style: pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }

  pw.Widget quotationTable() {
    return pw.Container(
      width: PdfPageFormat.a4.width * 0.9,
      height: PdfPageFormat.a4.height * 0.6,
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
          7: pw.FlexColumnWidth(1.8),
          8: pw.FlexColumnWidth(2),
          9: pw.FlexColumnWidth(1.7),
          10: pw.FlexColumnWidth(2),
          11: pw.FlexColumnWidth(1.7),
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
          ...quotation.quotationItems.asMap().entries.map((entry) {
            final item = entry.value;
            final index = entry.key + 1;
            return pw.TableRow(
              children: [
                tableCellWithHeight("1", 300),
                tableCellWithHeight(item.name, 20),
                tableCellWithHeight(item.hsnCode, 20),
                tableCellWithHeight(quotation.quantity.toString(), 20),
                tableCellWithHeight(quotation.rate.toStringAsFixed(2), 20),
                tableCellWithHeight(
                    quotation.taxableAmount.toStringAsFixed(2), 20),
                tableCellWithHeight(
                    quotation.taxableAmount.toStringAsFixed(2), 20),
                tableCellWithHeight("${quotation.cgstRate}", 20),
                tableCellWithHeight("${quotation.cgst}", 20),
                tableCellWithHeight("${quotation.sgstRate}", 20),
                tableCellWithHeight("${quotation.sgst}", 20),
                tableCellWithHeight("${quotation.igstRate}", 20),
                tableCellWithHeight("${quotation.igst}", 20),
                tableCellWithHeight(quotation.total.toStringAsFixed(2), 20),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  pw.Widget bottom() {
    final words = numberToWords(quotation.total.round());
    final terms = quotation.terms;
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
                  height: PdfPageFormat.a4.height * 0.06,
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
                                'Account Number                :   CURRENT A/C NO: 00642020005547',
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
                  height: PdfPageFormat.a4.height * 0.122,
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
                        // pw.Text('1) Goods once sold will not be taken back.',
                        //     style: pw.TextStyle(fontSize: 7)),
                        // pw.SizedBox(height: 1.0),
                        // pw.Text(
                        //     '2) Our Responsibility ceases as soon as the goods leave our godown.',
                        //     style: pw.TextStyle(fontSize: 7)),
                        // pw.SizedBox(height: 1.0),
                        pw.Text(
                            '1) Payment should be made on or before Due Date otherwise 24% p.a. interest will be charged.',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.SizedBox(height: 1.0),
                        pw.Text('2) Subject To Nashik Jurisdiction.',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.SizedBox(height: 1.0),
                        pw.Text('${quotation.terms}',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.SizedBox(height: 1.0),

                        // pw.Text(
                        //     '4) Our Responsibility ceases as soon as the goods leave our godown.',
                        //     style: pw.TextStyle(fontSize: 7)),
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
                amountDetails(quotation),
              ],
            )
          ],
        ),
      ),
    );
  }

  pw.Widget amountDetails(Quotation quoation) {
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
                          '${quotation.taxableAmount}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        pw.SizedBox(height: 4.0),
                        pw.Text(
                          '${quotation.cgst}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        pw.Text(
                          '${quotation.sgst}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        pw.Text(
                          '${quotation.igst}',
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
                        child: pw.Text('${quotation.total.toStringAsFixed(2)}',
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
                      left: pw.BorderSide(color: PdfColors.black),
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
                      height: PdfPageFormat.a4.height * 0.05,
                      child: pw.Column(children: [
                        pw.SizedBox(height: 5),
                        pw.Center(
                          child: pw.Text(
                            "For                      GURUKRUPA TRADERS ",
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

  pw.Widget tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(3.0),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 8,
        ),
      ),
    );
  }

  pw.Widget tableCellWithHeight(String text, double height) {
    return pw.Container(
      height: height,
      padding: const pw.EdgeInsets.all(3.0),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontSize: 7),
      ),
    );
  }

  Future<void> _printPdf(BuildContext context) async {
    final pdfBytes = await _generatePdf(PdfPageFormat.a4);
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes);
  }

  Future<void> _savePdf(BuildContext context, Uint8List pdfData) async {
    // Use FilePicker to choose the save directory
    String? directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath == null) {
      // User canceled the picker
      return;
    }
    Get.snackbar('Success', 'Quotation created successfully!',
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
                          bytes: pdfData, filename: 'Quotation.pdf');
                      await _savePdf(context, pdfData);
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
