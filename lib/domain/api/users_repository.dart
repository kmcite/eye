import 'package:eye/domain/models/app_user.dart';
import 'package:eye/utils/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:spark/spark.dart';
import 'package:http/http.dart' as http;

final usersRepositorySpark = RM.inject(
  () => UsersRepository(
    pocketbaseRM(),
  ),
);

class UsersRepository {
  bool checkIfMatches(String email, String password) {
    return false;
  }

  bool exists(String email) {
    return false;
  }

  int? byEmail(String email) {
    return null;
  }

  final PocketBase _pb;

  UsersRepository(this._pb);

  RecordService get _usersCollection => _pb.collection('users');

  /// CREATE: Create a new user record
  Future<AppUser> createUser({
    required String email,
    required String password,
    required String passwordConfirm,
    String? username,
    String? name,
  }) async {
    try {
      final body = <String, dynamic>{
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
        if (username != null) 'username': username,
        if (name != null) 'name': name,
      };

      final record = await _usersCollection.create(body: body);
      return AppUser.fromRecord(record);
    } on ClientException catch (e) {
      throw Exception(e.response['message'] ?? 'Failed to create user.');
    } catch (e) {
      throw Exception('Unexpected error creating user: $e');
    }
  }

  /// READ (Single): Get user by ID
  Future<AppUser> getUserById(String id) async {
    try {
      final record = await _usersCollection.getOne(id);
      return AppUser.fromRecord(record);
    } on ClientException catch (e) {
      throw Exception(e.response['message'] ?? 'User not found.');
    } catch (e) {
      throw Exception('Unexpected error fetching user: $e');
    }
  }

  /// READ (Paginated List): Fetch users with optional search/filter
  Future<ResultList<AppUser>> getUsers({
    int page = 1,
    int perPage = 30,
    String? filter,
    String? sort = '-created',
  }) async {
    try {
      final result = await _usersCollection.getList(
        page: page,
        perPage: perPage,
        filter: filter,
        sort: sort,
      );

      final items = result.items.map(AppUser.fromRecord).toList();

      return ResultList<AppUser>(
        page: result.page,
        perPage: result.perPage,
        totalItems: result.totalItems,
        totalPages: result.totalPages,
        items: items,
      );
    } on ClientException catch (e) {
      throw Exception(e.response['message'] ?? 'Failed to fetch users list.');
    } catch (e) {
      throw Exception('Unexpected error fetching user list: $e');
    }
  }

  /// UPDATE: Update user profile data
  Future<AppUser> updateUser({
    required String id,
    String? name,
    String? username,
    String? email,
  }) async {
    try {
      final body = <String, dynamic>{
        if (name != null) 'name': name,
        if (username != null) 'username': username,
        if (email != null) 'email': email,
      };

      final record = await _usersCollection.update(id, body: body);
      return AppUser.fromRecord(record);
    } on ClientException catch (e) {
      throw Exception(e.response['message'] ?? 'Failed to update user.');
    } catch (e) {
      throw Exception('Unexpected error updating user: $e');
    }
  }

  /// UPDATE (Avatar/Files): Upload user avatar or multipart files
  Future<AppUser> updateAvatar({
    required String id,
    required List<int> fileBytes,
    required String filename,
  }) async {
    try {
      final multipartFile = http.MultipartFile.fromBytes(
        'avatar',
        fileBytes,
        filename: filename,
      );

      final record = await _usersCollection.update(
        id,
        files: [multipartFile],
      );
      return AppUser.fromRecord(record);
    } on ClientException catch (e) {
      throw Exception(e.response['message'] ?? 'Failed to upload avatar.');
    } catch (e) {
      throw Exception('Unexpected error uploading avatar: $e');
    }
  }

  /// DELETE: Remove a user record
  Future<void> deleteUser(String id) async {
    try {
      await _usersCollection.delete(id);
    } on ClientException catch (e) {
      throw Exception(e.response['message'] ?? 'Failed to delete user.');
    } catch (e) {
      throw Exception('Unexpected error deleting user: $e');
    }
  }
}
