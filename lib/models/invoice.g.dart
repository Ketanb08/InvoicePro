// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceAdapter extends TypeAdapter<Invoice> {
  @override
  final int typeId = 1;

  @override
  Invoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Invoice(
      date: fields[0] as DateTime,
      invoiceNumber: fields[1] as String,
      invoiceItems: (fields[2] as List).cast<InvoiceItem>(),
      rate: fields[3] as double,
      quantity: fields[4] as int,
      taxableAmount: fields[5] as double,
      cgst: fields[6] as double,
      sgst: fields[7] as double,
      igst: fields[8] as double,
      total: fields[9] as double,
      customer: fields[10] as Customer,
      cgstRate: fields[11] as double,
      igstRate: fields[13] as double,
      sgstRate: fields[12] as double,
      vehicleNumber: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Invoice obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.invoiceNumber)
      ..writeByte(2)
      ..write(obj.invoiceItems)
      ..writeByte(3)
      ..write(obj.rate)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.taxableAmount)
      ..writeByte(6)
      ..write(obj.cgst)
      ..writeByte(7)
      ..write(obj.sgst)
      ..writeByte(8)
      ..write(obj.igst)
      ..writeByte(9)
      ..write(obj.total)
      ..writeByte(10)
      ..write(obj.customer)
      ..writeByte(11)
      ..write(obj.cgstRate)
      ..writeByte(12)
      ..write(obj.sgstRate)
      ..writeByte(13)
      ..write(obj.igstRate)
      ..writeByte(14)
      ..write(obj.vehicleNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
