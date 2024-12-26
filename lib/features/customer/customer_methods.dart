import 'dart:io';
import 'package:library_system/data/user_type.dart';
import 'package:library_system/features/admin/search_for_books.dart';
import 'package:library_system/features/customer/borrow_book.dart';
import 'package:library_system/features/customer/return_books.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<void> operationForCustomer(
    UserModel userModel, LibraryRepoImpl libraryRepoImpl) async {
  int input =
      -1; // init for operation index which have no means to enure nothing is done !
  //welcome message contain customer name.
  print("Welcom ${userModel.getUserName}"
      '\n Please Select number Operation you want to DO');
  do {
    //method called after any operation done to add into user even borrow books or return books, to refresh data to handle some errors
    userModel = (await libraryRepoImpl.refreshData(
        userType: LibraryUserType.customer, userID: userModel.getUserId))!;
    //show all options that customer can do he only pick the appropriate index.
    print(
        "1- search for book\n2- display my profile\n3- borrow new book \n4- return book\n5- Exist");
    input = int.tryParse(stdin.readLineSync() ?? '-1') ??
        -1; // take the input as number that match operations num
    if (input != -1 && (input > 0 && input <= 5)) {
      // check if input is in range of operation valid index
      switch (input) {
        case 1:
          // offer search for books for customer by insert any key word
          await searchForBooks(libraryRepoImpl, isCustomer: true);
          break;
        case 2:
          // user can display his profile info like name,id and his borrowed books.
          userModel.displayInfo();
          break;
        case 3:
          // user can borrow book , we offer all the availabes , then he pick the index .
          await borrowBook(
              libraryRepoImpl: libraryRepoImpl, userModel: userModel);

          break;
        case 4:
        // user can return the books back after borrowed .
          await returnBook(
              libraryRepoImpl: libraryRepoImpl, userModel: userModel);
          break;
        case 5:
        // exist of app, with bye message 
          print("Good Bye, ${userModel.getUserName}");
          break;
      }
    } else {
      // incase user enter invalid number or outside range
      print("Please Enter a valid Number");
    }
  } while (input != 5); // aslong as user doesn't exist he can be in customer menu.
}
