import 'dart:io';

import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo_impl.dart';

Future<void> searchForUser(LibraryRepoImpl libraryRepoImpl) async {
  bool repeat = true;
  do {
    print("Enter User Name to search with or enter q to back:-");
    String? input = stdin.readLineSync();
    if (input != null &&input.toLowerCase() != 'q'&& input.trim().isNotEmpty) {
      List<UserModel> users = await libraryRepoImpl.searchForUsers(input);
      if (users.isEmpty) {
        print("No Data");
      } else {
        for (var item in users) {
          item.displayInfo();
        }
      }
    } else if (input != null && input.toLowerCase() == 'q') {
      repeat = false;
    }
  } while (repeat);
}
