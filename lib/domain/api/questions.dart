import 'package:eye/main.dart';
import 'package:eye/utils/db.dart';

import '../models/question.dart';

final questions = listSignal(getAll<Question>());
