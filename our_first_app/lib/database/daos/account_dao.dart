import 'package:floor/floor.dart';
import '../entities/account_entity.dart';

@dao 
abstract class AccountDao{
  @Query ('SELECT * FROM Account')
  Future<List<Account>> getAccount();

  @insert 
  Future<void> insertAccount(Account account);

  @Query ('DELETE FROM Account')
  Future<void> deleteAccount();
}