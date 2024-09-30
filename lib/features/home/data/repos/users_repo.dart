import 'package:chat_app/core/networking/exception_handler.dart';
import 'package:chat_app/core/networking/exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../models/user_model.dart';

class UserRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<Exception, List<UserModel>>> fetchUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      final users =
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
      return Right(users);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw AppExceptions.authorizationException;
      } else if (e.code == 'unavailable') {
        throw AppExceptions.networkError;
      } else {
        throw AppExceptions.defaultException;
      }
    } catch (e) {
      throw ExceptionHandler.getExceptionMessage(e);
    }
  }
}
