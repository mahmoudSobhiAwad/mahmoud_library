import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<bool> prepareModelsBeforeBorrowBook(
    String? input,
    List<BookModel> booksList,
    UserModel userModel,
    LibraryRepoImpl libraryRepoImpl,
    bool isRebeat) async {
  int index = int.tryParse(input ?? "-1") ??
      -1; // try to parse input if it in range of books index or bot
  if (index != -1 && (index > 0 && index <= booksList.length)) {
    booksList[index - 1].setBookStatus =
        true; //make isborrowed attribute for the picked item to be true.
    booksList[index - 1].setUserInfo =
        userModel; //also assign the user to the book borrower.
    userModel.assignBorrowedBooks =
        booksList[index - 1]; // assign the book to the user books borrowed.
    // call the function that handle this case in file .
    await libraryRepoImpl.borrowBook(
        userModel: userModel, borrowedBook: booksList[index - 1]);
    isRebeat = false; // end loop after success process
  } else {
    // if user enter invalid index
    print("please enter a valid index");
  }
  return isRebeat;
}
