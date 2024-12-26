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
      //check if user has borrowed books or not
      print(
          "you can't return books because you have no borrowed"); //if user hasn't he can't return any book
      isRebeat = false; // end loop
    } else {
      // we get the list of books of user.
      List<BookModel> booksList = userModel.getBorrowedBooks() ?? [];
      //check if it's not empty.
      if (booksList.isNotEmpty) {
        // display all borrowed books .
        print("Here is all borrowed books to return");
        for (int i = 0; i < booksList.length; i++) {
          print('${i + 1}-${booksList[i].getBookTitle}' '\n');
        }
        print(
            "Please Pick book number do you want to return, or enter q to back");
        //user enter the picked index book to retrun back or q to back to menu.
        String? input = stdin.readLineSync();
        // incase enter q
        if (input != null && input.toLowerCase() == 'q') {
          // end loop and back to menu
          isRebeat = false;
        } else {
          // prepare retrun book to edit in the file
          isRebeat = await prepareModelsBeforeReturnBook(
              input, booksList, userModel, libraryRepoImpl, isRebeat);
        }
      } else {
        //case no borrowed books returned
        print("there is no avaliable item ");
        isRebeat = false; //end loop.
      }
    }
  } while (isRebeat); // as long as repeat is true .
}
