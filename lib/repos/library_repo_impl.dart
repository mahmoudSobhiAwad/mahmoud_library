import 'dart:convert';
import 'dart:io';
import 'package:library_system/data/user_type.dart';
import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo.dart';

class LibraryRepoImpl implements LibraryRepo {
  final File file = File('lib/data/library_data.json');
  @override
  Future<UserModel?> checkValidation(
      {required LibraryUserType userType, required String userID}) async {
    Map<String, dynamic>? data = await readJson();
    if (data != null) {
      for (var item in data['library']['users']) {
        if (item['userID'] as String == userID) {
          return UserModel.fromJson(item);
        }
      }
    }
    return null;
  }

  @override
  Future<List<BookModel>> searchForBooks(String keyWord) {
    // TODO: implement searchForBooks
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>?> readJson() async {
    if (await file.exists()) {
      final String response = await file.readAsString();
      final data = await json.decode(response);
      return data;
    } else {
      print("File Doesn't Exist !");
      return null;
    }
  }

  @override
  Future<void> addNewBook(Map<String, dynamic> json) async {
    try {
      Map<String, dynamic>? data = await readJson();
      if (data != null) {
        List books = data['library']['books'];
        books.add(json);
        data['library']['booksNum'] = books.length;
        await file.writeAsString(jsonEncode(data), mode: FileMode.write);
        print("Add New Book Succesfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> addNewUser(Map<String, dynamic> json) async {
    try {
      Map<String, dynamic>? data = await readJson();
      if (data != null) {
        List users = data['library']['users'];
        users.add(json);
        data['library']['usersNum'] = users.length;
        await file.writeAsString(jsonEncode(data), mode: FileMode.write);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<List<UserModel>> searchForUsers(String keyWord) async {
    try {
      Map<String, dynamic>? data = await readJson();
      if (data != null) {
        List users = data['library']['users'];
        List<UserModel> list = [];
        for (var item in users) {
          list.add(UserModel.fromJson(item));
        }
        return list
            .where((item) => item.getUserName.toLowerCase().contains(keyWord))
            .toList();
      }
      return [];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
