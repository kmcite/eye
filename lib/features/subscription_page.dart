// import 'package:eye/domain/models/subscription_type.dart';
// import 'package:eye/domain/models/app_user.dart';
// import 'package:eye/domain/api/navigation_repository.dart';
// import 'package:eye/domain/utils/extensions.dart';
// import 'package:eye/main.dart';

// import '../domain/api/users_repository.dart';

// class SubscriptionBloc {
//   SubscriptionBloc();

//   AppUser? get user {
//     // return
//     // usersRepository.getByEmail('')
//     throw '';
//   }

//   SubscriptionType get type {
//     // return usersRepository.item().type;
//     throw '';
//   }

//   bool get isFree => type == SubscriptionType.free;

//   void setSubscription(SubscriptionType type) {
//     // usersRepository.put(user..type = type);
//   }

//   void cancelSubscription() {
//     // usersRepository.put(user..type = SubscriptionType.free);
//   }

//   bool isCurrentPlan(SubscriptionType plan) {
//     return plan == type;
//   }
// }

// class SubscriptionPage extends UI {
//   const SubscriptionPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FScaffold(
//       header: FHeader.nested(
//         prefixActions: [FHeaderAction.back(onPress: navigator.back)],
//         title: 'Subscription'.text(),
//       ),
//       content: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Current Plan',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(_subscription.type.displayName),
//                 const SizedBox(height: 16),
//                 FButton(
//                   onPress: _subscription.isFree
//                       ? null
//                       : () {
//                           _subscription.cancelSubscription();
//                         },
//                   label: Text(
//                     _subscription.isFree
//                         ? 'Already Free'
//                         : 'Cancel Subscription',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Available Plans',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Column(
//                   children: SubscriptionType.values.map((type) {
//                     _subscription.isCurrentPlan(type);
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 8.0,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(type.displayName),
//                                 Text('\$${type.price}'),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Text(type.description),
//                             const SizedBox(height: 16),
//                             FButton(
//                               onPress: _subscription.isCurrentPlan(type)
//                                   ? null
//                                   : () => _subscription.setSubscription(type),
//                               label: Text(
//                                 _subscription.isCurrentPlan(type)
//                                     ? 'Selected'
//                                     : 'Select Plan',
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ).pad(),
//     );
//   }
// }
