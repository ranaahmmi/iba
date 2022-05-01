class User {
  final int? userId;
  final String? userName;
  final String? personName;
  final String? userRole;
  final String? branchName;
  final int? branchId;

  User({
    this.userId,
    this.userName,
    this.personName,
    this.userRole,
    this.branchName,
    this.branchId,
  });

  User copyWith({
    int? userId,
    String? userName,
    String? personName,
    String? userRole,
    String? branchName,
    int? branchId,
  }) {
    return User(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      personName: personName ?? this.personName,
      userRole: userRole ?? this.userRole,
      branchName: branchName ?? this.branchName,
      branchId: branchId ?? this.branchId,
    );
  }

  User.fromJson(Map<String, dynamic> json)
    : userId = json['user_id'] as int?,
      userName = json['user_name'] as String?,
      personName = json['person_name'] as String?,
      userRole = json['user_role'] as String?,
      branchName = json['branch_name'] as String?,
      branchId = json['branch_id'] as int?;

  Map<String, dynamic> toJson() => {
    'user_id' : userId,
    'user_name' : userName,
    'person_name' : personName,
    'user_role' : userRole,
    'branch_name' : branchName,
    'branch_id' : branchId
  };
}