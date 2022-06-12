import 'package:flutter/cupertino.dart';
import 'package:our_first_app/database/database.dart';
import 'package:our_first_app/database/entities/account_entity.dart';

class DatabaseRepository extends ChangeNotifier{
  final AppDatabase database;

  DatabaseRepository({required this.database});

  Future<List<Account>> getAccount() async{
    return await database.accountDao.getAccount();
  }

  Future<void> insertAccount(Account account) async{
    await database.accountDao.insertAccount(account);
    notifyListeners();
  }

  Future<void> deleteAccount() async{
    await database.accountDao.deleteAccount();
    notifyListeners();
  }
}