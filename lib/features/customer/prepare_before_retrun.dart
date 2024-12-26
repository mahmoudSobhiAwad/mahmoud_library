import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<bool> prepareModelsBeforeReturnBook(
    String? input,
    List<BookModel> booksList,
    UserModel userModel,
    LibraryRepoImpl libraryRepoImpl,
    bool isRebeat) async {
  int index = int.tryParse(input ?? "-1") ?? -1;
  if (index != -1 && (index > 0 && index <= booksList.length)) {
    booksList[index - 1].setBookStatus = false;
    booksList[index - 1].setUserInfo = null;
    await libraryRepoImpl.returnBook(
        userID: userModel.getUserId, borrowedBook: booksList[index - 1]);
    isRebeat = false;
  } else {
    print("please enter a valid index");
  }
  return isRebeat;
}
