import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class NavigationRepository {
  GlobalKey<NavigatorState> get key => navigation.navigatorKey;

  final navigation = RM.navigate;
  final scaffold = RM.scaffold;

  late final to = navigation.to;
  late final toReplacement = navigation.toReplacement;
  late final back = navigation.back;
  late final toAndRemoveUntil = navigation.toAndRemoveUntil;
  late final dialog = navigation.toDialog;
  BuildContext get context => RM.context!;
}
