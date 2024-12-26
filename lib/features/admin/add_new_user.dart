import 'dart:io';

import 'package:library_system/core/get_unique_id.dart';
import 'package:library_system/data/user_type.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo.dart';

Future<void> addNewUser(LibraryRepo libraryRepoImpl) async {
  bool repeat = true;
  do {
    // we make admin choose to enter user details or q to back to main.
    print("Please Enter User Details Or tap q to back main options\n ");
    //admin is asked to enter user name
    print("Enter User Name:- ");
    String? userName = stdin.readLineSync(); // take input from admin.
    if (userName != null &&
        userName.toLowerCase() != 'q' &&
        userName.trim().isNotEmpty) {
      // make validation that input is not null and doesn't mean exist nor after removing spaces is not empty
      print("select user type by enter number \n 1- Admin\n 2- Customer");//show type of that user he can do to add new admin or that is customer
      String? typeIndex = stdin.readLineSync();//take the input 
      if (typeIndex != null && typeIndex.trim().isNotEmpty) { //validation in input
        int index = int.tryParse(typeIndex) ?? -1;
        if (index == 1 || index == 2) { // input must be = 1 or 2.
          await libraryRepoImpl.addNewUser(UserModel( // we call function that add user into data file 
                  userId: generateUniqeID(),
                  userName: userName,
                  userType: LibraryUserType.values[index - 1],
                  borrowedBox: index == 1 ? null : [])
              .toJson());
              //case it complete means addedd succfully 
          print(
              "Successfully add new user name is $userName as ${index == 1 ? "admin" : "customer"}");
          repeat = false;
        } else {
          //incase number is not equal 1 or 2
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
  } while (repeat); // while repeat is not true we contitnou
}
