import 'package:hive/hive.dart';

part 'customer.g.dart'; // Ensure this matches the filename

@HiveType(typeId: 0)
class Customer {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phoneNumber;

  @HiveField(3)
  String address;

  @HiveField(4)
  String city;

  @HiveField(5)
  String gstNumber;

  // Constructor
  Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.gstNumber,
  });
}
