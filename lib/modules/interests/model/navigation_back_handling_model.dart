class ModelNavigationBackHandling {
  String? name;
  String? username;
  String? email;
  int? userId;
  String? dob;
  String? gender;
  String? bio;
  int? mutualInterests;
  bool? isFavourite;
  bool? isConnected;
  bool? isRemoved;

  ModelNavigationBackHandling({
    this.name,
    this.username,
    this.email,
    this.userId,
    this.dob,
    this.gender,
    this.bio,
    this.mutualInterests,
    this.isFavourite = false,
    this.isConnected = false,
    this.isRemoved = false,
  });
}
