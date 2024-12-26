import 'dart:io';

import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<void> searchForUser(LibraryRepoImpl libraryRepoImpl) async {
  bool repeat = true; // init var with true
  do {
    print(
        "Enter User Name to search with or enter q to back:-"); //ask admin to enter any user name to search with for users
    String? input = stdin.readLineSync(); // take input ..
    if (input != null &&
        input.toLowerCase() != 'q' &&
        input.trim().isNotEmpty) {
      // make validation to check user input
      List<UserModel> users = await libraryRepoImpl.searchForUsers(
          input); // call function that search in file for that name to get all the users with common input
      if (users.isEmpty) {
        // make check to see if there is data get back or no
        print("No Data"); // incase no data we print that
        repeat = false;//end the loop
      }
      //if there is dat
      else {
        //loop to display each user
        for (var item in users) {
          item.displayInfo();
        }
        repeat = false;//end loop 
      }
      // incase user choose q to back to menu
    } else if (input != null && input.toLowerCase() == 'q') {
      repeat = false;
    }
  } while (repeat); // aslong as repeat true 
}
