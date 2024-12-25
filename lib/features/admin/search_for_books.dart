import 'dart:io';
import 'package:library_system/models/book_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<void> searchForBooks(LibraryRepoImpl libraryRepoImpl) async {
  bool repeat = true;
  do {
    print("Enter book Name to search in or enter q to back:-");
    String? input = stdin.readLineSync();
    if (input != null &&input.toLowerCase() != 'q'&& input.trim().isNotEmpty) {
      List<BookModel> users = await libraryRepoImpl.searchForBooks(input);
      if (users.isEmpty) {
        print("No Data");
      } else {
        for (var item in users) {
          item.displayInfo();
        }
      }
    } else if (input != null && input.toLowerCase() == 'q') {
      repeat = false;
    }
  } while (repeat);
}