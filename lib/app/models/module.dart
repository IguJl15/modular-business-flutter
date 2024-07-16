class Module {
  static const modelName = "module";

  final int id;
  final String name;
  final String? description;
  final double chargedPrice;

  Module({
    required this.id,
    required this.name,
    this.description,
    required this.chargedPrice,
  });

  Module copyWith({
    int? id,
    String? name,
    String? description,
    double? chargedPrice,
  }) =>
      Module(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        chargedPrice: chargedPrice ?? this.chargedPrice,
      );

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String?,
        chargedPrice: json['charged_price'].toDouble(),
      );
}
