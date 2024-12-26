import 'dart:io';
import 'package:library_system/features/admin/admin_page.dart';
import 'package:library_system/features/customer/customer_page.dart';

void main(List<String> arguments) {
  int roleIndex = -1;
  bool isRepeat = true;
  print("Hello, Welcome To Mahmoud's Library");
  // login to diffrent between each mission that will be assign to each role
  do {
    print(
        "Please Specify your role type\n 1- Admin  2-Customer or you can enter q to exist ");
    String? input = stdin.readLineSync();
    if (input != null && input.toLowerCase() == 'q') {
      isRepeat = false;
    } else {
      roleIndex = int.tryParse(input?? '-1') ?? -1;
      if (roleIndex == 1 || roleIndex == 2) {
        isRepeat = false;
      }
    }
  } while (isRepeat);

  switch (roleIndex) {
    case 1:
      //show only admin methods
      showAdminPage();
      break;
    case 2:
      //show only user methods
      showCustomerPage();
      break;
    default:
      print("Good Bye");
  }
}
