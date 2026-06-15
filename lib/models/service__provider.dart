class ServiceProvider {
  final String id;
  final String name;
  final String phone;
  final String profession;
  final String experience;
  final bool isAvailable;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.phone,
    required this.profession,
    required this.experience,
    required this.isAvailable,
  });

  // 🔥 Convert object → Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'profession': profession,
      'experience': experience,
      'isAvailable': isAvailable,
    };
  }

  // 🔥 Convert Firestore → object
  factory ServiceProvider.fromJson(String id, Map<String, dynamic> json) {
    return ServiceProvider(
      id: id,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      profession: json['profession'] ?? '',
      experience: json['experience'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}