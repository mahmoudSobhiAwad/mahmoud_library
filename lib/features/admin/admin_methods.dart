import 'dart:io';
import 'package:library_system/features/admin/add_new_book.dart';
import 'package:library_system/features/admin/add_new_user.dart';
import 'package:library_system/features/admin/search_for_user.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<void> operationForAdmin(
    UserModel? userModel, LibraryRepoImpl libraryRepoImpl) async {
  if (userModel != null) {
    int input = -1;
    print("Welcom ${userModel.getUserName}"
        '\n Please Select any Operation you want to DO');
    do {
      print(
          "1- Add User\n2- add New Books\n3- display sepecific user info\n4- Exist");

      input = int.tryParse(stdin.readLineSync() ?? '-1') ?? -1;
      if (input != -1 && (input > 0 && input < 5)) {
        switch (input) {
          case 1:
           await addNewUser(libraryRepoImpl);
            break;
          case 2:
           await addNewBook(libraryRepoImpl);
            break;
          case 3:
           await searchForUser(libraryRepoImpl);
            break;
          case 4:
            print("Good Bye, ${userModel.getUserName}");
            break;
        }
      } else {
        print("Please Enter a valid Number");
      }
    } while (input != 4);
  }
}
