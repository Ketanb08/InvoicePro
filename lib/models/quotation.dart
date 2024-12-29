import 'package:hive/hive.dart';
import 'package:invoicepro/models/customer.dart';
import 'package:invoicepro/models/invoiceitem.dart';

part 'quotation.g.dart'; // Generated file for Hive TypeAdapter

@HiveType(typeId: 3) // Ensure typeId is unique across your models
class Quotation extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String quotationNumber;

  @HiveField(2)
  List<InvoiceItem> quotationItems; // List of QuotationItem

  @HiveField(3)
  double rate;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  double taxableAmount;

  @HiveField(6)
  double cgst;

  @HiveField(7)
  double sgst;

  @HiveField(8)
  double igst;

  @HiveField(9)
  double total;

  @HiveField(10)
  Customer customer;

  @HiveField(11)
  double cgstRate;

  @HiveField(12)
  double sgstRate;

  @HiveField(13)
  double igstRate;

  @HiveField(14)
  String terms;

  Quotation({
    required this.date,
    required this.quotationNumber,
    required this.quotationItems,
    required this.rate,
    required this.quantity,
    required this.taxableAmount,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.total,
    required this.customer,
    required this.cgstRate,
    required this.igstRate,
    required this.sgstRate,
    this.terms = "",
  });
}
