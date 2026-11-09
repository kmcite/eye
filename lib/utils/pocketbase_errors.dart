import 'package:pocketbase/pocketbase.dart';

String pocketBaseErrorMessage(Object error) {
  if (error is ClientException) {
    final message = error.response['message'];
    if (message is String && message.isNotEmpty) {
      if (error.statusCode > 0) {
        return 'PocketBase ${error.statusCode}: $message';
      }
      return message;
    }
    if (error.statusCode == 401 || error.statusCode == 400) {
      return 'PocketBase ${error.statusCode}: '
          'Superuser login failed. Use the email and password from '
          '`./pocketbase superuser upsert` (identity is usually the email).';
    }
    if (error.statusCode > 0) {
      return 'PocketBase HTTP ${error.statusCode}.';
    }
  }
  return error.toString();
}
