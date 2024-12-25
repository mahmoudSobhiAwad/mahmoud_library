import 'package:library_system/data/user_type.dart';
import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';

abstract class LibraryRepo {
  Future<UserModel?> checkValidation({required LibraryUserType userType,required String userID});
  Future<List<BookModel>>searchForBooks(String keyWord);
  Future<List<UserModel>>searchForUsers(String keyWord);
  Future<void>addNewBook(Map<String,dynamic>json);
  Future<void>addNewUser(Map<String,dynamic>json);
}