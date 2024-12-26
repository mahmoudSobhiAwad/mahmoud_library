import 'dart:io';

import 'package:library_system/core/get_unique_id.dart';
import 'package:library_system/models/book_model.dart';
import 'package:library_system/repos/library_repo.dart';

Future<void> addNewBook(LibraryRepo libraryRepoImpl) async {
  bool repeat = true; // init var with true to allow always loop
  do {
    print("Please Enter book Title or tap q to back");//ask admin to insert book title or tap q to back to menu
    String? input = stdin.readLineSync();//take input from user

    if (input != null &&
        input.toLowerCase() != 'q' &&
        input.trim().isNotEmpty) { // validate to check input status null or empty or equal q 
      await libraryRepoImpl.addNewBook(
        // we generate unique id for each book to ensure no repeated id
          BookModel(bookID: generateUniqeID(), bookTitle: input).toJson());//call function that add book into library file data
      repeat = false;//end of loop by making repeat =false
    } else if (input != null && input.toLowerCase() == 'q') { //handle case back to menu
      repeat = false;//end of loop and back to menu
    }
  } while (repeat); //aslong as repeat true , the loop will be repeated
}
