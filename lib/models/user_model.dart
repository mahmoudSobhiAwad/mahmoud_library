import 'package:library_system/data/user_type.dart';
import 'package:library_system/models/book_model.dart';

class UserModel {
  late String _userID;
  late String _userName;
  late LibraryUserType _userType;
  late List<BookModel>? _borrowedBooks;
  UserModel(
      {required String userId,
      required String userName,
      required LibraryUserType userType,
      List<BookModel>? borrowedBox}) {
    _userID = userId;
    _userName = userName;
    _userType = userType;
    _borrowedBooks = borrowedBox;
  }
  // we assign the values already in constructor
  // but becuase list may changed we make setter for it.
  set assignBorrowedBooks(BookModel borrowedBooks) {
    if (_borrowedBooks != null) {
      _borrowedBooks!.add(BookModel(
        bookID: borrowedBooks.getBookID,
        bookTitle: borrowedBooks.getBookTitle,
        isBorrowed: true,
      ));
    }
  }

  // getter method for all user attributes
  String get getUserName => _userName;
  String get getUserId => _userID;
  LibraryUserType get getUserType => _userType;

  List<BookModel>? getBorrowedBooks() => _borrowedBooks;
  void displayInfo() {
    print(
        "name is $_userName -- user type is ${_userType.index == 0 ? "admin" : "customer"}  -- userId is $_userID");
    if (_borrowedBooks != null && _borrowedBooks!.isNotEmpty) {
      print("the borrowed books are");
      for (var item in _borrowedBooks!) {
        print(
            "book title is ${item.getBookTitle} -- bookId is ${item.getBookID}");
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "userID": _userID,
      "userType": _userType.index,
      "userName": _userName,
      if (_borrowedBooks != null) "borrowedBooks": _borrowedBooks,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json, {int? userIndex}) {
    var booksList = json['borrowedBooks'] as List<dynamic>? ?? [];

    List<BookModel> books = booksList
        .map((item) => BookModel.fromJson(item, isFromCustomer: true))
        .toList();
    return UserModel(
      userId: json['userID'],
      userName: json['userName'],
      userType: LibraryUserType.values[userIndex ?? json['userType']],
      borrowedBox: json['borrowedBooks'] != null ? books : null,
    );
  }
}
