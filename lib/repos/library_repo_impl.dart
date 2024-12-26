import 'dart:convert';
import 'dart:io';
import 'package:library_system/data/keys_data.dart';
import 'package:library_system/data/user_type.dart';
import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo.dart';

class LibraryRepoImpl implements LibraryRepo {
  final File file = File('lib/data/library_data.json');
  late Map<String, dynamic>? data;

  Future<void> initialize() async {
    data = await readJson();
  }

  @override
  Future<UserModel?> checkValidation(
      {required LibraryUserType userType, required String userID}) async {
    if (data != null) {
      for (var item in data![libraryKey][usersKey]) {
        if (item['userID'] as String == userID &&
            item['userType'] as int == userType.index) {
          return UserModel.fromJson(item);
        }
      }
    }
    return null;
  }

  Future<UserModel?> refreshData(
      {required LibraryUserType userType, required String userID}) async {
    await initialize();
    if (data != null) {
      for (var item in data![libraryKey][usersKey]) {
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
      if (data != null) {
        List books = data?[libraryKey][bookKey];
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
      throw Exception(e.toString());
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
      if (data != null) {
        List books = data?[libraryKey][bookKey];
        books.add(json);
        data?[libraryKey]['booksNum'] = books.length;
        await file.writeAsString(jsonEncode(data), mode: FileMode.write);
        print("Add New Book Succesfully");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> addNewUser(Map<String, dynamic> json) async {
    try {
      if (data != null) {
        List users = data?[libraryKey][usersKey];
        users.add(json);
        data?[libraryKey]['usersNum'] = users.length;
        await file.writeAsString(jsonEncode(data), mode: FileMode.write);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<UserModel>> searchForUsers(String keyWord) async {
    try {
      if (data != null) {
        List users = data?[libraryKey][usersKey];
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
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> returnBook(
      {required String userID, required BookModel borrowedBook}) async {
    try {
      if (data != null) {
        var books = data?[libraryKey][bookKey];
        var users = data?[libraryKey][usersKey];
        List<BookModel> booksList = [];
        for (var item in books) {
          booksList.add(BookModel.fromJson(item));
        }
        int booksUpdatedIndex = booksList
            .indexWhere((item) => item.getBookID == borrowedBook.getBookID);
        booksList[booksUpdatedIndex] = BookModel(
            bookID: borrowedBook.getBookID,
            bookTitle: borrowedBook.getBookTitle);

        List<UserModel> usersList = [];
        for (var item in users) {
          usersList.add(UserModel.fromJson(item));
        }
        int userUpdatedIndex =
            usersList.indexWhere((item) => item.getUserId == userID);

        usersList[userUpdatedIndex]
            .getBorrowedBooks()
            ?.removeWhere((item) => item.getBookID == borrowedBook.getBookID);

        data?[libraryKey][bookKey] =
            booksList.map((book) => book.toJson()).toList();
        data?[libraryKey][usersKey] =
            usersList.map((user) => user.toJson()).toList();

        await file.writeAsString(jsonEncode(data), mode: FileMode.write);
        print("books is returned Successfully");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> borrowBook(
      {required UserModel userModel, required BookModel borrowedBook}) async {
    try {
      if (data != null) {
        var books = data?[libraryKey][bookKey];
        var users = data?[libraryKey][usersKey];
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

        data?[libraryKey][bookKey] =
            booksList.map((book) => book.toJson()).toList();
        data?[libraryKey][usersKey] =
            usersList.map((user) => user.toJson()).toList();

        await file.writeAsString(jsonEncode(data), mode: FileMode.write);

        print("books is borrowed Successfully");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
