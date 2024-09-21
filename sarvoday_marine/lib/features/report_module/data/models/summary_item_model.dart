class ItemModel {
  final String name;
  final String price;
  final String total;

  ItemModel({
    required this.name,
    required this.price,
    required this.total,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      name: json['name'],
      price: json['price'],
      total: json['total'],
    );
  }

  // Convert ItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'total': total,
    };
  }

  @override
  String toString() {
    return 'ItemModel(name: $name, price: $price, total: $total)';
  }
}
