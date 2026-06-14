class ServiceModel {
  String id;
  String customerId;
  String providerId;
  String category;
  String issue;
  String status;

  ServiceModel({
    required this.id,
    required this.customerId,
    required this.providerId,
    required this.category,
    required this.issue,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "customerId": customerId,
      "providerId": providerId,
      "category": category,
      "issue": issue,
      "status": status,
    };
  }
}