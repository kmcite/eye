enum SubscriptionType {
  free,
  basic,
  premium,
}

extension SubscriptionTypeX on SubscriptionType {
  String get displayName {
    switch (this) {
      case SubscriptionType.free:
        return 'Free';
      case SubscriptionType.basic:
        return 'Basic';
      case SubscriptionType.premium:
        return 'Premium';
    }
  }

  String get description {
    switch (this) {
      case SubscriptionType.free:
        return 'Limited access to quizzes';
      case SubscriptionType.basic:
        return 'Full access to quizzes';
      case SubscriptionType.premium:
        return 'Full access to quizzes and advanced features';
    }
  }

  double get price {
    switch (this) {
      case SubscriptionType.free:
        return 0;
      case SubscriptionType.basic:
        return 9.99;
      case SubscriptionType.premium:
        return 19.99;
    }
  }
}
