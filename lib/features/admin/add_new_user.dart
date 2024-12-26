import 'dart:io';

import 'package:library_system/core/get_unique_id.dart';
import 'package:library_system/data/user_type.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo.dart';

Future<void> addNewUser(LibraryRepo libraryRepoImpl) async {
  bool repeat = true;
  do {
    print("Please Enter User Details Or tap q to back\n ");
    print("Enter User Name:- ");
    String? userName = stdin.readLineSync();
    if (userName != null &&
        userName.toLowerCase() != 'q' &&
        userName.trim().isNotEmpty) {
      print("Enter User Type \n 1- Admin\n 2- Customer");
      String? typeIndex = stdin.readLineSync();
      if (typeIndex != null && typeIndex.trim().isNotEmpty) {
        int index = int.tryParse(typeIndex) ?? -1;
        if (index == 1 || index == 2) {
          await libraryRepoImpl.addNewUser(UserModel(
                  userId: generateUniqeID(),
                  userName: userName,
                  userType: LibraryUserType.values[index-1],
                  borrowedBox: index == 1 ? null : [])
              .toJson());
          print(
              "Successfully add new user name is $userName as ${index == 1 ? "admin" : "customer"}");
          repeat = false;
        } else {
          print("input must be 1 or 2");
        }
      } else {
        print("invalid input");
      }
    } else if (userName != null && userName.toLowerCase() == 'q') {
      repeat = false;
    } else {
      print("invalid input");
    }
  } while (repeat);
}
