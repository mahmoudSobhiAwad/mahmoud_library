import 'dart:convert';
import 'dart:io';
import 'package:library_system/data/keys_data.dart';
import 'package:library_system/data/user_type.dart';
import 'package:library_system/models/book_model.dart';
import 'package:library_system/models/user_model.dart';
import 'package:library_system/repos/library_repo.dart';

class LibraryRepoImpl implements LibraryRepo {
  //file containing data of library.
  final File file = File('lib/data/library_data.json');
  late Map<String, dynamic>? data;
  // important method to load all data from file .
  Future<void> initialize() async {
    data = await readJson();
  }

  // check validation of user using user id and user type => customer or admin. make it nullabe to retrun null incase no user found.
  @override
  Future<UserModel?> checkValidation(
      {required LibraryUserType userType, required String userID}) async {
    if (data != null) {
      for (var item in data![libraryKey][usersKey]) {
        // check validation and compare.
        if (item['userID'] as String == userID &&
            item['userType'] as int == userType.index) {
          //if it found we return the found one
          return UserModel.fromJson(item);
        }
      }
    }
    return null;
  }

// after any process related to borrow books or retrun books the books which assigned to user is changed , so we refresh to handle cases
  Future<UserModel?> refreshData(
      {required LibraryUserType userType, required String userID}) async {
    await initialize();
    if (data != null) {
      for (var item in data![libraryKey][usersKey]) {
        if (item['userID'] as String == userID &&
            item['userType'] as int == userType.index) {
          return UserModel.fromJson(item);
        }
      }
    }
    return null;
  }

  // this method is used by admin-user with diffrent cases , for search with keyword or to get all items which is available
  @override
  Future<List<BookModel>> searchForBooks(
      {String? keyWord, bool enableFilter = false}) async {
    try {
      if (data != null) {
        List books = data?[libraryKey][bookKey]; // get all books.
        List<BookModel> list = [];
        for (var item in books) {
          //parsing each one to deal with class model form
          list.add(BookModel.fromJson(item));
        }
        if (keyWord != null) {
          // handle case if is there a keyword we want to search for books
          return list
              .where(
                  (item) => item.getBookTitle.toLowerCase().contains(keyWord))
              .toList();
        }
        //make filter to get only the list which is available to show to customer
        else if (enableFilter) {
          return list.where((item) => item.checkBookStatus == false).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // custom fucntion to read data from the file and convert from string into maping form.
  Future<Map<String, dynamic>?> readJson() async {
    //check if path is correct .
    if (await file.exists()) {
      //convert data in json format into string
      final String response = await file.readAsString();
      //using decode methood to convert it as map
      final data = await json.decode(response);
      return data;
    } else {
      // incase no file with this path.
      print("File Doesn't Exist !");
      return null;
    }
  }

  // method thad handle adding book into library file data
  @override
  Future<void> addNewBook(Map<String, dynamic> json) async {
    try {
      if (data != null) {
        // load all books of linrary
        List books = data?[libraryKey][bookKey];
        books.add(json); // add the json parsed as data as map <String,dynamic>
        data?[libraryKey]['booksNum'] =
            books.length; // update length of books in file
        await file.writeAsString(jsonEncode(data),
            mode: FileMode.write); // rewrite and update the total list.
        print("Add New Book Succesfully"); // show success adding.
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // method thad handle adding user into library file data
  @override
  Future<void> addNewUser(Map<String, dynamic> json) async {
    try {
      if (data != null) {
        // load all users of libraty
        List users = data?[libraryKey][usersKey];
        users.add(json); // add the json parsed as data as map <String,dynamic>
        data?[libraryKey]['usersNum'] =
            users.length; // update length of users in file
        await file.writeAsString(jsonEncode(data),
            mode: FileMode.write); // rewrite and update the total list.
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // method for admin to search for any user with keyword.
  @override
  Future<List<UserModel>> searchForUsers(String keyWord) async {
    try {
      if (data != null) {
        // load data of users
        List users = data?[libraryKey][usersKey];
        List<UserModel> list = [];
        for (var item in users) {
          //parsing to deal with class model format.
          list.add(UserModel.fromJson(item));
        }
        // retrun all matched user.
        return list
            .where((item) => item.getUserName.toLowerCase().contains(keyWord))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //method to update retruning books back to be available
  @override
  Future<void> returnBook(
      {required String userID, required BookModel borrowedBook}) async {
    try {
      if (data != null) {
        // load all books and all users
        var books = data?[libraryKey][bookKey];
        var users = data?[libraryKey][usersKey];
        List<BookModel> booksList = [];
        // parsing books
        for (var item in books) {
          booksList.add(BookModel.fromJson(item));
        }
        // get updated index using indexWhere anymouse function.
        int booksUpdatedIndex = booksList
            .indexWhere((item) => item.getBookID == borrowedBook.getBookID);
        // with updated index, get the specific book in list and assign to it is borrowed false and no user is attached to book
        booksList[booksUpdatedIndex] = BookModel(
            bookID: borrowedBook.getBookID,
            bookTitle: borrowedBook.getBookTitle);
        // parsing user list
        List<UserModel> usersList = [];
        for (var item in users) {
          usersList.add(UserModel.fromJson(item));
        }
        //get updated user index
        int userUpdatedIndex =
            usersList.indexWhere((item) => item.getUserId == userID);
        //update the user to remove that book from user
        usersList[userUpdatedIndex]
            .getBorrowedBooks()
            ?.removeWhere((item) => item.getBookID == borrowedBook.getBookID);

        //get the books back into map format to write in the file back.
        data?[libraryKey][bookKey] =
            booksList.map((book) => book.toJson()).toList();
        data?[libraryKey][usersKey] =
            usersList.map((user) => user.toJson()).toList();
        await file.writeAsString(jsonEncode(data), mode: FileMode.write);
        print("books is returned Successfully");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> borrowBook(
      {required UserModel userModel, required BookModel borrowedBook}) async {
    try {
      if (data != null) {
        // load all books and all users
        var books = data?[libraryKey][bookKey];
        var users = data?[libraryKey][usersKey];
        List<BookModel> booksList = [];
        // parsing books
        for (var item in books) {
          booksList.add(BookModel.fromJson(item));
        }
        // get updated index using indexWhere anymouse function.
        int booksUpdatedIndex = booksList
            .indexWhere((item) => item.getBookID == borrowedBook.getBookID);
        // with updated index, get the specific book in list and assign to it is borrowed book from user.
        booksList[booksUpdatedIndex] = borrowedBook;
        // parsing all users
        List<UserModel> usersList = [];
        for (var item in users) {
          usersList.add(UserModel.fromJson(item));
        }
        //get updated user index
        int userUpdatedIndex = usersList
            .indexWhere((item) => item.getUserId == userModel.getUserId);
        //update the user with the new
        usersList[userUpdatedIndex] = userModel;
        //convert into map format to load in file .
        data?[libraryKey][bookKey] =
            booksList.map((book) => book.toJson()).toList();
        data?[libraryKey][usersKey] =
            usersList.map((user) => user.toJson()).toList();

        await file.writeAsString(jsonEncode(data), mode: FileMode.write);

        print("books is borrowed Successfully");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
