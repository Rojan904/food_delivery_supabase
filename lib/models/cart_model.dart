// ignore_for_file: public_member_api_docs, sort_constructors_first
class CartItem {
  final String id;
  final String productId;
  final Map<String, dynamic> productData;
  int quantity;
  final String userId;
  CartItem({
    required this.id,
    required this.productId,
    required this.productData,
    required this.quantity,
    required this.userId,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'],
    productId: json['product_id'],
    productData: Map<String, dynamic>.from(json["product_data"] ?? {}),
    quantity: json['quantity'] ?? 0,
    userId: json['userId'] ?? '',
  );
}
