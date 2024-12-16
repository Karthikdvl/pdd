// models/product_item.dart
class ProductItem {
  final String name;
  final String brand;
  final DateTime openedDate;
  final DateTime expiryDate;

  ProductItem({
    required this.name,
    required this.brand,
    required this.openedDate,
    required this.expiryDate,
  });
}
