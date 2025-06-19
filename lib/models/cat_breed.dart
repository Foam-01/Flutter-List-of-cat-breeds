class CatBreed {
  final String id;
  final String name;
  final String origin;
  final String description;

  CatBreed({
    required this.id,
    required this.name,
    required this.origin,
    required this.description,
  });

  factory CatBreed.fromJson(Map<String, dynamic> json) {
    return CatBreed(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      origin: json['origin'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
