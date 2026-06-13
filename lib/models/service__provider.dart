class ServiceProvider {
  final String name;
  final String phone;
  final String profession;
  final String experience;

  ServiceProvider({
    required this.name,
    required this.phone,
    required this.profession,
    required this.experience,
  });

  // This method converts your object into a Map for easy JSON/Backend storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'profession': profession,
      'experience': experience,
    };
  }
}