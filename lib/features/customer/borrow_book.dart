import 'dart:io';

import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<void> borrowBook(
    {required LibraryRepoImpl libraryRepoImpl,
    required UserModel userModel}) async {
  bool isRebeat = true;
  do {
    if (userModel.getBorrowedBooks() != null &&
        userModel.getBorrowedBooks()!.length > 2) {
      print("you can't borrow more books because you have more 2 borrowed");
      isRebeat = false;
    } else {
      List<BookModel> booksList =
          await libraryRepoImpl.searchForBooks(enableFilter: true);
      if (booksList.isNotEmpty) {
        print("Here is all available books to borrow");
        for (int i = 0; i < booksList.length; i++) {
          print('${i + 1}-${booksList[i].getBookTitle}' '\n');
        }
        print("Please Pick what do you want to borrow, or enter q to back");
        String? input = stdin.readLineSync();
        if (input != null && input.toLowerCase() == 'q') {
          isRebeat = false;
        } else {
          isRebeat = await prepareModelsBeforeBorrowBook(
              input, booksList, userModel, libraryRepoImpl, isRebeat);
        }
      } else {
        print("there is no avaliable item ");
        isRebeat = false;
      }
    }
  } while (isRebeat);
}

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
