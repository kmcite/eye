import '../authentication/users/users_repository.dart';

class SubscriptionModel {
  final String id;
  final int userId;
  final SubscriptionType type;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const SubscriptionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'type': type.name,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'isActive': isActive,
      };

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        id: json['id'] as String,
        userId: json['userId'] as int,
        type: SubscriptionType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => SubscriptionType.free,
        ),
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        isActive: json['isActive'] as bool,
      );

  SubscriptionModel copyWith({
    String? id,
    int? userId,
    SubscriptionType? type,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) =>
      SubscriptionModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        isActive: isActive ?? this.isActive,
      );
}
