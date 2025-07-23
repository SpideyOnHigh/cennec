class ModelError {
  String? generalError = '';
  String? invitationCode;
  String? wrongCredentials;
  String? userExists;
  String? wrongOtp;
  String? email;
  String? wrongPassword;
  String? failed;
  String? invalidPassword;
  String? interestId;
  String? requestComment;
  String? samePassword;
  String? alreadySent;
  String? newPassword;
  String? feedbackId;
  String? genderPreference;
  String? userReported;

  ModelError({
    this.invitationCode,
    this.userExists,
    this.wrongOtp,
    this.generalError = '',
    this.wrongCredentials,
    this.wrongPassword,
    this.failed,
    this.invalidPassword,
    this.interestId,
    this.requestComment,
    this.samePassword,
    this.alreadySent,
    this.genderPreference,
    this.email,
    this.newPassword,
    this.feedbackId,
    this.userReported,
  });

  ModelError.fromJson(Map<String, dynamic> json) {
    invitationCode = json['invitation_code'];
    wrongCredentials = json['wrong_credentials'];
    userExists = json['user_exists'];
    wrongOtp = json['wrong_otp'];
    email = json['email'];
    wrongPassword = json['wrong_password'];
    invalidPassword = json['password'];
    interestId = json['interest_id'];
    requestComment = json['request_comment'];
    samePassword = json['same_password'];
    newPassword = json['new_password'];
    alreadySent = json['already_sent'];
    feedbackId = json['feedback_type_id'];
    genderPreference = json['gender_preference'];
    generalError = json['failed'] ?? json['username'] ?? json['name'] ?? json['rating'] ?? '';
    userReported = json['user_reported'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invitation_code'] = invitationCode;
    data['wrong_credentials'] = wrongCredentials;
    data['user_exists'] = userExists;
    data['wrong_otp'] = wrongOtp;
    data['email'] = email;
    data['wrong_password'] = wrongPassword;
    data['password'] = invalidPassword;
    data['interest_id'] = interestId;
    data['request_comment'] = requestComment;
    data['same_password'] = samePassword;
    data['new_password'] = newPassword;
    data['already_sent'] = alreadySent;
    data['feedback_type_id'] = feedbackId;
    data['gender_preference'] = genderPreference;
    data['failed'] = generalError;
    data['user_reported'] = userReported;
    return data;
  }
}
