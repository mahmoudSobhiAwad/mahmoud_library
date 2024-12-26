import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';

class LibrarySystem {
  final List<BookModel> _booksList = [];
  final List<UserModel> _usersList = [];
  LibrarySystem(
      {List<BookModel> booksList = const [],
      List<UserModel> userList = const []}) {
    _booksList.addAll(booksList);
    _usersList.addAll(userList);
  }
//encoding data from file to view as class model

  factory LibrarySystem.fromJson(Map<String, dynamic>? json) {
    List<BookModel> books = [];
    List<UserModel> users = [];
    if (json != null) {
      var booksList = json['books'] as List<dynamic>? ?? [];

      books = booksList.map((item) => BookModel.fromJson(item)).toList();
      var usersList = json['users'] as List<dynamic>? ?? [];

      users = usersList.map((item) => UserModel.fromJson(item)).toList();
    }

    return LibrarySystem(
      booksList: books,
      userList: users,
    );
  }
  //display function to see library data
  void displayAllSystem() {
    print("Mahmoud's Library");
    if (_booksList.isNotEmpty) {
      print("Library include${_booksList.length} books" '\n');
      for (var item in _booksList) {
        item.displayInfo();
      }
    }
    if (_usersList.isNotEmpty) {
      print("Library include${_usersList.length} users" '\n');
      for (var item in _usersList) {
        item.displayInfo();
      }
    }
  }
}
