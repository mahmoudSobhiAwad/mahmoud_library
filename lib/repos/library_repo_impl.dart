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
        if (item['userID'] as String == userID &&
            item['userType'] as int == userType.index) {
          return UserModel.fromJson(item);
        }
      }
    }
    return null;
  }

  // this method is used by admin-user with diffrent cases , for search with keyword or to get all items which is available
  @override
  Future<List<BookModel>> searchForBooks(
      {String? keyWord, bool enableFilter = false}) async {
    try {
      Map<String, dynamic>? data = await readJson();
      if (data != null) {
        List books = data['library']['books'];
        List<BookModel> list = [];
        for (var item in books) {
          list.add(BookModel.fromJson(item));
        }
        if (keyWord != null) {
          return list
              .where(
                  (item) => item.getBookTitle.toLowerCase().contains(keyWord))
              .toList();
        }
        //make filter to get only the list which is available to show to customer
        else if (enableFilter) {
          return list.where((item) => item.checkBookStatus == false).toList();
        }
      }
      return [];
    } catch (e) {
      print(e.toString());
      return [];
    }
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

  @override
  Future<void> returnBook(Map<String, dynamic> json) {
    // TODO: implement returnBook
    throw UnimplementedError();
  }

  @override
  Future<void> borrowBook(
      {required UserModel userModel, required BookModel borrowedBook}) async {
    try {
      Map<String, dynamic>? data = await readJson();
      if (data != null) {
        var books = data['library']['books'];
        var users = data['library']['users'];
        List<BookModel> booksList = [];
        for (var item in books) {
          booksList.add(BookModel.fromJson(item));
        }
        int booksUpdatedIndex = booksList
            .indexWhere((item) => item.getBookID == borrowedBook.getBookID);
        booksList[booksUpdatedIndex] = borrowedBook;

        List<UserModel> usersList = [];
        for (var item in users) {
          usersList.add(UserModel.fromJson(item));
        }
        int userUpdatedIndex = usersList
            .indexWhere((item) => item.getUserId == userModel.getUserId);

        usersList[userUpdatedIndex] = userModel;

        data['library']['books'] =
            booksList.map((book) => book.toJson()).toList();
        data['library']['users'] =
            usersList.map((user) => user.toJson()).toList();

        await file.writeAsString(jsonEncode(data), mode: FileMode.write);

        print("books is borrowed Successfully");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
