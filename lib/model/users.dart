class Users {
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? status;
  String? rememberToken;
  String? pp;
  DateTime? createAt;
  DateTime? updatedAt;

  Users(this.name, this.email, this.emailVerifiedAt, this.rememberToken,
      this.createAt, this.updatedAt,
      {this.status, this.pp});
}

Users dummy = Users("name", "email", "email_verified_at", "rememberToken",
    DateTime.now(), DateTime.now(),
    status: "Dummy");
