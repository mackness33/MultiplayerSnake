import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

@immutable
class DatabaseFriend {
  final String requester;
  final String? requesterEmail;
  final String followed;
  final String? followedEmail;
  final bool isConfirmed;
  late final bool amRequester;

  DatabaseFriend.fromRow(Map<String, dynamic> row, String userId)
      : isConfirmed = row[isConfirmedColumn] as bool,
        requester =
            (row[requesterColumn]?[idColumn] ?? row[requesterColumn]) as String,
        requesterEmail = (row[requesterColumn]?[emailColumn] ?? '') as String,
        followed =
            (row[followedColumn]?[idColumn] ?? row[followedColumn]) as String,
        followedEmail = (row[followedColumn]?[emailColumn] ?? '') as String {
    amRequester = requester == userId;
  }

  @override
  String toString() =>
      'Friends  requester = $requester, followed = $followed, isConfirmed = $isConfirmed';
  @override
  bool operator ==(covariant DatabaseFriend other) =>
      requester == other.requester && followed == other.followed;

  @override
  int get hashCode => hash2(requester.hashCode, followed.hashCode);
}

const friendTable = 'frieds';
const requesterColumn = 'requester';
const followedColumn = 'followed';
const emailColumn = 'email';
const idColumn = 'email';
const isConfirmedColumn = 'is_confirmed';
