import 'dart:io';

import 'package:library_system/core/get_unique_id.dart';
import 'package:library_system/models/book_model.dart';
import 'package:library_system/repos/library_repo.dart';

Future<void> addNewBook(LibraryRepo libraryRepoImpl) async {
  bool repeat = true;
  do {
    print("Please Enter book Title or tap q to back");
    String? input = stdin.readLineSync();

    if (input != null &&
        input.toLowerCase() != 'q' &&
        input.trim().isNotEmpty) {
      await libraryRepoImpl.addNewBook(
          BookModel(bookID: generateUniqeID(), bookTitle: input).toJson());
      repeat = false;
    } else if (input != null && input.toLowerCase() == 'q') {
      repeat = false;
    }
  } while (repeat);
}
