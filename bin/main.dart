import 'dart:io';
import 'package:library_system/features/admin/admin_page.dart';
import 'package:library_system/features/customer_page.dart';

void main(List<String> arguments) {
  int roleIndex = -1;
  print("Hello, Welcome To Mahmoud's Library");
  // login to diffrent between each mission that will be assign to each role
  do {
    print("Please Specify your role type\n 1- Admin  2-Customer");
    roleIndex = int.tryParse(stdin.readLineSync() ?? '-1') ?? -1;
  } while (roleIndex != 1 && roleIndex != 2);

  switch (roleIndex) {
    case 1:
      //show only admin methods
      showAdminPage();
      break;
    case 2:
      //show only user methods
      showCustomerPage();
  }
}
