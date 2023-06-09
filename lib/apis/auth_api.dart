// To get User Account appwrite Account
import 'package:appwrite/appwrite.dart';
//To get User related data models Account
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../core/core.dart';
// import 'package:fpdart/fpdart.dart';

final authApiProvider = Provider(
  (ref) {
    final accountProvider = ref.watch(appWriteAccountProvider);
    return AuthApi(account: accountProvider);
  },
);

abstract class IAuthAPI {
  FutureEither<model.Account> signUp({
    required String email,
    required String passWord,
  });

  FutureEither<model.Session> logIn({
    required String email,
    required String passWord,
  });

  Future<model.Account?> getCurrentUserAccount();
}

class AuthApi implements IAuthAPI {
  final Account _account;

  AuthApi({required Account account}) : _account = account;

  @override
  Future<model.Account?> getCurrentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<model.Account> signUp(
      {required String email, required String passWord}) async {
    try {
      //  ID.unique() will generate a unique id for the user we can also use 'unique()' both are same
      final account = await _account.create(
          userId: ID.unique(), email: email, password: passWord);
      return right(account);
    } on AppwriteException catch (e, StackTrace) {
      return left(
          Failure(e.message ?? "Some Unexpected error occured: ", StackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<model.Session> logIn(
      {required String email, required String passWord}) async {
    try {
      final session =
          await _account.createEmailSession(email: email, password: passWord);
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}
