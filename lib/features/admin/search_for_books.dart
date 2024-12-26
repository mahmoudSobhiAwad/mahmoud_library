import 'dart:io';
import 'package:library_system/models/book_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<void> searchForBooks(LibraryRepoImpl libraryRepoImpl,
    {bool isCustomer = false}) async {
  bool repeat = true; // init condition continoue
  do {
    // ask user to enter any keyword to search for book name
    print("Enter book Name to search in or enter q to back:-");
    String? input = stdin.readLineSync(); //take user input
    if (input != null &&
        input.toLowerCase() != 'q' &&
        input.trim().isNotEmpty) {
      //validate if user is not null nor q to exist nor spaces
      List<BookModel> books = await libraryRepoImpl.searchForBooks(
          keyWord:
              input); // call function that search in library file data and return the found books
      if (books.isEmpty) {
        //validate if there is data returned back.
        print("No Data");
        repeat = false;
      } else {
        // loop to diplay each found book.
        for (var item in books) {
          item.displayInfo(isCustomer: isCustomer);
          repeat = false;
        }
      }
      // to handle back to menu with inser q or Q
    } else if (input != null && input.toLowerCase() == 'q') {
      repeat = false; //end the loop.
    } 
  } while (repeat);//as long as repeat is true .
}
