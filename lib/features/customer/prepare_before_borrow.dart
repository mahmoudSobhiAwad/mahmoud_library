import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<bool> prepareModelsBeforeBorrowBook(
    String? input,
    List<BookModel> booksList,
    UserModel userModel,
    LibraryRepoImpl libraryRepoImpl,
    bool isRebeat) async {
  int index = int.tryParse(input ?? "-1") ?? -1;
  if (index != -1 && (index > 0 && index <= booksList.length)) {
    booksList[index - 1].setBookStatus = true;
    booksList[index - 1].setUserInfo = userModel;
    userModel.assignBorrowedBooks = booksList[index - 1];
    await libraryRepoImpl.borrowBook(
        userModel: userModel, borrowedBook: booksList[index - 1]);
    isRebeat = false;
  } else {
    print("please enter a valid index");
  }
  return isRebeat;
}

