import 'dart:io';

import 'package:library_system/data/user_type.dart';
import 'package:library_system/features/admin/admin_methods.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

void showAdminPage() async {
  //welcom to admin with asking his id to check
  print("Welcom To Admin Side, Please Enter Your ID :-");
  int failedLoginCounter =
      0; // count how many faild login to calc if 4 we exist
  UserModel?
      userModel; //preare user model which will be assign to user to cont in app
  LibraryRepoImpl libraryRepoImpl =
      LibraryRepoImpl(); // our implematianion repo that handle all cases in app
  await libraryRepoImpl
      .initialize(); // ensure to init the data that we will manipulate with.
  do {
    String? input = stdin.readLineSync(); //take input from user
    if (input != null) {
      // enusre that input is not null
      userModel = await libraryRepoImpl.checkValidation(
          userType: LibraryUserType.admin,
          userID: input); // make validate check if input matching any in data
      if (userModel == null) {
        //as long no data assign to user model, that consider as failed login attempt.
        failedLoginCounter++; // increase the failed counter
        print(
            "There is no Matching ID with your input !, try Again "); //show error message for user
      }
    } else {
      //we increase the failed counter alos incase user enter null value.
      failedLoginCounter++;
      print("Please Enter a Valid Input");
    }
  } while (failedLoginCounter < 4 &&
      userModel ==
          null); //as long failed counter is valid and the user model is assign we loop else we out
  if (userModel != null) {
    // we go to all access function for admin in case validation passed 
    await operationForAdmin(userModel, libraryRepoImpl);
  }
}
