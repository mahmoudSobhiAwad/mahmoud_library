import 'dart:io';
import 'package:library_system/features/admin/search_for_books.dart';
import 'package:library_system/features/customer/borrow_book.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<void> operationForCustomer(
    UserModel? userModel, LibraryRepoImpl libraryRepoImpl) async {
  if (userModel != null) {
    int input = -1;
    print("Welcom ${userModel.getUserName}"
        '\n Please Select any Operation you want to DO');
    do {
      print(
          "1- search for book\n2- display my borrowed books\n3-borrow new book \n4- return book\n5- Exist");

      input = int.tryParse(stdin.readLineSync() ?? '-1') ?? -1;
      if (input != -1 && (input > 0 && input <= 5)) {
        switch (input) {
          case 1:
            await searchForBooks(libraryRepoImpl, isCustomer: true);
            break;
          case 2:
            userModel.displayInfo();
            break;
          case 3:
            await borrowBook(
                libraryRepoImpl: libraryRepoImpl, userModel: userModel);
            break;
          case 4:
            //return books back
            break;
          case 5:
            print("Good Bye, ${userModel.getUserName}");
            break;
        }
      } else {
        print("Please Enter a valid Number");
      }
    } while (input != 5);
  }
}
