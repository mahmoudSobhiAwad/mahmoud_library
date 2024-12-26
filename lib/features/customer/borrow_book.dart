import 'dart:io';

import 'package:library_system/features/customer/prepare_before_borrow.dart';
import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<void> borrowBook(
    {required LibraryRepoImpl libraryRepoImpl,
    required UserModel userModel}) async {
  bool isRebeat = true; //init condition to continue.
  do {
    // make check the user has 2 or more borrowed to deny him to borrow more untill retrun any.
    if (userModel.getBorrowedBooks() != null &&
        userModel.getBorrowedBooks()!.length >= 2) 
        {
          // show message to illustrate why he can't borrow.
      print("you can't borrow more books because you have 2 or more borrowed");
      isRebeat = false;//end loop.
    } else {
      // if it has borrowed less than 2,
      List<BookModel> booksList =
          await libraryRepoImpl.searchForBooks(enableFilter: true); //call method to search for only availabe books which is not borrowed by others
      if (booksList.isNotEmpty) {
        // if there is available books.
        print("Here is all available books to borrow");
        // we loop to show each book  with index beside .
        for (int i = 0; i < booksList.length; i++) {
          print('${i + 1}-${booksList[i].getBookTitle}' '\n');
        }
        // ask user to enter any number of book to complete borrow process or he can enter q to back to menu.
        print(
            "Please Pick book number that you want to borrow, or enter q to back");
        String? input = stdin.readLineSync();// take user input 
        if (input != null && input.toLowerCase() == 'q') { // handle input if it's not null and equal  q or Q to back to menu 
          isRebeat = false; // end loop 
        } else {
           // else pass input index into prepare method .
          isRebeat = await prepareModelsBeforeBorrowBook(
              input, booksList, userModel, libraryRepoImpl, isRebeat);
        }
      } else {
        // incase no available books returned 
        print("there is no avaliable item ");
        isRebeat = false;//end loop
      }
    }
  } while (isRebeat); // as long as is repeat -> true 
}
