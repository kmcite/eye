// import 'package:eye/objectbox.g.dart' show openStore;
// import 'package:objectbox/objectbox.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart'
//     show getApplicationDocumentsDirectory;

// class ObjectboxAction {}

// class EnsureInitializedAction extends ObjectboxAction {}

// abstract class ModifyObjectboxAction extends ObjectboxAction {
//   Future<void> call();
// }

// class Put<T extends Object> extends ModifyObjectboxAction {
//   final T any;
//   Put(this.any);

//   @override
//   Future<void> call() async {
//     await _box<T>().putAsync(any);
//   }
// }

// class Remove<T extends Object> extends ModifyObjectboxAction {
//   final int id;
//   Remove(this.id);

//   @override
//   Future<void> call() async {
//     await _box<T>().removeAsync(id);
//   }
// }

// Future<void> objectbox(AppState state, action, Apply apply) async {
//   switch (action) {
//     case EnsureInitializedAction():
//       await ensureInitialized();
//       break;
//     case ModifyObjectboxAction():
//       await action.call();
//       break;
//   }
// }

// Store? _store;
// Future<void> ensureInitialized() async {
//   if (_store?.isClosed() ?? true) {
//     final documentsDirectory = await getApplicationDocumentsDirectory();
//     _store = await openStore(
//       directory: join(documentsDirectory.path, 'eye'),
//     );
//   }
// }

// Box<T> _box<T>() => _store!.box<T>();

// T? getById<T>(int id) => _box<T>().get(id);

// List<T> getAll<T>() => _box<T>().getAll();
// @deprecated
// int put<T extends Object>(T any) => _box<T>().put(any);

// @deprecated
// bool remove<T>(int id) => _box<T>().remove(id);

// @deprecated
// int removeAll<T>() => _box<T>().removeAll();

// Stream<List<T>> watch<T>() =>
//     _box<T>().query().watch(triggerImmediately: true).map((it) => it.find());

// @deprecated
// void disposeStore() {
//   _store?.close();
//   _store = null;
// }
