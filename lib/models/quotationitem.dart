class QuotationItem {
  final String name;
  final String hsnCode;
  final int quantity;
  final double rate;
  final double taxableAmount;
  final double cgstRate;
  final double cgst;
  final double sgstRate;
  final double sgst;
  final double igstRate;
  final double igst;
  final double total;

  QuotationItem({
    required this.name,
    required this.hsnCode,
    required this.quantity,
    required this.rate,
    required this.taxableAmount,
    required this.cgstRate,
    required this.cgst,
    required this.sgstRate,
    required this.sgst,
    required this.igstRate,
    required this.igst,
    required this.total,
  });
}
