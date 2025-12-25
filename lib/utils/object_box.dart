import 'package:eye/main.dart';
import 'package:manager/manager.dart';

mixin ObjectBox<M extends Model> {
  final box = store.box<M>();

  /// MUTATIONS
  Future<int> put(M any) async {
    final id = box.put(any);
    itemsRM.state = getAll();
    return id;
  }

  Future<void> remove(int id) async {
    await itemsRM.setState(
      (_) async {
        await box.removeAsync(id);
        return await box.getAllAsync();
      },
    );
  }

  Future<void> removeAll() async {
    await itemsRM.setState(
      (_) async {
        await box.removeAllAsync();
        return await box.getAllAsync();
      },
    );
  }

  /// STATELESS API
  late final get = box.get;
  late final getAll = box.getAll;
  List<M> call() => box.getAll();

  /// STREAM API
  Stream<List<M>> watch() =>
      box.query().watch(triggerImmediately: true).map((it) => it.find());

  /// REACTIVE API
  M? getById(int id) => state.where((test) => test.id == id).firstOrNull;
  List<M> get state => itemsRM.state;
  bool get loading => itemsRM.isWaiting;
  late final on = itemsRM.onAll;
  late final itemsRM = RM.inject(
    () => getAll(),
  );
}
