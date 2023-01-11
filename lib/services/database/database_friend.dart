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

  DatabaseFriend.notYetFriends(Map<String, dynamic> row, String userId)
      : isConfirmed = false,
        requester = userId,
        requesterEmail = null,
        followed = row[idColumn] as String,
        followedEmail = (row[emailColumn] ?? '') as String,
        amRequester = true;

  @override
  String toString() =>
      'Friends  requester = $requester, requesterEmail = $requesterEmail, followed = $followed, followed = $followedEmail isConfirmed = $isConfirmed';
  @override
  bool operator ==(covariant DatabaseFriend other) =>
      requester == other.requester && followed == other.followed;

  @override
  int get hashCode => hash2(requester.hashCode, followed.hashCode);
}

const friendTable = 'friends';
const requesterColumn = 'requester';
const followedColumn = 'followed';
const emailColumn = 'email';
const idColumn = 'id';
const isConfirmedColumn = 'is_confirmed';
