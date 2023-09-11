class Product {
  final int tenantId;
  final String name;
  final String description;
  final bool isAvailable;
  final int id;

  Product({
    required this.tenantId,
    required this.name,
    required this.description,
    required this.isAvailable,
    required this.id,
  });

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      tenantId: json['tenantId'],
      name: json['name'],
      description: json['description'],
      isAvailable: json['isAvailable'],
      id: json['id'],
    );
  }
}
