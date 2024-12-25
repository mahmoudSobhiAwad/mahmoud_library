import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';

class LibrarySystem {
  late List<BookModel> _booksList;
  late List<UserModel> _usersList;
  LibrarySystem(
      {List<BookModel> booksList = const [],
      List<UserModel> userList = const []}) {
    _booksList.addAll(booksList);
    _usersList.addAll(userList);
  }

  void getAllBooks() {}

  void searchForBook(String keyWord) {}
}
