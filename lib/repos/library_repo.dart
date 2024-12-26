import 'package:library_system/data/user_type.dart';
import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';

// class that has function withoud body for all library methods.
abstract class LibraryRepo {
  Future<UserModel?> checkValidation({required LibraryUserType userType,required String userID});
  Future<List<BookModel>>searchForBooks({String? keyWord ,bool enableFilter = false});
  Future<List<UserModel>>searchForUsers(String keyWord);
  Future<void>addNewBook(Map<String,dynamic>json);
  Future<void>addNewUser(Map<String,dynamic>json);
  Future<void>borrowBook({required UserModel userModel,required BookModel borrowedBook});
  Future<void>returnBook({required String userID, required BookModel borrowedBook});
}
