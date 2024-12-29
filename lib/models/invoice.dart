import 'package:hive/hive.dart';
import 'package:invoicepro/models/customer.dart';

import 'invoiceitem.dart'; // Import the updated InvoiceItem model

part 'invoice.g.dart'; // Generated file for Hive TypeAdapter

@HiveType(typeId: 1) // Ensure typeId is unique across your models
class Invoice extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String invoiceNumber;

  @HiveField(2)
  final List<InvoiceItem> invoiceItems; // List of InvoiceItem

  @HiveField(3)
  final double rate;

  @HiveField(4)
  final int quantity;

  @HiveField(5)
  final double taxableAmount;

  @HiveField(6)
  final double cgst;

  @HiveField(7)
  final double sgst;

  @HiveField(8)
  final double igst;

  @HiveField(9)
  final double total;

  @HiveField(10)
  final Customer customer;

  @HiveField(11)
  final double cgstRate;

  @HiveField(12)
  final double sgstRate;

  @HiveField(13)
  final double igstRate;

  @HiveField(14)
  String? vehicleNumber;

  Invoice({
    required this.date,
    required this.invoiceNumber,
    required this.invoiceItems,
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
    this.vehicleNumber = "MH42T0943",
  });
}

String numberToWords(int number) {
  if (number == 0) return 'zero';

  final units = [
    '',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine'
  ];
  final teens = [
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
    'fifteen',
    'sixteen',
    'seventeen',
    'eighteen',
    'nineteen'
  ];
  final tens = [
    '',
    '',
    'twenty',
    'thirty',
    'forty',
    'fifty',
    'sixty',
    'seventy',
    'eighty',
    'ninety'
  ];
  final scales = ['', 'thousand', 'lakh', 'crore'];

  String words = '';
  int i = 0;

  while (number > 0) {
    final chunk = number % 1000;

    if (chunk > 0) {
      String chunkWords;

      if (i == 1 && chunk >= 100) {
        chunkWords =
            '${_convertChunk(chunk ~/ 100, units, teens, tens)} hundred ${_convertChunk(chunk % 100, units, teens, tens)}';
      } else {
        chunkWords = _convertChunk(chunk, units, teens, tens);
      }

      words = '$chunkWords ${scales[i]} $words'.trim();
    }

    if (i == 1) {
      number ~/= 100;
    } else {
      number ~/= 1000;
    }

    i++;
  }

  return words.trim();
}

String _convertChunk(
    int number, List<String> units, List<String> teens, List<String> tens) {
  String words = '';

  if (number >= 100) {
    words += '${units[number ~/ 100]} hundred ';
    number %= 100;
  }

  if (number >= 20) {
    words += '${tens[number ~/ 10]} ';
    number %= 10;
  } else if (number >= 10) {
    words += '${teens[number - 10]} ';
    number = 0;
  }

  if (number > 0) {
    words += units[number];
  }

  return words.trim();
}
