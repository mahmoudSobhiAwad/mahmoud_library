import 'dart:io';

import 'package:library_system/features/customer/prepare_before_retrun.dart';
import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<void> returnBook(
    {required LibraryRepoImpl libraryRepoImpl,
    required UserModel userModel}) async {
  bool isRebeat = true;
  do {
    if (userModel.getBorrowedBooks() != null &&
        userModel.getBorrowedBooks()!.isEmpty) {
      print("you can't return books because you have no borrowed");
      isRebeat = false;
    } else {
      List<BookModel> booksList = userModel.getBorrowedBooks() ?? [];
      if (booksList.isNotEmpty) {
        print("Here is all borrowed books to return");
        for (int i = 0; i < booksList.length; i++) {
          print('${i + 1}-${booksList[i].getBookTitle}' '\n');
        }
        print(
            "Please Pick book number do you want to return, or enter q to back");
        String? input = stdin.readLineSync();
        if (input != null && input.toLowerCase() == 'q') {
          isRebeat = false;
        } else {
          isRebeat = await prepareModelsBeforeReturnBook(
              input, booksList, userModel, libraryRepoImpl, isRebeat);
        }
      } else {
        print("there is no avaliable item ");
        isRebeat = false;
      }
    }
  } while (isRebeat);
}
