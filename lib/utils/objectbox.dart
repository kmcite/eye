import 'package:eye/objectbox.g.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final objectBoxStoreProvider = lazyProvider<Store>();

Future<Store> openObjectBox() async {
  final documents = await getApplicationDocumentsDirectory();
  return openStore(
    directory: join(documents.path, 'eye-objectbox'),
  );
}

Box<T> objectBox<T>() => objectBoxStoreProvider().box<T>();
