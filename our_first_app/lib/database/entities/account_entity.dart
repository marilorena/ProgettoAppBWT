import 'package:floor/floor.dart';


@Entity(tableName: 'account')
class Account {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String? name;
  final String? age;
  final String? dateOfBirth;
  final String? gender;
  final String? height;
  final String? weight;
  final String? legalTermsAcceptRequired;
  final String? avatar;

 Account({required this.name, required this.age, required this.avatar, required this.dateOfBirth, required this.gender, required this.height, required this.id, required this.legalTermsAcceptRequired, required this.weight});

}