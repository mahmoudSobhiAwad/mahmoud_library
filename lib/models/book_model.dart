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

  // getter methods for each attribute
  String get getBookID => _bookID;
  String get getBookTitle => _bookTitle;
  bool get checkBookStatus => _isBorrowed;

  // display method to view book details.
  void displayInfo() {
    print("book title is :$getBookTitle");
    print("book ID is :$getBookID");
    print('book is ${checkBookStatus ? "borrowed" : "available"}');
  }

  Map<String, dynamic> toJson() => {
        "bookID": _bookID,
        "bookTitle": _bookTitle,
        "isBorrowed": _isBorrowed,
        if (_borrowerUser != null)
          "borrowerInfo": {
            "borrowerName": _borrowerUser!.getUserName,
            "borrowerID": _borrowerUser!.getUserId,
          },
      };

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
        bookID: json['bookID'],
        bookTitle: json['bookTitle'],
        isBorrowed: json['isBorrowed'],
        borrower: json['borrowerInfo'] != null
            ? UserModel.fromJson(json['borrowerInfo'],userIndex: 1)
            : null);
  }
}
