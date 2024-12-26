import 'dart:io';
import 'package:library_system/features/admin/add_new_book.dart';
import 'package:library_system/features/admin/add_new_user.dart';
import 'package:library_system/features/admin/search_for_books.dart';
import 'package:library_system/features/admin/search_for_user.dart';
import 'package:library_system/models/library_model.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<void> operationForAdmin(
    UserModel userModel, LibraryRepoImpl libraryRepoImpl) async {
  int input = -1; // init input as -1
  print("Welcom ${userModel.getUserName}"
      '\n Please Select Operation number you want to DO'); //welcome message
  do {
    // show indexed operation to admin to pick any index operation he want to do
    print(
        "1- Add User\n2- add New Books\n3- search for sepecific user info\n4- search for sepecific books\n5-display all library system \n6- Exist");
//take input from user and try to pare it , as logn it's not valid it will be -1 .
    input = int.tryParse(stdin.readLineSync() ?? '-1') ?? -1;
    if (input != -1 && (input > 0 && input <= 6)) {
      // if input doesn't ==-1 and in the range of index operations we cont..
      switch (input) {
        case 1:
          // admin can add new users.
          await addNewUser(libraryRepoImpl);
          break;
        case 2:
          // admin can add new books.
          await addNewBook(libraryRepoImpl);
          break;
        case 3:
          // admin can search for any users.
          await searchForUser(libraryRepoImpl);
          break;
        case 4:
          // admin can search for any books.
          await searchForBooks(libraryRepoImpl);
          break;
        case 5:
          // admin can display the whole system of library.
          LibrarySystem.fromJson(libraryRepoImpl.data?['library'])
              .displayAllSystem();
          break;
        case 6:
          // exist index with bye message
          print("Good Bye, ${userModel.getUserName}");
          break;
      }
    } else {
      print("Please Enter a valid Number");
    }
  } while (input != 6); //as long input doesn't mean exist we continoue.
}
