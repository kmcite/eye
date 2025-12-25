import 'package:eye/domain/models/subscription_type.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/main.dart';
import 'package:manager/manager.dart';

extension X on SubscriptionPage {
  AppUser? get user {
    // return
    // usersRepository.getByEmail('')
    throw '';
  }

  SubscriptionType get type {
    // return usersRepository.item().type;
    throw '';
  }

  bool get isFree => type == SubscriptionType.free;

  void setSubscription(SubscriptionType type) {
    // usersRepository.put(user..type = type);
  }

  void cancelSubscription() {
    // usersRepository.put(user..type = SubscriptionType.free);
  }

  bool isCurrentPlan(SubscriptionType plan) {
    return plan == type;
  }
}

class SubscriptionPage extends UI {
  static String route = '/subscription';
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Subscription'.text(),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Plan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(type.displayName),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isFree
                      ? null
                      : () {
                          cancelSubscription();
                        },
                  child: Text(
                    isFree ? 'Already Free' : 'Cancel Subscription',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Plans',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: SubscriptionType.values.map((type) {
                    isCurrentPlan(type);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(type.displayName),
                                Text('\$${type.price}'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(type.description),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: isCurrentPlan(type)
                                  ? null
                                  : () => setSubscription(type),
                              child: Text(
                                isCurrentPlan(type)
                                    ? 'Selected'
                                    : 'Select Plan',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ).pad(),
    );
  }
}
