// * requiremnts related to book model:
//Books Class has attributes (id, title, borrowed) ,
//and displayInfo method.

import 'package:library_system/models/user_model.dart';

class BookModel {
  late String _bookID;
  late String _bookTitle;
  late bool _isBorrowed;
  UserModel? _borrowerUser;
  // make constructor to init values when create obj
  BookModel(
      {required String bookID,
      required String bookTitle,
      bool isBorrowed = false,
      UserModel? borrower}) {
    _bookID = bookID;
    _bookTitle = bookTitle;
    _isBorrowed = isBorrowed;
    _borrowerUser = borrower;
  }
  //setter methods for each attribute
  set setBookStatus(bool status) {
    _isBorrowed = status;
  }

  set setUserInfo(UserModel model) {
    _borrowerUser = model;
  }

  // getter methods for each attribute

  String get getBookID => _bookID;
  String get getBookTitle => _bookTitle;
  bool get checkBookStatus => _isBorrowed;

  // display method to view book details.
  void displayInfo({bool isCustomer = false}) {
    print(
        "title is :$getBookTitle -- ID is :$getBookID -- status: ${checkBookStatus ? "borrowed" : "available"}");
    if (_borrowerUser != null && !isCustomer) {
      print(
          "borrower by ${_borrowerUser!.getUserName} -- whose id is ${_borrowerUser!.getUserId}");
    }
  }

  Map<String, dynamic> toJson() => {
        "bookID": _bookID,
        "bookTitle": _bookTitle,
        "isBorrowed": _isBorrowed,
        if (_borrowerUser != null)
          "borrowerInfo": {
            "userName": _borrowerUser!.getUserName,
            "userID": _borrowerUser!.getUserId,
          },
      };

  factory BookModel.fromJson(Map<String, dynamic> json,
      {bool isFromCustomer = false}) {
    return BookModel(
        bookID: json['bookID'],
        bookTitle: json['bookTitle'],
        isBorrowed: isFromCustomer ? true : json['isBorrowed'],
        borrower: json['borrowerInfo'] != null
            ? UserModel.fromJson(json['borrowerInfo'], userIndex: 1)
            : null);
  }
}
