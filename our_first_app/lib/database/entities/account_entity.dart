import 'package:floor/floor.dart';

@Entity(tableName: 'accountTable')
class Account {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String? name;
  final int? age;
  final String? dateOfBirth;
  final String? gender;
  final double? height;
  final double? weight;
  final bool? legalTermsAcceptRequired;
  final String? avatar;

  Account({required this.id, required this.name, required this.age, required this.avatar, required this.dateOfBirth, required this.gender, required this.height, required this.legalTermsAcceptRequired, required this.weight});
}