import 'package:eye/domain/models/category.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/db.dart';

final categories = listSignal(getAll<Category>());
