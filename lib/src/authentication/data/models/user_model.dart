import 'dart:convert';

import '../../../../core/utils/typedef.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.createdAt,
    required super.name,
    required super.avatar,
  });

  const UserModel.empty()
      : this(
          id: '_empty.id',
          createdAt: '_empty.createdAt',
          name: '_empty.name',
          avatar: '_empty.avatar',
        );

  UserModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          createdAt: map['createdAt'] as String,
          name: map['name'] as String,
          avatar: map['avatar'] as String,
        );
  factory UserModel.fromJson(String json) => UserModel.fromMap(jsonDecode(json) as DataMap);

  DataMap toMap() => {
        'id': id,
        'createdAt': createdAt,
        'name': name,
        'avatar': avatar,
      };
  String toJson() => jsonEncode(toMap());

  UserModel copyWith({
    String? id,
    String? createdAt,
    String? name,
    String? avatar,
  }) =>
      UserModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
      );
}
