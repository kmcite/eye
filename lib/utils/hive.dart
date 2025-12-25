import 'package:eye/main.dart';

class HiveStorage extends IPersistStore {
  @override
  Future<void> delete(String key) => cache.delete(key);

  @override
  Future<void> init() async {}

  @override
  Object? read(String key) => cache.get(key);

  @override
  Future<void> write<T>(String key, T value) => cache.put(key, value);
}
