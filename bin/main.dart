import 'dart:io';
import 'package:library_system/features/admin/admin_page.dart';
import 'package:library_system/features/customer/customer_page.dart';

void main(List<String> arguments) {
  int roleIndex = -1; // storing role var by init it as -1
  bool isRepeat = true; // bool var to handle looping
  print("Hello, Welcome To Mahmoud's Library");

  // Using Do While technique to make user enter the index or q to exist
  do {
    print(
        "Please Specify your role type\n 1- Admin  2-Customer or you can enter q to exit ");
    String? input = stdin.readLineSync(); // take the input from user

    if (input != null && input.toLowerCase() == 'q') {
      // Exit the loop if the user enter 'q' or 'Q' we make lower case fun
      isRepeat = false;
    } else {
      // parsing the index to check which role is
      roleIndex = int.tryParse(input ?? '-1') ?? -1;
      if (roleIndex == 1 || roleIndex == 2) {
        // If the role is valid (1 for Admin, 2 for Customer), exit the loop
        isRepeat = false;
      }
    }
  } while (isRepeat); // as long isRepat true ->continoue 

  // Handle the selected role
  switch (roleIndex) {
    case 1:
      // If the role is Admin, navigate to the admin page
      showAdminPage();
      break;
    case 2:
      // If the role is Customer, navigate to the customer page
      showCustomerPage();
      break;
    default:
      // If no valid role is selected, we exist with message
      print("Good Bye");
  }
}
