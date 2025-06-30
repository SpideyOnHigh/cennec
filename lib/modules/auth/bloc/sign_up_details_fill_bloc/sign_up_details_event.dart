part of 'sign_up_details_bloc.dart';

abstract class SignUpDetailsEvent extends Equatable {
  const SignUpDetailsEvent();
  @override
  List<Object> get props => [];
}

class UploadUserSignUpDetails extends SignUpDetailsEvent {
  final Map<String, dynamic> body;
  final String url;

  const UploadUserSignUpDetails({required this.body, required this.url});
  @override
  List<Object> get props => [body, url];
}
