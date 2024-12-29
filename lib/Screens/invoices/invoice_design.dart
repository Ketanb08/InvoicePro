import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Design extends StatefulWidget {
  const Design({super.key});

  @override
  State<Design> createState() => _DesignState();
}

class _DesignState extends State<Design> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Design"),
      ),
      body: Center(
        child: Container(
          height: context.height * 0.6,
          width: context.width * 0.85,
          color: Colors.grey,
          child: Column(
            children: [
              buildHeader(),
              Container(
                width: context.width * 0.8,
                height: context.height * 0.5,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        invoiceDetails(),
                        vehicleDetails(),
                      ],
                    ),
                    Divider(
                      height: 0,
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width * 0.07,
                        ),
                        Container(
                          width: Get.width * 0.38,
                          height: Get.height * 0.01,
                          // color: Colors.greenAccent,
                          child: Text(
                            "Details of Receiver | Bill to : ",
                            style: TextStyle(fontSize: 6),
                          ),
                        ),
                        Container(
                          height: Get.height * 0.01,
                          // color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              "Details of Consignee | Shipped to : ",
                              style: TextStyle(fontSize: 6),
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 0,
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: Get.width * 0.45,
                            height: Get.height * 0.04,
                            child: CustomerDetails(),
                          ),
                          SizedBox(
                            height: Get.height * 0.04,
                            child: CustomerDetails(),
                          )
                        ],
                      ),
                    ),
                    table(),
                    bottom(),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Text(
                    "This is a computer Generated Invoice",
                    style: TextStyle(fontSize: 5),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              "Gurukrupa Traders",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          SizedBox(height: 2),
          Center(
            child: Text(
              'PLOT NO. 47/11, PREMISES OF MANGALAM FOOD, SAIKHEDA ROAD, MIDC AREA, SHINDE NASHIK - 422102',
              style: TextStyle(fontSize: 6),
            ),
          ),
          Center(
            child: Text(
              'CONTACT NO: 9422222408, 95522662888 EMAIL: gurukrupa.traders@gmail.com',
              style: TextStyle(fontSize: 6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Center(
              child: Text(
                "GSTN : 27AHUPB8856A1Z4",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 7),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Center(
              child: Text(
                "INVOICE",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget vehicleDetails() {
    return Container(
      width: Get.width * 0.34,
      height: Get.height * 0.048,
      // color: Colors.lightGreen,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Challan NO  : ",
              style: TextStyle(fontSize: 6),
            ),
            Text(
              "Challan Date            : ",
              style: TextStyle(fontSize: 6),
            ),
            Text(
              "Payment Terms         : Immediate",
              style: TextStyle(fontSize: 6),
            ),
            Text(
              "Vehicle No                 : MH42-T-0943",
              style: TextStyle(fontSize: 6),
            ),
          ],
        ),
      ),
    );
  }
}

Widget invoiceDetails() {
  return Container(
    width: Get.width * 0.45,
    height: Get.height * 0.048,
    // color: Colors.blueGrey,
    child: Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reverse Charges  : No",
            style: TextStyle(fontSize: 6),
          ),
          Text(
            "Invoice No            : 03/24-25",
            style: TextStyle(fontSize: 6),
          ),
          Text(
            "Invoice Date         : 01/04/2024",
            style: TextStyle(fontSize: 6),
          ),
          Text(
            "State                     : Maharashtra",
            style: TextStyle(fontSize: 6),
          ),
        ],
      ),
    ),
  );
}

Widget CustomerDetails() {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Customer name",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 7)),
        Text(
          "Customer Address",
          style: TextStyle(fontSize: 6),
        ),
        Text(
          "GSTN : 27AHUPB8856A1Z4",
          style: TextStyle(fontSize: 6),
        )
      ],
    ),
  );
}

Widget table() {
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Table(
      border: TableBorder.all(color: Colors.black, width: 0.7),
      columnWidths: {
        0: FlexColumnWidth(0.5),
        1: FlexColumnWidth(2.5),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1.7),
        4: FlexColumnWidth(1.2),
        5: FlexColumnWidth(2),
        6: FlexColumnWidth(2.8),
        7: FlexColumnWidth(1.5),
        8: FlexColumnWidth(2),
        9: FlexColumnWidth(1),
        10: FlexColumnWidth(2),
        11: FlexColumnWidth(1),
        12: FlexColumnWidth(2),
        13: FlexColumnWidth(2.8),
      },
      children: [
        TableRow(children: [
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
        ]),
        TableRow(children: [
          tableCellWithHeight("1", Get.height * 0.2),
          tableCellWithHeight("FUEL OIL (2710)\n6500 LITER", Get.height * 0.2),
          tableCellWithHeight("27101950", Get.height * 0.2),
          tableCellWithHeight("6500.00", Get.height * 0.2),
          tableCellWithHeight("52.00", Get.height * 0.2),
          tableCellWithHeight("3,38,000.00", Get.height * 0.2),
          tableCellWithHeight("3,38,000.00", Get.height * 0.2),
          tableCellWithHeight("9.0\n30420.0", Get.height * 0.2),
          tableCellWithHeight("9.0\n30420.0", Get.height * 0.2),
          tableCellWithHeight("9.0\n30420.0", Get.height * 0.2),
          tableCellWithHeight("9.0\n30420.0", Get.height * 0.2),
          tableCellWithHeight("9.0\n30420.0", Get.height * 0.2),
          tableCellWithHeight("18\n0.00", Get.height * 0.2),
          tableCellWithHeight("3,98,840.00", Get.height * 0.2),
        ]),
        TableRow(children: [
          tableCell(""),
          tableCell("Total"),
          tableCell(""),
          tableCell("6,500.0"),
          tableCell(""),
          tableCell("3,38,000.00"),
          tableCell(""),
          tableCell(""),
          tableCell(""),
          tableCell(""),
          tableCell(""),
          tableCell(""),
          tableCell(""),
          tableCell(""),
        ]),
      ],
    ),
  );
}

Widget tableCell(String text) {
  return Padding(
    padding: const EdgeInsets.all(1.0),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 5),
    ),
  );
}

Widget tableCellWithHeight(String text, double height) {
  return Container(
    height: height,
    alignment: Alignment.topCenter,
    padding: const EdgeInsets.all(0.0),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 5),
    ),
  );
}

Widget tableCellofGST(String text) {
  return Container(
    alignment: Alignment.topCenter,
    padding: const EdgeInsets.all(0.0),
    child: Column(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 5),
        ),
        Text(
          "% | Amt",
          style: TextStyle(fontSize: 5),
        )
      ],
    ),
  );
}

Widget bottom() {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Total in Words
              Container(
                width: Get.width * 0.5,
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  // color: Colors.blue,
                  border: Border(
                    right: BorderSide(color: Colors.black),
                  ),
                ),
                child: Text(
                  'Total In Words:\nThree Lakh Ninety Eight Thousand Eight Hundred Forty Only.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 6),
                ),
              ),
              // Bank Details and Total Amount
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bank Details
                  Container(
                    width: Get.width * 0.5,
                    padding: EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.black),
                            //left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                            bottom: BorderSide(color: Colors.black))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bank Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 6)),
                          SizedBox(height: 1.0),
                          Text(
                            'Bank Name & Branch: HDFC BANK, THATTE NAGAR NASHIK.',
                            style: TextStyle(fontSize: 5),
                          ),
                          Text('Account Number: CURRENT A/C NO: 00642020005547',
                              style: TextStyle(fontSize: 5)),
                          Text('IFSC Code: HDFC 0000064',
                              style: TextStyle(fontSize: 5)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Terms and Conditions
              Container(
                width: Get.width * 0.5,
                height: Get.height * 0.08,
                padding: EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    border: Border(
                  right: BorderSide(color: Colors.black),
                )),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.0),
                      Text('Terms and Conditions',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 5)),
                      SizedBox(height: 1.0),
                      Text('1) Goods once sold will not be taken back.',
                          style: TextStyle(fontSize: 4)),
                      Text(
                          '2) Our Responsibility ceases as soon as the goods leave our godown.',
                          style: TextStyle(fontSize: 4)),
                      Text(
                          '3) Payment Within Due Date otherwise 24% p.a. interest will be charged.',
                          style: TextStyle(fontSize: 4)),
                      Text('4) Subject To Nashik Jurisdiction.',
                          style: TextStyle(fontSize: 4)),
                      SizedBox(
                        height: 29,
                      ),
                      Text(
                        "Certified that the particulars given above are true and correct",
                        style: TextStyle(fontSize: 5),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AmountDetails(),
            ],
          )
        ],
      ),
    ),
  );
}

Widget AmountDetails() {
  return Padding(
    padding: const EdgeInsets.all(0),
    child: Container(
      width: Get.width * 0.295,
      height: Get.height * 0.15,
      // color: Colors.blue,
      padding: EdgeInsets.all(0.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7.0, left: 4),
            child: Row(
              children: [
                Container(
                  width: Get.width * 0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Total Amount Before Tax:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 5)),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Text('Add: CGST',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 5)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Add: SGST',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 5)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Add: IGST',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 5)),
                        ],
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('338000.0',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 5)),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        Text('30420.00',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 5)),
                      ],
                    ),
                    Row(
                      children: [
                        Text('30420.00',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 5)),
                      ],
                    ),
                    Row(
                      children: [
                        Text('0.00',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 5)),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: Get.height * 0.015,
            decoration: BoxDecoration(
                // color: Colors.grey,
                border: Border(
              top: BorderSide(color: Colors.black),
              bottom: BorderSide(color: Colors.black),
            )),
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Row(
                children: [
                  Text(
                    "Total Amount After tax : ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 6),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "398840.0",
                    style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: Get.height * 0.015,
            decoration: BoxDecoration(
                // color: Colors.grey,
                border: Border(
              //top: BorderSide(color: Colors.black),
              bottom: BorderSide(color: Colors.black),
            )),
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Row(
                children: [
                  Text(
                    "GST Payon Reverse Charge :",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 5),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Text(
                  "For          GURUKRUPA TRADERS ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 5),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Authorised Signatory",
                  style: TextStyle(fontSize: 5),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
