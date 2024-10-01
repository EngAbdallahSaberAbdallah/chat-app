import 'package:chat_app/core/networking/exception_handler.dart';
import 'package:chat_app/core/networking/exceptions.dart';
import 'package:chat_app/features/chat/data/repos/chat_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<Exception, List<UserModel>>> fetchUsers() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      final snapshot = await _firestore
          .collection(usersCollection)
          .where('uid', isNotEqualTo: currentUserId)
          .get();
      final users =
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
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
