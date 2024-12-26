import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<bool> prepareModelsBeforeReturnBook(
    String? input,
    List<BookModel> booksList,
    UserModel userModel,
    LibraryRepoImpl libraryRepoImpl,
    bool isRebeat) async {
  int index = int.tryParse(input ?? "-1") ?? -1; // try to parse input
  if (index != -1 && (index > 0 && index <= booksList.length)) {
    // check if input is valid and in range between 1 - books length
    booksList[index - 1].setBookStatus =
        false; // set back attribute of book that it's isBorrowed to false
    booksList[index - 1].setUserInfo = null; // remove the user from book item
    //call the function that update changes in file
    await libraryRepoImpl.returnBook(
        userID: userModel.getUserId, borrowedBook: booksList[index - 1]);
    isRebeat = false; //end loop.
  } else {
    //incase user enter invalid input
    print("please enter a valid index");
  }
  return isRebeat; // to handle repeat case.
}
