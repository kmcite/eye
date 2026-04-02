import 'package:eye/objectbox.g.dart' show openStore;
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

// mixin ObjectBox<M extends Model> {
//   final box = _store.box<M>();

//   /// MUTATIONS
//   Future<int> put(M any) async {
//     final id = box.put(any);
//     itemsRM.state = getAll();
//     return id;
//   }

//   Future<void> remove(int id) async {
//     await itemsRM.setState(
//       (_) async {
//         await box.removeAsync(id);
//         return await box.getAllAsync();
//       },
//     );
//   }

//   Future<void> removeAll() async {
//     await itemsRM.setState(
//       (_) async {
//         await box.removeAllAsync();
//         return await box.getAllAsync();
//       },
//     );
//   }

//   /// STATELESS API
//   late final get = box.get;
//   late final getAll = box.getAll;
//   List<M> call() => box.getAll();

//   /// STREAM API
//   Stream<List<M>> watch() =>
//       box.query().watch(triggerImmediately: true).map((it) => it.find());

//   /// REACTIVE API
//   M? getById(int id) => state.where((test) => test.id == id).firstOrNull;
//   List<M> get state => itemsRM.state;
//   bool get loading => itemsRM.isWaiting;
//   late final on = itemsRM.onAll;
//   late final itemsRM = RM.inject(
//     () => getAll(),
//   );
// }

Store? _store;
Future<void> ensureInitialized() async {
  if (_store?.isClosed() ?? true) {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    _store = await openStore(
      directory: join(documentsDirectory.path, 'eye'),
    );
  }
}

Box<T> _box<T>() => _store!.box<T>();

T? getById<T>(int id) => _box<T>().get(id);

List<T> getAll<T>() => _box<T>().getAll();

int put<T extends Object>(T any) => _box<T>().put(any);

bool remove<T>(int id) => _box<T>().remove(id);

int removeAll<T>() => _box<T>().removeAll();

Stream<List<T>> watch<T>() =>
    _box<T>().query().watch(triggerImmediately: true).map((it) => it.find());

void disposeStore() {
  _store?.close();
  _store = null;
}
