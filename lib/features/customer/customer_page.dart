import 'dart:io';
import 'package:library_system/data/user_type.dart';
import 'package:library_system/features/customer/customer_methods.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

void showCustomerPage() async {
  print("Welcom To Customer Side, Please Enter Your ID :-");
  int loginCounter = 0;
  UserModel? userModel;
  LibraryRepoImpl libraryRepoImpl = LibraryRepoImpl();
  await libraryRepoImpl.initialize();
  do {
    String? input = stdin.readLineSync();
    if (input != null) {
      userModel = await libraryRepoImpl.checkValidation(
          userType: LibraryUserType.customer, userID: input);
      if (userModel == null) {
        loginCounter++;
        print("There is no Matching ID with your input !, try Again ");
      }
    } else {
      loginCounter++;
      print("Please Enter a Valid Input");
    }
  } while (loginCounter < 4 && userModel == null);
  await operationForCustomer(userModel, libraryRepoImpl);
}
