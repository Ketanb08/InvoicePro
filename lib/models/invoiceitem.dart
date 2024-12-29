import 'package:hive/hive.dart';

part 'invoiceitem.g.dart'; // Generated file for Hive TypeAdapter

@HiveType(typeId: 2) // Ensure typeId is unique across your models
class InvoiceItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String hsnCode;

  InvoiceItem({
    required this.name,
    required this.hsnCode,
  });
}
