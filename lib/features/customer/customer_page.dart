import 'dart:io';
import 'package:library_system/data/user_type.dart';
import 'package:library_system/features/customer/customer_methods.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

void showCustomerPage() async {
  // welcom message for user and ask him to enter id to validate.
  print("Welcom To Customer Side, Please Enter Your ID :-");
  int failedLoginCounter = 0; //int login faild counter
  UserModel? userModel;
  LibraryRepoImpl libraryRepoImpl =
      LibraryRepoImpl(); // object of class that handle all methods related to library.
  await libraryRepoImpl
      .initialize(); // enure that loading data from file to manuiplate with it.
  do {
    String? input = stdin.readLineSync(); //take input from user
    if (input != null) {
      // validate of user id input if exist or not
      userModel = await libraryRepoImpl.checkValidation(
          userType: LibraryUserType.customer, userID: input);
      if (userModel == null) {
        // to handle case that there is user found with the same id
        failedLoginCounter++; //increase login faild counter
        print("There is no Matching ID with your input !, try Again ");
      }
    } else {
      // if user input null
      //consider as failed login counter
      failedLoginCounter++;
      print("Please Enter a Valid Input");
    }
  } while (failedLoginCounter < 4 &&
      userModel ==
          null); //as long as login attemps less that 4 or user validate pass we loop.
  if (userModel != null) {
    // if validation done. navigate to full access as customer.
    await operationForCustomer(userModel, libraryRepoImpl);
  }
}
